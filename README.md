# Multilevelerror

**Multilevelerror** is an R package designed for influence diagnostics in multilevel meta-analysis (3-level models). It extends the functionality of the `metafor` package by providing tools to identify influential effects and studies in complex nested models.

## Features

- **Leave-One-Effect-Out (LOEO):** Identify individual effect sizes that disproportionately influence the pooled estimate.
- **Leave-One-Study-Out (LOSO):** Assess the stability of results across entire studies (group-level influence).
- **Cook's Distance:** Formal quantification of multivariate influence.
- **Variance Component Stability:** Monitor changes in level-2 and level-3 heterogeneity ($\sigma^2$) when specific units are removed.
- **Parallel Processing:** Support for large datasets via multicore execution.

## Installation

```r
# remotes::install_github("mahmoodahmad/Multilevelerror")
```

## Quick Start

```r
library(Multilevelerror)
library(metafor)
library(metadat)

# Fit a 3-level model
data(dat.assink2016)
dat <- dat.assink2016
model <- rma.mv(yi, vi, random = ~ 1 | study / esid, data = dat)

# Calculate study-level diagnostics
inf_study <- influence_multilevel(model, level = "study", study_var = "study")
print(inf_study)

# Plot Cook's Distance
plot_multilevel_influence(inf_study, type = "cook")
```

## License

GPL-3
