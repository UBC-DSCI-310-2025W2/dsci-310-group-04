source("../../src/R/06_scale_with_train_params.R")

# Normal case
train_normal <- data.frame(a = c(1, 2, 3, 4, 5), b = c(10, 20, 30, 40, 50))
test_normal  <- data.frame(a = c(6, 7),           b = c(60, 70))

# Single column
train_single <- data.frame(a = c(1, 2, 3))
test_single  <- data.frame(a = c(4, 5))

# Mismatched column names
train_mismatch <- data.frame(a = c(1, 2, 3))
test_mismatch  <- data.frame(b = c(4, 5))

# Zero variance column
train_zero_var <- data.frame(a = c(5, 5, 5), b = c(1, 2, 3))
test_zero_var  <- data.frame(a = c(5, 6),    b = c(4, 5))

# Empty train
train_empty <- data.frame(a = numeric(0))
test_empty  <- data.frame(a = c(1, 2))

# Non-data-frame inputs
not_a_df <- matrix(c(1, 2, 3), nrow = 3)
