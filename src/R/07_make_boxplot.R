# author: Raghav Vashisht (DSCI 310 Group 04)
# date: 2026-03-27

#' Boxplot of numeric variables in long format
#'
#' Builds a ggplot2 boxplot for exploratory plots where each row is one
#' observation of a numeric variable, with columns `Variable` and `Value`.
#'
#' @param data A data frame with columns `Variable` and `Value`.
#' @param title Character; plot title.
#' @param y_label Character; y-axis label (default `"Value"`).
#' @param x_label_angle_degrees Numeric; angle for x-axis category labels.
#' @param x_label_size Numeric; font size for x-axis category labels.
#'
#' @return A ggplot object.
make_numeric_boxplot <- function(
    data,
    title,
    y_label = "Value",
    x_label_angle_degrees = 45,
    x_label_size = 10
) {
  required <- c("Variable", "Value")
  if (!all(required %in% names(data))) {
    stop(
      "data must contain columns: ",
      paste(required, collapse = ", "),
      call. = FALSE
    )
  }

  ggplot2::ggplot(data, ggplot2::aes(x = Variable, y = Value)) +
    ggplot2::geom_boxplot(outlier.colour = "red", outlier.shape = 16) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(
        angle = x_label_angle_degrees,
        hjust = 1,
        size = x_label_size
      )
    ) +
    ggplot2::labs(title = title, x = "", y = y_label)
}