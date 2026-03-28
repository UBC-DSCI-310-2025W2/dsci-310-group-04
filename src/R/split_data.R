#' Split a dataset into training and testing sets
#'
#' @param data A data frame to be split.
#' @param split A numeric proportion for the training set, between 0 and 1.
#' @param seed An optional integer random seed for reproducibility.
#'
#' @return A list with two elements: \code{train} and \code{test}, both data frames.
#' @examples
#' df <- data.frame(x = 1:10, y = letters[1:10])
#' result <- split_data(df, 0.8, seed = 123)
#' result$train
#' result$test
split_data <- function(data, split = 0.8, seed = NULL) {
  if (!is.data.frame(data)) {
    stop("data must be a data frame")
  }

  if (!is.numeric(split) || length(split) != 1 || is.na(split) || split <= 0 || split >= 1) {
    stop("split must be a single number between 0 and 1")
  }

  if (!is.null(seed)) {
    set.seed(seed)
  }

  n <- nrow(data)
  train_idx <- sample.int(n, size = floor(split * n))
  test_idx <- setdiff(seq_len(n), train_idx)

  train <- data[train_idx, , drop = FALSE]
  test  <- data[test_idx, , drop = FALSE]

  list(train = train, test = test)
}
