source("../../src/R/07_make_boxplot.R")

# --- Synthetic long-format inputs (not the real dataset) ---

# Use case 1: typical multi-variable long data
df_two_vars <- data.frame(
  Variable = rep(c("A", "B"), each = 5),
  Value = c(1:5, 6:10)
)

# Use case 2: same shape, different title and axis styling 
df_bounce_style <- data.frame(
  Variable = rep(c("BounceRates", "ExitRates"), each = 4),
  Value = c(0.1, 0.2, 0.15, 0.3, 0.05, 0.12, 0.08, 0.2)
)

# Edge case: minimal data 
df_minimal <- data.frame(
  Variable = c("X", "Y"),
  Value = c(1, 2)
)