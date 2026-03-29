library(tibble)

source("../../src/R/08_split_data.R")

set.seed(123)

# simple dataset
simple_df <- tibble(
  id = 1:10,
  value = round(runif(10), 2)
)

# larger dataset (for size testing)
df_20 <- tibble(
  id = 1:20,
  value = round(runif(20), 2)
)

# non-dataframe input (for error testing)
non_df_input <- list(
  id = 1:5,
  value = c(1, 2, 3, 4, 5)
)