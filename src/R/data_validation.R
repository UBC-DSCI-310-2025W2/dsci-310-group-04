# Data validation — Online Shoppers pipeline (Milestone 4).


library(dplyr)
library(pointblank)
library(tidyselect)

# -------------------------------
# 1. Define what the data should look like
# -------------------------------

# Expected raw column names
EXPECTED_RAW_COLS <- c(
  "Administrative", "Administrative_Duration", "Informational",
  "Informational_Duration", "ProductRelated", "ProductRelated_Duration",
  "BounceRates", "ExitRates", "PageValues", "SpecialDay", "Month",
  "OperatingSystems", "Browser", "Region", "TrafficType",
  "VisitorType", "Weekend", "Revenue"
)

# Allowed values for categorical variables
LEVELS_REVENUE <- c("No", "Yes")
LEVELS_VISITOR <- c("Returning_Visitor", "New_Visitor", "Other")
LEVELS_MONTH <- c("Jan", "Feb", "Mar", "Apr", "May", "June",
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# Columns that should be numeric in the raw data
NUMERIC_COLS <- c(
  "Administrative", "Administrative_Duration", "Informational",
  "Informational_Duration", "ProductRelated", "ProductRelated_Duration",
  "BounceRates", "ExitRates", "PageValues", "SpecialDay",
  "OperatingSystems", "Browser", "Region", "TrafficType"
)

# -------------------------------
# 2. Helper functions for custom checks
# -------------------------------

# Pointblank custom checks need a logical vector
make_check_result <- function(data, passed) {
  rep(passed, max(1L, nrow(data)))
}

# Check that column names match exactly
check_names <- function(expected_names) {
  function(data) {
    make_check_result(data, setequal(names(data), expected_names))
  }
}

# Check that dataset is not empty
check_has_rows <- function(min_rows = 1) {
  function(data) {
    make_check_result(data, nrow(data) >= min_rows)
  }
}

# Check that missingness in every column is <= threshold
check_missingness <- function(max_prop = 0.05) {
  function(data) {
    miss_prop <- vapply(data, function(x) mean(is.na(x)), numeric(1))
    make_check_result(data, max(miss_prop, na.rm = TRUE) <= max_prop)
  }
}

# Check raw data types
check_raw_types <- function() {
  function(data) {
    numeric_ok <- all(vapply(NUMERIC_COLS, function(col) is.numeric(data[[col]]), logical(1)))
    month_ok <- is.character(data$Month) || is.factor(data$Month)
    visitor_ok <- is.character(data$VisitorType) || is.factor(data$VisitorType)
    weekend_ok <- is.logical(data$Weekend)
    revenue_ok <- is.logical(data$Revenue)
    
    make_check_result(data, numeric_ok && month_ok && visitor_ok && weekend_ok && revenue_ok)
  }
}

# Check important categorical columns are not all one single value
check_non_degenerate_categories <- function() {
  function(data) {
    ok <- n_distinct(data$Revenue, na.rm = TRUE) >= 2 &&
      n_distinct(data$Month, na.rm = TRUE) >= 2 &&
      n_distinct(data$VisitorType, na.rm = TRUE) >= 2 &&
      n_distinct(data$Weekend, na.rm = TRUE) >= 2
    
    make_check_result(data, ok)
  }
}

# Check train target rate only (to avoid leakage)
check_train_target_rate <- function(lower = 0.03, upper = 0.45) {
  function(data) {
    rate_yes <- mean(data$Revenue == "Yes", na.rm = TRUE)
    make_check_result(data, rate_yes >= lower && rate_yes <= upper)
  }
}

# -------------------------------
# 3. Validate the raw dataset
# -------------------------------

validate_raw_data <- function(raw_data) {
  
  raw_data %>%
    # Correct number of columns
    col_count_match(count = length(EXPECTED_RAW_COLS)) %>%
    
    # Correct column names
    col_exists(columns = all_of(EXPECTED_RAW_COLS)) %>%
    specially(fn = check_names(EXPECTED_RAW_COLS)) %>%
    
    # No empty dataset
    specially(fn = check_has_rows(1)) %>%
    
    # Missingness not beyond 5%
    specially(fn = check_missingness(0.05)) %>%
    
    # Correct raw data types
    specially(fn = check_raw_types()) %>%
    
    # No impossible negative values
    col_vals_gte(
      columns = c(
        Administrative, Administrative_Duration, Informational,
        Informational_Duration, ProductRelated, ProductRelated_Duration,
        PageValues
      ),
      value = 0
    ) %>%
    
    # Rate-like variables must be between 0 and 1
    col_vals_between(
      columns = c(BounceRates, ExitRates, SpecialDay),
      left = 0,
      right = 1
    )
  
  invisible(TRUE)
}

# -------------------------------
# 4. Validate cleaned data
# -------------------------------

validate_cleaned_data <- function(cleaned_data) {
  
  cleaned_data %>%
    # Dataset should still have rows
    specially(fn = check_has_rows(1)) %>%
    
    # No duplicate rows
    rows_distinct() %>%
    
    # Categorical columns should now be factors
    col_is_factor(
      columns = c(
        Revenue, Month, OperatingSystems, Browser,
        Region, TrafficType, VisitorType, Weekend
      )
    ) %>%
    
    # Correct category levels
    col_vals_in_set(columns = vars(Revenue), set = LEVELS_REVENUE) %>%
    col_vals_in_set(columns = vars(VisitorType), set = LEVELS_VISITOR) %>%
    col_vals_in_set(columns = vars(Month), set = LEVELS_MONTH) %>%
    
    # Important categories should not collapse to one value only
    specially(fn = check_non_degenerate_categories()) %>%
    
    # Numeric bounds still hold after cleaning
    col_vals_gte(
      columns = c(
        Administrative, Administrative_Duration, Informational,
        Informational_Duration, ProductRelated, ProductRelated_Duration,
        PageValues
      ),
      value = 0
    ) %>%
    col_vals_between(
      columns = c(BounceRates, ExitRates, SpecialDay),
      left = 0,
      right = 1
    )
  
  invisible(TRUE)
}

# -------------------------------
# 5. Validate train or test split separately
# -------------------------------

validate_split_data <- function(split_data) {
  
  split_data %>%
    # Split should not be empty
    specially(fn = check_has_rows(1)) %>%
    
    # Missingness check again
    specially(fn = check_missingness(0.05)) %>%
    
    # Factor columns remain factors
    col_is_factor(
      columns = c(
        Revenue, Month, OperatingSystems, Browser,
        Region, TrafficType, VisitorType, Weekend
      )
    ) %>%
    
    # Revenue still has valid values
    col_vals_in_set(columns = vars(Revenue), set = LEVELS_REVENUE) %>%
    
    # Numeric checks again
    col_vals_gte(
      columns = c(
        Administrative, Administrative_Duration, Informational,
        Informational_Duration, ProductRelated, ProductRelated_Duration,
        PageValues
      ),
      value = 0
    ) %>%
    col_vals_between(
      columns = c(BounceRates, ExitRates, SpecialDay),
      left = 0,
      right = 1
    )
  
  invisible(TRUE)
}

# -------------------------------
# 6. Validate target distribution on training set only
# -------------------------------

validate_train_target <- function(train_data) {
  train_data %>%
    specially(fn = check_train_target_rate(0.03, 0.45))
  
  invisible(TRUE)
}