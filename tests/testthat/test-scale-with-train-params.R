library(testthat)

test_that("scaled training data has mean ~0 and sd ~1 per column", {
  result <- scale_with_train_params(train_normal, test_normal)

  col_means <- colMeans(result$X_train_scaled)
  col_sds   <- apply(result$X_train_scaled, 2, sd)

  expect_true(all(abs(col_means) < 1e-10))
  expect_true(all(abs(col_sds - 1) < 1e-10))
})

test_that("test data is scaled using training parameters, not its own", {
  result <- scale_with_train_params(train_single, test_single)

  train_mean <- mean(c(1, 2, 3))
  train_sd   <- sd(c(1, 2, 3))
  expected   <- (c(4, 5) - train_mean) / train_sd

  expect_equal(result$X_test_scaled$a, expected)
})

test_that("returns a list with correct names", {
  result <- scale_with_train_params(train_normal, test_normal)

  expect_type(result, "list")
  expect_named(result, c("X_train_scaled", "X_test_scaled"))
})

test_that("output data frames have correct dimensions", {
  result <- scale_with_train_params(train_normal, test_normal)

  expect_equal(nrow(result$X_train_scaled), nrow(train_normal))
  expect_equal(nrow(result$X_test_scaled),  nrow(test_normal))
  expect_equal(ncol(result$X_train_scaled), ncol(train_normal))
  expect_equal(ncol(result$X_test_scaled),  ncol(test_normal))
})

test_that("errors when X_train is not a data frame", {
  expect_error(
    scale_with_train_params(not_a_df, test_normal),
    "`X_train` must be a data frame."
  )
})

test_that("errors when X_test is not a data frame", {
  expect_error(
    scale_with_train_params(train_normal, not_a_df),
    "`X_test` must be a data frame."
  )
})

test_that("errors when column names do not match", {
  expect_error(
    scale_with_train_params(train_mismatch, test_mismatch),
    "must have the same column names"
  )
})

test_that("errors when X_train has zero variance column", {
  expect_error(
    scale_with_train_params(train_zero_var, test_zero_var),
    "zero variance"
  )
})

test_that("errors when X_train is empty", {
  expect_error(
    scale_with_train_params(train_empty, test_empty),
    "`X_train` must not be empty."
  )
})
