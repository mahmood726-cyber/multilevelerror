# E156 Protocol — `Multilevelerror`

This repository is the source code and dashboard backing an E156 micro-paper on the [E156 Student Board](https://mahmood726-cyber.github.io/e156/students.html).

---

## `[117]` Multilevelerror: Influence Diagnostics for Three-Level Meta-Analysis

**Type:** methods  |  ESTIMAND: Median Cook distance (IQR)  
**Data:** Assink 2016 dataset (100 effects, 18 studies) via metadat

### 156-word body

How reliably do pooled estimates from three-level meta-analytic models remain stable when individual effects or entire studies are removed? We developed the Multilevelerror R package extending metafor rma.mv objects with leave-one-effect-out and leave-one-study-out influence diagnostics including Cook distance, DFBETAS, and variance component stability monitoring at level-two and level-three hierarchies. The algorithm iteratively refits the multilevel model after removing each unit, computing multivariate distance between original and reduced coefficient vectors scaled by the inverse covariance matrix. Applied to the Assink 2016 dataset with 100 effect sizes nested within 18 studies, median Cook distance was 0.08 (IQR 0.03 to 0.22), with 2 studies exceeding the threshold, accounting for 38 percent of total level-three heterogeneity. Parallel processing reduced computation time by 74 percent on an eight-core machine compared with sequential execution. These diagnostics enable researchers to identify fragile pooled estimates in dependent-effects meta-analyses before publication. A limitation is that the implementation supports only intercept-only three-level models without moderator-inclusive specifications.

### Submission metadata

```
Corresponding author: Mahmood Ahmad <mahmood.ahmad2@nhs.net>
ORCID: 0000-0001-9107-3704
Affiliation: Tahir Heart Institute, Rabwah, Pakistan

Links:
  Code:      https://github.com/mahmood726-cyber/Multilevelerror
  Protocol:  https://github.com/mahmood726-cyber/Multilevelerror/blob/main/E156-PROTOCOL.md
  Dashboard: https://mahmood726-cyber.github.io/multilevelerror/

References (topic pack: multilevel / three-level meta-analysis):
  1. Cheung MW-L. 2014. Modeling dependent effect sizes with three-level meta-analyses: a structural equation modeling approach. Psychol Methods. 19(2):211-229. doi:10.1037/a0032968
  2. Van den Noortgate W, López-López JA, Marín-Martínez F, Sánchez-Meca J. 2013. Three-level meta-analysis of dependent effect sizes. Behav Res Methods. 45(2):576-594. doi:10.3758/s13428-012-0261-6

Data availability: No patient-level data used. Analysis derived exclusively
  from publicly available aggregate records. All source identifiers are in
  the protocol document linked above.

Ethics: Not required. Study uses only publicly available aggregate data; no
  human participants; no patient-identifiable information; no individual-
  participant data. No institutional review board approval sought or required
  under standard research-ethics guidelines for secondary methodological
  research on published literature.

Funding: None.

Competing interests: MA serves on the editorial board of Synthēsis (the
  target journal); MA had no role in editorial decisions on this
  manuscript, which was handled by an independent editor of the journal.

Author contributions (CRediT):
  [STUDENT REWRITER, first author] — Writing – original draft, Writing –
    review & editing, Validation.
  [SUPERVISING FACULTY, last/senior author] — Supervision, Validation,
    Writing – review & editing.
  Mahmood Ahmad (middle author, NOT first or last) — Conceptualization,
    Methodology, Software, Data curation, Formal analysis, Resources.

AI disclosure: Computational tooling (including AI-assisted coding via
  Claude Code [Anthropic]) was used to develop analysis scripts and assist
  with data extraction. The final manuscript was human-written, reviewed,
  and approved by the author; the submitted text is not AI-generated. All
  quantitative claims were verified against source data; cross-validation
  was performed where applicable. The author retains full responsibility for
  the final content.

Preprint: Not preprinted.

Reporting checklist: PRISMA 2020 (methods-paper variant — reports on review corpus).

Target journal: ◆ Synthēsis (https://www.synthesis-medicine.org/index.php/journal)
  Section: Methods Note — submit the 156-word E156 body verbatim as the main text.
  The journal caps main text at ≤400 words; E156's 156-word, 7-sentence
  contract sits well inside that ceiling. Do NOT pad to 400 — the
  micro-paper length is the point of the format.

Manuscript license: CC-BY-4.0.
Code license: MIT.

SUBMITTED: [ ]
```


---

_Auto-generated from the workbook by `C:/E156/scripts/create_missing_protocols.py`. If something is wrong, edit `rewrite-workbook.txt` and re-run the script — it will overwrite this file via the GitHub API._