library(caret)

source("../../src/05_create_confusion_matrix.R")

# class levels
class_levels <- c("No", "Yes")
large_class_levels <- c("A", "B", "C", "D", "E")
invalid_label_levels = c("nah", "yeh")
na_levels = c(NA, "Yes")

# predicted labels
preds <- factor(c("Yes", "No", "Yes", "Yes"), levels = class_levels)
incorrect_preds <- factor(c("No", "No", "Yes", "No"), levels = class_levels)
missing_class_preds <- factor(c("No", "No"), levels = class_levels)
large_preds <- factor(c("A", "B", "C", "D", "E"), levels = large_class_levels)
na_preds <- factor(c("No", "No", "Yes", NA), levels = class_levels)
vector_preds <- c("Yes", "No", "Yes", "Yes")
zero_length_preds <- factor(character(0), levels=class_levels)

# true/actual labels
actual <- factor(c("Yes", "Yes", "No", "Yes"), levels = class_levels)
missing_class_actual <- factor(c("No", "No"), levels = class_levels)
large_actual <- factor(c("A", "C", "B", "D", "E"), levels = large_class_levels)
na_actual <- factor(c("No", "No", "Yes", NA), levels = class_levels)
vector_actual <- c("Yes", "Yes", "No", "Yes")
zero_length_actual <- factor(character(0), levels=class_levels)
different_actual <- factor(c("yah", "yah", "nah", "yah"), levels = class_levels)

# positive labels
positive_label <- "Yes"
large_positive_label <- "A"
invalid_positive_label = "Maybe"

# Others
column_names <- c("Predicted", "Actual", "Count")
