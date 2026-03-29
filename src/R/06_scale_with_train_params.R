#' Scale training and test data using training set parameters
#'
#' Standardizes both the training and test feature matrices using the
#' column-wise means and standard deviations computed from the training set
#' only. This prevents data leakage from the test set into the scaling step.
#'
#' @param X_train A numeric data frame of training features.
#' @param X_test A numeric data frame of test features.
#'   Must have the same column names as \code{X_train}.
#'
#' @return A named list with two elements:
#' \itemize{
#'   \item \code{X_train_scaled}: The scaled training data frame.
#'   \item \code{X_test_scaled}: The scaled test data frame, using training parameters.
#' }
#' @export
#'
#' @examples
#' # train <- data.frame(a = c(1, 2, 3), b = c(10, 20, 30))
#' # test  <- data.frame(a = c(4, 5),    b = c(40, 50))
#' # result <- scale_with_train_params(train, test)
#' # result$X_train_scaled
#' # result$X_test_scaled
scale_with_train_params <- function(X_train, X_test) {
  if (!is.data.frame(X_train)) {
    stop("`X_train` must be a data frame.")
  }
  if (!is.data.frame(X_test)) {
    stop("`X_test` must be a data frame.")
  }
  if (!identical(colnames(X_train), colnames(X_test))) {
    stop("`X_train` and `X_test` must have the same column names in the same order.")
  }
  if (nrow(X_train) == 0) {
    stop("`X_train` must not be empty.")
  }

  train_means <- colMeans(X_train)
  train_sds <- apply(X_train, 2, sd)

  if (any(train_sds == 0)) {
    stop("One or more columns in `X_train` have zero variance and cannot be scaled.")
  }

  scale_df <- function(df) {
    as.data.frame(scale(df, center = train_means, scale = train_sds))
  }

  list(
    X_train_scaled = scale_df(X_train),
    X_test_scaled = scale_df(X_test)
  )
}
