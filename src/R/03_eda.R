# author: Gracie Shao
# date: 2026-03-17

"This script performs exploratory data analysis (EDA) on the online shopping dataset
and saves Figures 1 to 5 to files.

Usage:
  eda.R --input_file_path=<input_file_path> --output_prefix=<output_prefix>

Example:
  Rscript eda.R --input_file_path=data/online_shoppers.csv --output_prefix=results/eda

Options:
  --input_file_path=<input_file_path>   Path to input CSV dataset
  --output_prefix=<output_prefix>       Prefix for output files (e.g., results/eda)

Output figures:
  results/eda_figure1.png
  results/eda_figure2.png
  results/eda_figure3.png
  results/eda_figure4.png
  results/eda_figure5.png
" -> doc

library(tidyverse)
library(scales)
library(docopt)

source("src/R/07_make_boxplot.R")

opt <- docopt(doc)

main <- function(input_file_path, output_prefix) {
    
    # ---------------------------------------------------------
    # Load data
    # ---------------------------------------------------------
    shoppers <- read_csv(input_file_path, show_col_types = FALSE)
    
    # ---------------------------------------------------------
    # Basic preprocessing
    # ---------------------------------------------------------
    shoppers <- shoppers %>%
        mutate(
            Revenue = as.factor(Revenue),
            Weekend = as.factor(Weekend),
            Month = as.factor(Month),
            VisitorType = as.factor(VisitorType),
            Administrative = as.factor(Administrative),
            Informational = as.factor(Informational),
            SpecialDay = as.factor(SpecialDay)
        )
    
    # ---------------------------------------------------------
    # Figure 1: Numeric features before transformation
    # ---------------------------------------------------------
    numeric_long <- shoppers %>%
        select(where(is.numeric)) %>%
        pivot_longer(
            cols = everything(),
            names_to = "Variable",
            values_to = "Value"
        )
    
    p1 <- make_numeric_boxplot(
        numeric_long,
        title = "Figure 1: Boxplots of Numeric Features"
    )
    
    ggsave(
        filename = paste0(output_prefix, "_figure1.png"),
        plot = p1,
        width = 12,
        height = 6
    )
    
    # ---------------------------------------------------------
    # Figure 2: BounceRates and ExitRates before transformation
    # ---------------------------------------------------------
    numeric_small <- numeric_long %>%
        filter(Variable %in% c("BounceRates", "ExitRates"))
    
    p2 <- make_numeric_boxplot(
        numeric_small,
        title = "Figure 2: Boxplots of BounceRates and ExitRates",
        x_label_angle_degrees = 30,
        x_label_size = 11
    )
    
    ggsave(
        filename = paste0(output_prefix, "_figure2.png"),
        plot = p2,
        width = 8,
        height = 6
    )
    
    # ---------------------------------------------------------
    # Transform numeric variables for Figure 3
    # ---------------------------------------------------------
    shoppers_clean <- shoppers %>%
        mutate(
            Administrative_Duration = log1p(Administrative_Duration),
            Informational_Duration = log1p(Informational_Duration),
            PageValues = log1p(PageValues),
            ProductRelated = log1p(ProductRelated),
            ProductRelated_Duration = log1p(ProductRelated_Duration)
        )
    
    # ---------------------------------------------------------
    # Figure 3: Numeric features after transformation
    # ---------------------------------------------------------
    numeric_clean_long <- shoppers_clean %>%
        select(
            Administrative_Duration,
            Informational_Duration,
            PageValues,
            ProductRelated,
            ProductRelated_Duration
        ) %>%
        pivot_longer(
            cols = everything(),
            names_to = "Variable",
            values_to = "Value"
        )
    
    p3 <- make_numeric_boxplot(
        numeric_clean_long,
        title = "Figure 3: Boxplots of Numeric Features"
    )
    
    ggsave(
        filename = paste0(output_prefix, "_figure3.png"),
        plot = p3,
        width = 12,
        height = 6
    )
    
    # ---------------------------------------------------------
    # Prepare data for Figures 4 and 5
    # ---------------------------------------------------------
    eda_df <- shoppers_clean %>%
        select(Weekend, Revenue, ProductRelated, ExitRates, SpecialDay) %>%
        mutate(
            Weekend = as.logical(as.character(Weekend)),
            Revenue_num = if_else(Revenue == "TRUE" | Revenue == "Yes", 1, 0)
        )
    
    # ---------------------------------------------------------
    # Figure 4: Purchase rate by product-related pages
    # ---------------------------------------------------------
    p4 <- ggplot(eda_df, aes(x = ProductRelated, y = Revenue_num)) +
        stat_summary_bin(fun = mean, bins = 25, geom = "point") +
        facet_wrap(
            ~ Weekend,
            labeller = as_labeller(c(`FALSE` = "Weekday", `TRUE` = "Weekend"))
        ) +
        scale_y_continuous(labels = percent_format(accuracy = 1), limits = c(0, 1)) +
        theme_minimal(base_size = 14) +
        labs(
            title = "Figure 4: Purchase Rate by Product Pages Visited",
            x = "Count of Product Pages Visited per User Session",
            y = "Purchase Rate"
        )
    
    ggsave(
        filename = paste0(output_prefix, "_figure4.png"),
        plot = p4,
        width = 10,
        height = 7
    )
    
    # ---------------------------------------------------------
    # Figure 5: Exit rates vs purchase outcome
    # ---------------------------------------------------------
    p5 <- ggplot(eda_df, aes(x = Revenue, y = ExitRates)) +
        geom_boxplot(fill = "orange") +
        facet_wrap(~ SpecialDay) +
        labs(
            title = "Figure 5: Exit Rates vs Purchase Outcome",
            subtitle = "Faceted by SpecialDay (0 = furthest from holiday, 1 = closest to holiday)",
            x = "Purchase Outcome",
            y = "Exit Rates (%)"
        ) +
        theme(
            text = element_text(size = 14),
            plot.title = element_text(face = "bold"),
            axis.title = element_text(face = "bold")
        )
    
    ggsave(
        filename = paste0(output_prefix, "_figure5.png"),
        plot = p5,
        width = 12,
        height = 7
    )
}

main(opt$input_file_path, opt$output_prefix)