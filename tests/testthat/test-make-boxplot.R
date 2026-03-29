library(testthat)
library(ggplot2)

test_that("make_numeric_boxplot returns a ggplot with boxplot geom (typical data)", {
  p <- make_numeric_boxplot(
    df_two_vars,
    title = "Figure 1: Boxplots of Numeric Features"
  )
  expect_s3_class(p, "ggplot")
  geoms <- vapply(p$layers, function(x) class(x$geom)[1], character(1))
  expect_true("GeomBoxplot" %in% geoms)
  expect_equal(p$labels$title, "Figure 1: Boxplots of Numeric Features")
})

test_that("make_numeric_boxplot respects custom x label angle and size (second use case)", {
  p <- make_numeric_boxplot(
    df_bounce_style,
    title = "Figure 2: Boxplots of BounceRates and ExitRates",
    x_label_angle_degrees = 30,
    x_label_size = 11
  )
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$title, "Figure 2: Boxplots of BounceRates and ExitRates")
})

test_that("make_numeric_boxplot works with minimal rows per variable (edge case)", {
  p <- make_numeric_boxplot(df_minimal, title = "Minimal")
  expect_s3_class(p, "ggplot")
  expect_no_error(ggplot2::ggplot_build(p))
})

test_that("make_numeric_boxplot errors when Variable column is missing", {
  bad <- data.frame(Value = 1:3)
  expect_error(
    make_numeric_boxplot(bad, title = "Bad"),
    "Variable"
  )
})

test_that("make_numeric_boxplot errors when Value column is missing", {
  bad <- data.frame(Variable = c("a", "b"))
  expect_error(
    make_numeric_boxplot(bad, title = "Bad"),
    "Value"
  )
})