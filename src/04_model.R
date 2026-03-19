# author: Athena Wong
# date: 2026-03-18

"This script fits a LASSO logistic regression model on the cleaned training data,
evaluates it on the test set, and saves output figures and tables to results/.

Usage: 04_model.R --train=<train> --test=<test> --output_dir=<output_dir>

Options:
--train=<train>            Path to training CSV (e.g. data/processed/train.csv)
--test=<test>              Path to test CSV (e.g. data/processed/test.csv)
--output_dir=<output_dir>  Directory to save output figures and tables (e.g. results/)
" -> doc

library(tidyverse)
library(glmnet)
library(pROC)
library(caret)
library(docopt)

opt <- docopt(doc)

main <- function(train_path, test_path, output_dir) {

  # ── 0. Setup ──────────────────────────────────────────────────────────────
  set.seed(310)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  # ── 1. Load data ──────────────────────────────────────────────────────────
  train <- read_csv(train_path, show_col_types = FALSE) %>%
    mutate(across(where(is.character), as.factor))

  test <- read_csv(test_path, show_col_types = FALSE) %>%
    mutate(across(where(is.character), as.factor))

  # ── 2. Scale numeric features ─────────────────────────────────────────────
  # Scaling is fit ONLY on training data to prevent data leakage.
  # The same mean/sd is applied to the test set.
  numeric_cols <- train %>% select(where(is.numeric)) %>% colnames()

  train_means <- train %>% select(all_of(numeric_cols)) %>% summarise(across(everything(), mean))
  train_sds   <- train %>% select(all_of(numeric_cols)) %>% summarise(across(everything(), sd))

  scale_with_train_params <- function(df) {
    df %>% mutate(across(
      all_of(numeric_cols),
      ~ (. - train_means[[cur_column()]]) / train_sds[[cur_column()]]
    ))
  }

  train_scaled <- scale_with_train_params(train)
  test_scaled  <- scale_with_train_params(test)

  # ── 3. Build model matrices ───────────────────────────────────────────────
  x_train <- train_scaled %>%
    select(-Revenue) %>%
    model.matrix(~ ., data = .) %>%
    .[, -1]   # drop intercept column added by model.matrix
  y_train <- as.numeric(train_scaled$Revenue)   # glmnet needs numeric 0/1

  x_test <- test_scaled %>%
    select(-Revenue) %>%
    model.matrix(~ ., data = .) %>%
    .[, -1]
  y_test <- test_scaled$Revenue   # keep as factor for confusionMatrix later

  # ── 4. Cross-validated LASSO to choose lambda ─────────────────────────────
  message("Fitting cross-validated LASSO...")
  cv_lasso <- cv.glmnet(
    x_train, y_train,
    family      = "binomial",
    alpha       = 1,
    type.measure = "auc"
  )
  cv_auc <- max(cv_lasso$cvm)
  best_lambda <- cv_lasso$lambda.min
  message(paste("Best CV AUC:", round(cv_auc, 4), "| Best lambda:", round(best_lambda, 6)))

  # ── 5. Save CV lambda plot ────────────────────────────────────────────────
  cv_plot_path <- file.path(output_dir, "lasso_cv_plot.png")
  png(cv_plot_path, width = 800, height = 500)
  plot(cv_lasso, main = "Cross-Validated AUC vs. log(lambda)")
  dev.off()
  message(paste("Saved:", cv_plot_path))

  # ── 6. Fit final model on full training set ───────────────────────────────
  final_lasso <- glmnet(
    x_train, y_train,
    family = "binomial",
    alpha  = 1,
    lambda = best_lambda
  )

  # ── 7. Predict on test set ────────────────────────────────────────────────
  lasso_test_pred_prob <- predict(
    final_lasso, newx = x_test,
    s = "lambda.min", type = "response"
  ) %>% as.numeric()

  lasso_test_pred_class <- factor(
    ifelse(lasso_test_pred_prob > 0.5, "Yes", "No"),
    levels = c("No", "Yes")
  )

  # ── 8. ROC curve + AUC ───────────────────────────────────────────────────
  roc_obj <- roc(
    test$Revenue, lasso_test_pred_prob,
    levels    = c("No", "Yes"),
    direction = "<"
  )
  test_auc <- as.numeric(auc(roc_obj))
  message(paste("Test AUC:", round(test_auc, 4)))

  # Save ROC curve plot
  roc_plot_path <- file.path(output_dir, "roc_curve.png")
  png(roc_plot_path, width = 700, height = 600)
  plot(
    roc_obj,
    col  = "#2c7bb6",
    lwd  = 2,
    main = paste0("ROC Curve — Test AUC = ", round(test_auc, 3))
  )
  abline(a = 1, b = -1, lty = 2, col = "grey60")
  dev.off()
  message(paste("Saved:", roc_plot_path))

  # ── 9. Confusion matrix ───────────────────────────────────────────────────
  cm <- confusionMatrix(
    lasso_test_pred_class,
    factor(test$Revenue, levels = c("No", "Yes")),
    positive = "Yes"
  )

  # Save confusion matrix as a tidy CSV table
  cm_table <- as.data.frame(cm$table)
  colnames(cm_table) <- c("Predicted", "Actual", "Count")
  cm_table_path <- file.path(output_dir, "confusion_matrix.csv")
  write_csv(cm_table, cm_table_path)
  message(paste("Saved:", cm_table_path))

  # ── 10. Summary metrics table ─────────────────────────────────────────────
  accuracy     <- cm$overall["Accuracy"]
  precision    <- cm$byClass["Precision"]
  recall       <- cm$byClass["Recall"]
  f1           <- cm$byClass["F1"]

  metrics <- tibble(
    Metric    = c("CV AUC (lambda.min)", "Test AUC", "Test Accuracy",
                  "Test Precision", "Test Recall", "Test F1"),
    Value     = round(c(cv_auc, test_auc, accuracy, precision, recall, f1), 4)
  )
  metrics_path <- file.path(output_dir, "model_metrics.csv")
  write_csv(metrics, metrics_path)
  message(paste("Saved:", metrics_path))
  print(metrics)

  # ── 11. Selected coefficients table ──────────────────────────────────────
  coef_mat   <- coef(final_lasso, s = best_lambda)
  coef_df    <- as.data.frame(as.matrix(coef_mat))
  coef_df    <- tibble(Feature = rownames(coef_df), Coefficient = coef_df[, 1]) %>%
    filter(Coefficient != 0, Feature != "(Intercept)") %>%
    arrange(desc(abs(Coefficient)))

  coef_path <- file.path(output_dir, "lasso_coefficients.csv")
  write_csv(coef_df, coef_path)
  message(paste("Saved:", coef_path))

  message("Done! All results saved to: ", output_dir)
}

main(opt$train, opt$test, opt$output_dir)
