# Makefile
# DSCI 310 Group 04, Milestone 2
#
# This driver script runs the full analysis pipeline for predicting online
# purchase intention. It:
# 1) downloads the dataset,
# 2) cleans and splits it into train/test,
# 3) generates EDA artifacts (figures/tables),
# 4) fits and evaluates the model (figures/tables),
# 5) renders the Quarto report (no code shown in output).
#
# This Makefile takes no arguments.
#
# example usage:
# make all

.PHONY: all data process eda model report clean-data clean-results clean-report clean-all

# run entire analysis
all: reports/predicting_online_purchasing_behavior.html

# -------------------------
# data download (script 1)
# -------------------------
data: data/raw/online_shoppers_purchasing_intention_dataset.csv

data/raw/online_shoppers_purchasing_intention_dataset.csv: src/data_loading.R
	Rscript src/data_loading.R \
		--input_url="https://archive.ics.uci.edu/static/public/468/online+shoppers+purchasing+intention+dataset.zip" \
		--output_file_path="data/raw/online_shoppers_purchasing_intention_dataset.csv"

# --------------------------------
# clean + split (script 2)
# --------------------------------
process: data/processed/shoppers_train.csv \
	data/processed/shoppers_test.csv

data/processed/shoppers_train.csv data/processed/shoppers_test.csv: src/data_cleaning.R data/raw/online_shoppers_purchasing_intention_dataset.csv
	Rscript src/data_cleaning.R \
		--input_file_path="data/raw/online_shoppers_purchasing_intention_dataset.csv" \
		--output_dir="data/processed" \
		--seed=310 \
		--split=0.8

# -------------------------
# EDA artifacts (script 3)
# -------------------------
eda: results/eda_figure1.png \
	results/eda_figure2.png \
	results/eda_figure3.png \
	results/eda_figure4.png \
	results/eda_figure5.png

results/eda_figure1.png results/eda_figure2.png results/eda_figure3.png results/eda_figure4.png results/eda_figure5.png: src/eda.R data/processed/shoppers_train.csv
	Rscript src/eda.R \
		--input_file_path="data/processed/shoppers_train.csv" \
		--output_prefix="results/eda"

# ------------------------------
# model artifacts (script 4)
# ------------------------------
model: results/roc_curve.png \
	results/model_metrics.csv \
	results/confusion_matrix.csv \
	results/lasso_cv_plot.png \
	results/lasso_coefficients.csv

results/roc_curve.png results/model_metrics.csv results/confusion_matrix.csv results/lasso_cv_plot.png results/lasso_coefficients.csv: src/04_model.R data/processed/shoppers_train.csv data/processed/shoppers_test.csv
	Rscript src/04_model.R \
		--train="data/processed/shoppers_train.csv" \
		--test="data/processed/shoppers_test.csv" \
		--output_dir="results"

# -------------------------
# render the report
# -------------------------
reports/predicting_online_purchasing_behavior.html: reports/predicting_online_purchasing_behavior.qmd eda model
	quarto render reports/predicting_online_purchasing_behavior.qmd

# -------------------------
# clean targets
# -------------------------
clean-data:
	rm -f data/raw/online_shoppers_purchasing_intention_dataset.csv \
		data/processed/shoppers_train.csv \
		data/processed/shoppers_test.csv

clean-results:
	rm -f results/eda_figure1.png \
		results/eda_figure2.png \
		results/eda_figure3.png \
		results/eda_figure4.png \
		results/eda_figure5.png \
		results/lasso_cv_plot.png \
		results/roc_curve.png \
		results/model_metrics.csv \
		results/confusion_matrix.csv \
		results/lasso_coefficients.csv

clean-report:
	rm -f reports/predicting_online_purchasing_behavior.html
	rm -rf reports/predicting_online_purchasing_behavior_files

clean-all: clean-data clean-results clean-report 