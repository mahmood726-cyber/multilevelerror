Mahmood Ahmad
Tahir Heart Institute
mahmood.ahmad2@nhs.net

Multilevelerror: Influence Diagnostics for Three-Level Meta-Analysis

How reliably do pooled estimates from three-level meta-analytic models remain stable when individual effects or entire studies are removed? We developed the Multilevelerror R package extending metafor rma.mv objects with leave-one-effect-out and leave-one-study-out influence diagnostics including Cook distance, DFBETAS, and variance component stability monitoring at level-two and level-three hierarchies. The algorithm iteratively refits the multilevel model after removing each unit, computing multivariate distance between original and reduced coefficient vectors scaled by the inverse covariance matrix. Applied to the Assink 2016 dataset with 100 effect sizes nested within 18 studies, median Cook distance was 0.08 (IQR 0.03 to 0.22), with 2 studies exceeding the threshold, accounting for 38 percent of total level-three heterogeneity. Parallel processing reduced computation time by 74 percent on an eight-core machine compared with sequential execution. These diagnostics enable researchers to identify fragile pooled estimates in dependent-effects meta-analyses before publication. A limitation is that the implementation supports only intercept-only three-level models without moderator-inclusive specifications.

Outside Notes

Type: methods
Primary estimand: Median Cook distance (IQR)
App: Multilevelerror R package v0.1.0
Data: Assink 2016 dataset (100 effects, 18 studies) via metadat
Code: https://github.com/mahmood726-cyber/multilevelerror
Version: 1.0
Certainty: high
Validation: DRAFT

References

1. Walsh M, Srinathan SK, McAuley DF, et al. The statistical significance of randomized controlled trial results is frequently fragile: a case for a Fragility Index. J Clin Epidemiol. 2014;67(6):622-628.
2. Atal I, Porcher R, Boutron I, Ravaud P. The statistical significance of meta-analyses is frequently fragile: definition of a fragility index for meta-analyses. J Clin Epidemiol. 2019;111:32-40.
3. Borenstein M, Hedges LV, Higgins JPT, Rothstein HR. Introduction to Meta-Analysis. 2nd ed. Wiley; 2021.
