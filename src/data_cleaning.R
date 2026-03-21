# author: [Raghav Vashisht]
# date: [2026-03-19]
#
# Clean and split the Online Shoppers Purchasing Intention dataset.
# Reads raw CSV from script 1; writes processed train/test CSVs for EDA and modeling.

"Clean, preprocess, and split online shoppers data.

Usage:
  data_cleaning.R --input_file_path=<path> --output_dir=<dir> [--seed=<seed>] [--split=<split>]

Options:
  --input_file_path=<path>  Path to raw CSV (from data_loading.R).
  --output_dir=<dir>        Directory to write cleaned train/test CSVs.
  --seed=<seed>             Random seed [default: 310].
  --split=<split>           Proportion for training set [default: 0.8].

Output:
  <output_dir>/shoppers_train.csv
  <output_dir>/shoppers_test.csv
" -> doc

library(docopt)
library(tidyverse)

opt <- docopt(doc)

main <- function(input_file_path, output_dir, seed, split) {
  set.seed(as.integer(seed))
  split <- as.numeric(split)

  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  raw <- readr::read_csv(input_file_path, show_col_types = FALSE)

  cleaned <- raw %>%
    mutate(
      Revenue = if_else(Revenue == TRUE | Revenue == "TRUE", "Yes", "No"),
      Revenue = factor(Revenue, levels = c("No", "Yes")),
      Month = factor(Month),
      OperatingSystems = factor(OperatingSystems),
      Browser = factor(Browser),
      Region = factor(Region),
      TrafficType = factor(TrafficType),
      VisitorType = factor(VisitorType),
      Weekend = factor(Weekend)
    ) %>%
    drop_na() %>%
    droplevels()

  # log1p transform right-skewed engagement variables
  cleaned <- cleaned %>%
    mutate(
      Administrative_Duration = log1p(Administrative_Duration),
      Informational_Duration = log1p(Informational_Duration),
      PageValues = log1p(PageValues),
      ProductRelated = log1p(ProductRelated),
      ProductRelated_Duration = log1p(ProductRelated_Duration),
      Revenue_num = if_else(Revenue == "Yes", 1L, 0L)
    )

  n <- nrow(cleaned)
  train_idx <- sample.int(n, size = floor(split * n))

  train <- cleaned[train_idx, , drop = FALSE]
  test <- cleaned[-train_idx, , drop = FALSE]

  train_path <- file.path(output_dir, "shoppers_train.csv")
  test_path <- file.path(output_dir, "shoppers_test.csv")

  readr::write_csv(train, train_path)
  readr::write_csv(test, test_path)

  message("Wrote: ", train_path)
  message("Wrote: ", test_path)
}

main(
  opt$input_file_path,
  opt$output_dir,
  opt$seed,
  opt$split
)