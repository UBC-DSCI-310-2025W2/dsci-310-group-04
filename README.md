# DSCI-310-Group-04
# Predicting Online Purchase Intent from Consumer Behavior

## Contributors
- Athena Wong
- Oscar Yik
- Raghav Vashisht
- Gracie Shao

---

# Project Summary

This project investigates whether session-level browsing patterns can predict a user’s intent to complete an online purchase. Specifically, we examine how engagement metrics—such as page values, bounce rates, and session timing—are associated with a higher likelihood of conversion.

Using the **Online Shoppers Purchasing Intention Dataset**, we perform exploratory data analysis and build a LASSO logistic regression model to identify the most effective approach for predicting shopping behavior.

In addition to answering this research question, this project emphasizes **reproducible data science practices**, including version control using GitHub, virtual environment set up, literate programming using Jupyter notebooks using R, and containerized computational environments using Docker.

We concluded that session-level browsing behavior provides meaningful signals for predicting purchase intent, achieving strong overall performance (AUC = 0.926, accuracy ≈ 90%), but the pronounced class imbalance limits the model’s ability to detect purchasing sessions, resulting in substantially lower sensitivity compared to specificity.

---

# Research Question

**Can session-level browsing patterns (e.g. Bounce Rate, Special Day) predict whether an online shopping session ends in a purchase?**

---

# Dataset

The **Online Shoppers Purchasing Intention Dataset** originates from the UCI Machine Learning Repository (Sakar & Kastro, 2018). 

Dataset source:

https://archive.ics.uci.edu/dataset/468/online+shoppers+purchasing+intention+dataset

The dataset contains shopper's demographic and behavior information, including variables such as:

- `Administrative`
- `Informational`
- `ProductRelated`
- `BounceRates`
- `SpecialDay`
- `Region`
- `VisitorType`
- etc.

The target variable used in this project is **Revenue**, which is a **binary** variable that indicates whether the visit has been **finalized with a transaction**.

---

# Methods Overview

The analysis follows the typical stages of a data science workflow:

1. **Data Loading**
   Download the raw dataset from the UCI Machine Learning Repository using
   `src/R/01_data_loading.R`.

2. **Data Cleaning**
   Clean and split the data into training (80%) and test (20%) sets using
   `src/R/02_data_cleaning.R`. Splitting is performed here to prevent data
   leakage in downstream steps.

3. **Exploratory Data Analysis (EDA)**
   Generate visualisations and summary tables from the training set using
   `src/R/03_eda.R`. Outputs are saved to `results/`.

4. **Modeling**
   Fit a LASSO logistic regression model using `src/R/04_data_modelling.R`.
   The regularization parameter λ is selected via cross-validated AUC.
   Model artifacts are saved to `results/`.

5. **Model Evaluation**
   Evaluate model performance using accuracy, AUC-ROC, and per-class
   metrics including precision, recall, and F1 score. Given the class
   imbalance (~15% purchase rate), precision, recall, and F1 are
   particularly informative for assessing performance on the minority class.

6. **Report**
   The Quarto report (`reports/predicting_online_purchasing_behavior.qmd`)
   narrates the full analysis and embeds all figures and tables from
   `results/`. The rendered report is compiled to `docs/reports/` in both
   `.html` and `.pdf` formats.

---

# Analysis Pipeline

The full pipeline is automated using the `Makefile`. The stages connect as follows:

01_data_loading.R
↓
02_data_cleaning.R  →  data/processed/shoppers_train.csv
→  data/processed/shoppers_test.csv
↓
03_eda.R            →  results/eda_figure1.png ... eda_figure5.png
↓
04_data_modelling.R →  results/roc_curve.png
→  results/confusion_matrix.csv
→  results/model_metrics.csv
→  results/lasso_coefficients.csv
→  results/lasso_cv_plot.png
↓
quarto render       →  docs/reports/predicting_online_purchasing_behavior.html
→  docs/reports/predicting_online_purchasing_behavior.pdf

Each script takes the outputs of the previous step as inputs, so the
pipeline must be run in order. `make all` handles this automatically.

---

# How to Run the Analysis

To reproduce this analysis in Docker, follow the steps below.
> [!NOTE]
> This will recreate the entire RStudio development enviroment and reproduce the analysis, figures, and report.
> This reduces fragility of the analysis and eliminates the "it works on my machine" problem for contributers
> It is also helpful to have a clean environment to install packages without meddling with the existing system.

### 1. Clone the repository

```bash
git clone https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-04.git
```

### 2. Navigate to the project directory

```bash
cd dsci-310-group-04
```

### 3. Start the Docker Compose environment

```bash
docker compose up -d
```
> [!NOTE]
> The entrypoint to the pulled Docker container will run `make all` as the entrypoint to run all scripts and generate the report.

### 4. Wait for the analysis to complete
The analysis pipeline will run automatically inside the container.
Please allow approximately 1–2 minutes for all scripts to finish executing and the Quarto report to be compiled in `/docs/reports`.

### 5. View the output
Once the analysis is complete, the rendered reports will be available in:

```bash
docs/reports/predicting_online_purchasing_behavior.html
docs/reports/predicting_online_purchasing_behavior.pdf
```
Open the `.html` file in your browser to read the full report.

Alternatively, the latest rendered report is available online at:
[https://ubc-dsci-310-2025w2.github.io/dsci-310-group-04/](https://ubc-dsci-310-2025w2.github.io/dsci-310-group-04/)

### 6. (Optional) Access the RStudio environment

After launching the container, open your browser and go to:
```bash
http://127.0.0.1:8787
or
http://localhost:8787
```
Log in using:
- Username: rstudio
- Password: password

### 7. Stop the container
```bash
docker compose down
```

# Commands (Makefile)

Commands are provided in the `Makefile` to run parts of the analysis.
When the Docker container is spun up through `docker compose up -d`, it
automatically runs `make all` via the `entrypoint.sh` script. This runs
all scripts, all tests, and compiles the Quarto report into
`docs/reports/` in both `.html` and `.pdf` format.

Any of the following commands can be run manually inside the container
at the project root `work/`:

| Command | Description |
|---|---|
| `make all` | Runs the full pipeline: download, clean, EDA, model, and report |
| `make data` | Downloads the raw dataset only |
| `make process` | Cleans and splits the data |
| `make eda` | Generates EDA figures and tables |
| `make model` | Fits the model and generates evaluation artifacts |
| `make report` | Renders the Quarto report |
| `make test-all` | Runs all unit tests in `tests/testthat/` |
| `make clean-data` | Deletes downloaded and processed data files |
| `make clean-results` | Deletes generated figures and tables in `results/` |
| `make clean-report` | Deletes the rendered report |
| `make clean-all` | Deletes all generated files |

# Running the Tests

To run the full unit test suite manually, start the Docker container and run:

```bash
make test-all
```

This runs all tests in `tests/testthat/` using the `testthat` framework
and reports which tests pass or fail.

---

# Project Structure

```
.
├── README.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── CODEOWNERS
├── .gitignore
├── LICENSE.md
├── docker-compose.yml
├── _quarto.yml
├── renv.lock
├── Makefile
├── Dockerfile
├── entrypoint.sh
├── data/
│   └──processed/
│   └──raw/
├── reports/
│   └── fragments/
│   └── references/references.bib
│   └── predicting_online_purchasing_behavior.ipynb
│   └── predicting_online_purchasing_behavior.qmd
├── src/R
│   └──0*_*.R
├── tests/
│   └── testthat/
│      └──helper-*.R
│      └──test-*.R
│   └──testthat.R
├── results/
├── renv/
├── docs/
└── .github/workflows/
    └── publish_docker_image.yml 
```

---

# Dependencies
This project uses R (version 4.5.3) and manages package dependencies using renv to ensure reproducibility.

Key packages include:
- caret (7.0-1)
- docopt (0.7.2)
- glmnet (4.1-10)
- pROC (1.19.0.1)
- renv (1.1.8)
- rmarkdown (2.30)
- scales (1.4.0)
- tidyverse (2.0.0)

All package versions are recorded in the renv.lock file.

More information about renv.lock used in our project can be found [here](https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-04/blob/main/renv.lock)

---

# License

The source code for this project is licensed under the **MIT License**.
Please refer to the `LICENSE.md` file for full license details.

The written report and non-code materials are licensed under
[CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/),
meaning they may be shared with attribution but may not be modified or
used for commercial purposes.
