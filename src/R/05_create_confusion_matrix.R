#' Create confusion matrix
#'
#' Converts a confusion matrix into a tidy data frame format, showing the 
#' frequency of predictions against actual class labels
#'
#' @param pred_test_labels A factor of predicted labels
#' @param actual_test_labels A factor of true labels
#' @param label_levels a character vector of class labels  
#' @param positive_label a string for the positive class label
#'
#' @return A data frame with three columns 
#' \itemize{
#'   \item \code{table}: A data frame with three columns (\code{Predicted}, \code{Actual}, \code{Count}) showing the frequency of predictions against actual labels.
#'   \item \code{metrics}: A named numeric vector of overall model metrics (e.g., Accuracy, Kappa) from \code{caret}.
#'   \item \code{by_class}: A named numeric vector of class-specific metrics (e.g., Precision, Recall, F1) from \code{caret}.
#' }
#' @export
#' 
#' @examples
#' # Assuming pred_lasso_revenue and test$Revenue exist:
#' # results <- create_confusion_matrix(pred_lasso_revenue, test$Revenue, c("No", "Yes"), "Yes")
#' # results$table
#' # results$metrics["Accuracy"]
create_confusion_matrix <- function(pred_test_labels, actual_test_labels, label_levels, positive_label) {
  
  if (length(pred_test_labels) == 0 || length(actual_test_labels) == 0) {
    stop("Input vectors cannot be empty.")
  }
  
  actual_factor <- factor(actual_test_labels, levels=label_levels)
  pred_test_factor <- factor(pred_test_labels, levels=label_levels)
  if (any(is.na(pred_test_factor)) || any(is.na(actual_factor))) {
    stop("Inputs cannot contain NAs or values outside the specified label_levels.")
  }
  
  
  cm <- confusionMatrix(
    pred_test_labels,
    factor(actual_test_labels, levels = label_levels),
    positive = positive_label
  )
  
  cm_table <- as.data.frame(cm$table)
  colnames(cm_table) <- c("Predicted", "Actual", "Count")
  
  cm_results <- list(
    table = cm_table,
    metrics = cm$overall,
    by_class = cm$byClass
  )
  
  return(cm_results)
}
