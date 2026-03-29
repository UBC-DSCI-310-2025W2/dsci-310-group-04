library(testthat)
library(caret)

# Regular Case
test_that("create_confusion_matrix regular case returns correct structure and counts", {
  result <- create_confusion_matrix(preds, actual, class_levels, positive_label)
  
  expect_type(result, "list")
  expect_named(result, c("table", "metrics", "by_class"))
  res_tbl <- result$table
  
  expect_s3_class(res_tbl, "data.frame")
  
  expect_equal(nrow(res_tbl), 4)
  expect_equal(ncol(res_tbl), 3)
  
  expect_named(res_tbl, column_names)
  
  expect_type(res_tbl$Count, "integer")
  expect_true(is.factor(res_tbl$Predicted))
  expect_true(is.factor(res_tbl$Actual))
  
  true_positive <- res_tbl$Count[res_tbl$Predicted == "Yes" & res_tbl$Actual == "Yes"]
  true_negative <- res_tbl$Count[res_tbl$Predicted == "No" & res_tbl$Actual == "No"]
    
  expect_equal(true_positive, 2)
  expect_equal(true_negative, 0)
  expect_true("Accuracy" %in% names(result$metrics))
})

# Regular Case
test_that("create_confusion_matrix all incorrect case returns correct structure and counts", {
  result <- create_confusion_matrix(incorrect_preds, actual, class_levels, positive_label)
  
  expect_type(result, "list")
  expect_named(result, c("table", "metrics", "by_class"))
  res_tbl <- result$table
  
  expect_s3_class(res_tbl, "data.frame")
  
  expect_equal(nrow(res_tbl), 4)
  expect_equal(ncol(res_tbl), 3)
  
  expect_named(res_tbl, column_names)
  
  true_positive <- res_tbl$Count[res_tbl$Predicted == "Yes" & res_tbl$Actual == "Yes"]
  true_negative <- res_tbl$Count[res_tbl$Predicted == "No" & res_tbl$Actual == "No"]
  
  expect_equal(true_positive, 0)
  expect_equal(true_negative, 0)
  expect_true("Accuracy" %in% names(result$metrics))
})

# Edge Case
test_that("create_confusion_matrix missing class returns correct structure and counts", {
  result <- create_confusion_matrix(missing_class_preds, missing_class_actual, class_levels, positive_label)
  
  expect_type(result, "list")
  expect_named(result, c("table", "metrics", "by_class"))
  res_tbl <- result$table
  
  expect_s3_class(res_tbl, "data.frame")
  
  expect_equal(nrow(res_tbl), 4)
  expect_equal(ncol(res_tbl), 3)
  
  expect_named(res_tbl, column_names)
  
  true_positive <- res_tbl$Count[res_tbl$Predicted == "Yes" & res_tbl$Actual == "Yes"]
  true_negative <- res_tbl$Count[res_tbl$Predicted == "No" & res_tbl$Actual == "No"]
  
  expect_equal(true_positive, 0)
  expect_equal(true_negative, 2)
  expect_true("Accuracy" %in% names(result$metrics))
})

# Edge Case
test_that("create_confusion_matrix large case returns correct structure and counts", {
  result <- create_confusion_matrix(large_preds, large_actual, large_class_levels, large_positive_label)
  
  expect_type(result, "list")
  expect_named(result, c("table", "metrics", "by_class"))
  res_tbl <- result$table
  
  expect_s3_class(res_tbl, "data.frame")
  
  expect_equal(nrow(res_tbl), 25)
  expect_equal(ncol(res_tbl), 3)
  
  expect_named(res_tbl, column_names)
  
  exactly_correct <- res_tbl$Count[res_tbl$Predicted == "A" & res_tbl$Actual == "A"]
  wrong_prediction <- res_tbl$Count[res_tbl$Predicted == "B" & res_tbl$Actual == "C"]
  not_predicted <- res_tbl$Count[res_tbl$Predicted == "B" & res_tbl$Actual == "A"]
  
  expect_equal(exactly_correct, 1)
  expect_equal(wrong_prediction, 1)
  expect_equal(not_predicted, 0)
  expect_true("Accuracy" %in% names(result$metrics))
})

# Error Case
test_that("create_confusion_matrix mismatched lengths returns error", {
  expect_error(create_confusion_matrix(missing_class_preds, actual, class_levels, positive_label))
})

# Error Case
test_that("create_confusion_matrix pred has NA returns error", {
  expect_error(create_confusion_matrix(na_preds, actual, class_levels, positive_label))
})

# Error Case
test_that("create_confusion_matrix actual has NA returns error", {
  expect_error(create_confusion_matrix(preds, na_actual, class_levels, positive_label))
})

# Error Case
test_that("create_confusion_matrix levels has NA returns error", {
  expect_error(create_confusion_matrix(preds, actual, na_levels, positive_label))
})

# Error Case
test_that("create_confusion_matrix positive label has NA returns error", {
  expect_error(create_confusion_matrix(preds, actual, class_levels, NA))
})

# Error Case
test_that("create_confusion_matrix vector input instead of factor returns error", {
  expect_error(create_confusion_matrix(vector_preds, vector_actual, class_levels, positive_label))
})

# Error Case
test_that("create_confusion_matrix zero length pred and actual returns error", {
  expect_error(create_confusion_matrix(zero_length_preds, zero_length_actual, class_levels, positive_label))
})

# Error Case
test_that("create_confusion_matrix incompatible pred and actual returns error", {
  expect_error(create_confusion_matrix(preds, different_actual, class_levels, positive_label))
})

# Error Case
test_that("create_confusion_matrix input invalid positive class returns error", {
  expect_error(create_confusion_matrix(preds, actual, class_levels, invalid_positive_label))
})

# Error Case
test_that("create_confusion_matrix input invalid label levels returns error", {
  expect_error(create_confusion_matrix(preds, actual, invalid_label_levels, positive_label))
})
