#' Influence Diagnostics for Multilevel Meta-Analysis
#'
#' @description Computes leave-one-out influence diagnostics for multilevel meta-analysis models (rma.mv objects).
#' Supports both Leave-One-Effect-Out (LOEO) and Leave-One-Study-Out (LOSO) diagnostics.
#'
#' @param model An object of class "rma.mv".
#' @param level Character. Either "effect" (default) for LOEO or "study" for LOSO.
#' @param study_var Character. The name of the grouping variable if level = "study".
#' @param parallel Logical. Use parallel processing?
#' @param n_cores Number of cores to use if parallel = TRUE.
#' @return An object of class "multilevel_influence".
#' @importFrom metafor rma.mv
#' @importFrom stats coef update solve
#' @importFrom parallel makeCluster stopCluster parLapply clusterExport detectCores
#' @export
influence_multilevel <- function(model, level = c("effect", "study"), study_var = NULL, parallel = FALSE, n_cores = NULL) {
  level <- match.arg(level)
  
  if (!inherits(model, "rma.mv")) stop("Model must be an 'rma.mv' object.")
  
  # Ensure the data is actually in the model object
  data <- model$data
  if (is.null(data)) stop("Data must be stored in the model object. Use data = ... in rma.mv().")
  
  if (level == "study") {
    if (is.null(study_var)) stop("For study-level diagnostics, 'study_var' must be specified.")
    ids <- unique(data[[study_var]])
    n_units <- length(ids)
  } else {
    n_units <- nrow(data)
    ids <- 1:n_units
  }
  
  orig_beta <- as.vector(stats::coef(model))
  orig_sigma2 <- model$sigma2
  p <- length(orig_beta)
  cov_beta_inv <- solve(model$vb)
  
  cat(sprintf("Calculating %s influence diagnostics for %d units...\n", level, n_units))
  
  # Function for a single unit
  fit_unit <- function(i) {
    if (level == "study") {
      sub_data <- data[data[[study_var]] != ids[i], ]
    } else {
      sub_data <- data[-i, ]
    }
    
    # We use a more direct way to re-fit by updating the call
    # This is more robust than stats::update inside functions
    fit_i <- tryCatch({
      # Capture the call and replace data
      new_call <- model$call
      new_call$data <- sub_data
      eval(new_call)
    }, error = function(e) NULL)
    
    if (is.null(fit_i)) return(NULL)
    
    curr_beta <- as.vector(stats::coef(fit_i))
    
    # Safety check for beta length (if a level of a factor is dropped)
    if (length(curr_beta) != p) return(NULL)
    
    diff <- matrix(orig_beta - curr_beta, ncol = 1)
    cook_d <- as.numeric(t(diff) %*% cov_beta_inv %*% diff) / p
    
    res <- list(
      id = ids[i],
      beta = curr_beta,
      sigma2 = fit_i$sigma2,
      QE = fit_i$QE,
      k = fit_i$k,
      cook_d = cook_d
    )
    return(res)
  }
  
  if (parallel) {
    if (is.null(n_cores)) n_cores <- parallel::detectCores() - 1
    cl <- parallel::makeCluster(max(1, n_cores))
    on.exit(parallel::stopCluster(cl))
    # We need to export metafor because eval(new_call) calls rma.mv
    parallel::clusterExport(cl, varlist = c("data", "ids", "level", "study_var", "model", "orig_beta", "cov_beta_inv", "p"), envir = environment())
    parallel::clusterEvalQ(cl, library(metafor))
    results <- parallel::parLapply(cl, 1:n_units, fit_unit)
  } else {
    results <- lapply(1:n_units, fit_unit)
  }
  
  # Process results
  valid_results <- Filter(Negate(is.null), results)
  if (length(valid_results) == 0) stop("All leave-one-out models failed to converge.")
  
  ids_valid <- sapply(valid_results, function(x) x$id)
  betas <- t(sapply(valid_results, function(x) x$beta))
  sigma2s <- t(sapply(valid_results, function(x) x$sigma2))
  cooks_d <- sapply(valid_results, function(x) x$cook_d)
  
  out <- list(
    ids = ids_valid,
    betas = betas,
    sigma2s = sigma2s,
    cooks_d = cooks_d,
    orig_beta = orig_beta,
    orig_sigma2 = orig_sigma2,
    level = level,
    study_var = study_var
  )
  class(out) <- "multilevel_influence"
  return(out)
}

#' Print Multilevel Influence Diagnostics
#'
#' @param x multilevel_influence object.
#' @param ... Additional arguments.
#' @export
print.multilevel_influence <- function(x, ...) {
  cat("Multilevel Meta-Analysis Influence Diagnostics\n")
  cat(sprintf("Level: %s | Units: %d\n", x$level, length(x$ids)))
  cat("---------------------------------------------\n")
  cat("Top Influential Units (by Cook's D):\n")
  top_idx <- order(x$cooks_d, decreasing = TRUE)[1:min(5, length(x$ids))]
  df <- data.frame(ID = x$ids[top_idx], CooksD = x$cooks_d[top_idx])
  print(df)
}

#' Plot Multilevel Influence Diagnostics
#'
#' @param x multilevel_influence object.
#' @param type "cook" or "sigma".
#' @return ggplot object.
#' @import ggplot2
#' @importFrom tools toTitleCase
#' @export
plot_multilevel_influence <- function(x, type = c("cook", "sigma")) {
  type <- match.arg(type)
  
  Index <- Value <- NULL
  
  df <- data.frame(
    ID = as.factor(x$ids),
    Value = if(type == "cook") x$cooks_d else x$sigma2s[, 1],
    Index = 1:length(x$ids)
  )
  
  p <- ggplot2::ggplot(df, ggplot2::aes(x = Index, y = Value)) +
    ggplot2::geom_point() +
    ggplot2::geom_segment(ggplot2::aes(x = Index, xend = Index, y = 0, yend = Value), alpha = 0.3) +
    ggplot2::theme_minimal() +
    ggplot2::labs(x = if(x$level == "study") "Study Index" else "Effect Size Index",
         y = if(type == "cook") "Cook's Distance" else "Level-2 Variance (Sigma^2_2)",
         title = sprintf("%s-Level Influence Diagnostics", tools::toTitleCase(x$level)))
  
  if (type == "cook") {
    cutoff <- 4 / length(x$ids)
    p <- p + ggplot2::geom_hline(yintercept = cutoff, color = "red", linetype = "dashed")
  }
  
  return(p)
}

utils::globalVariables(c("Index", "Value"))
