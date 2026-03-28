library(testthat)

source("../../R/split_data.R")

test_that("returns a list with train and test", {
  result <- split_data(simple_df, 0.8, seed = 123)

  expect_true(is.list(result))
  expect_named(result, c("train", "test"))
})

test_that("train and test are data frames", {
  result <- split_data(simple_df, 0.8, seed = 123)

  expect_s3_class(result$train, "data.frame")
  expect_s3_class(result$test, "data.frame")
})

test_that("split sizes are correct", {
  result <- split_data(df_20, 0.8, seed = 123)

  expect_equal(nrow(result$train), 16)
  expect_equal(nrow(result$test), 4)
})

test_that("train and test do not overlap", {
  result <- split_data(df_20, 0.8, seed = 123)

  overlap <- intersect(result$train$id, result$test$id)

  expect_length(overlap, 0)
})

test_that("all rows are preserved", {
  result <- split_data(df_20, 0.8, seed = 123)

  combined <- sort(c(result$train$id, result$test$id))

  expect_equal(combined, df_20$id)
})

test_that("train and test have same columns", {
  result <- split_data(simple_df, 0.8, seed = 123)

  expect_equal(names(result$train), names(simple_df))
  expect_equal(names(result$test), names(simple_df))
  expect_equal(ncol(result$train), ncol(result$test))
})

test_that("splitting is reproducible with same seed", {
  result1 <- split_data(df_20, 0.8, seed = 123)
  result2 <- split_data(df_20, 0.8, seed = 123)

  expect_equal(result1, result2)
})

test_that("different seeds give different splits", {
  result1 <- split_data(df_20, 0.8, seed = 123)
  result2 <- split_data(df_20, 0.8, seed = 456)

  expect_false(identical(result1, result2))
})

test_that("errors when input is not a data frame", {
  expect_error(
    split_data(non_df_input, 0.8),
    "data must be a data frame"
  )
})

test_that("errors when split is invalid", {
  expect_error(split_data(simple_df, -0.1))
  expect_error(split_data(simple_df, 1.5))
  expect_error(split_data(simple_df, 0))
  expect_error(split_data(simple_df, 1))
})
