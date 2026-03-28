library(testthat)
library(Multilevelerror)
library(metafor)

test_that("influence_multilevel works with simulated data", {
  set.seed(123)
  k <- 10 # studies
  m <- 3  # effects per study
  n <- k * m
  study_id <- rep(1:k, each = m)
  yi <- rnorm(n)
  vi <- runif(n, 0.01, 0.05)
  dat <- data.frame(yi, vi, study_id)
  
  # Fit 3-level model
  res <- metafor::rma.mv(yi, vi, random = ~ 1 | study_id, data = dat)
  
  # 1. Test LOEO (Leave-One-Effect-Out)
  inf_e <- influence_multilevel(res, level = "effect")
  expect_s3_class(inf_e, "multilevel_influence")
  expect_equal(length(inf_e$ids), n)
  expect_true(all(c("betas", "sigma2s", "cooks_d") %in% names(inf_e)))
  
  # 2. Test LOSO (Leave-One-Study-Out)
  inf_s <- influence_multilevel(res, level = "study", study_var = "study_id")
  expect_s3_class(inf_s, "multilevel_influence")
  expect_equal(length(inf_s$ids), k)
})
