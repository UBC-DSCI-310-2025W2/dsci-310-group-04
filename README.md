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

The analysis will follow the typical stages of a data science workflow:

1. **Data Loading**  
   Import the dataset from the original source.

2. **Data Cleaning**
   Data cleaning was performed to ensure data quality, consistency, and suitability for modeling.

3. **Exploratory Data Analysis (EDA)**  
   Summarize the dataset and create visualizations to understand relationships between shopper's behavior and intention to purchase.

4. **Modeling**  
   Build a LASSO logistic regression model to predict ending with a transaction based on behavioral and demographic features.

5. **Model Evaluation**  
   Evaluate the model's performance using appropriate metrics such as accuracy and confusion matrices.

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
docs/reports
```

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
Commands are provided in the Makefile to run parts of the analysis. 
When the Docker container is spun up through `docker compose up -d`, it automatically runs `make all` as the entrypoint script. 
This runs all the scripts, all tests, and compiles the Quarto report in project's `docs/reports/` folder in `.html` and `.pdf` format.

Any of the commands can be run in the container's project root `work/`. 
Here are some useful commands to run: 
- `make all`       -> runs all scripts, tests, and builds report
- `make test-all`  -> runs all tests 
- `make clean-all` -> deletes all compiled/generated files 
- and many more in the `Makefile`!

# Running the Analysis with the Makefile (Optional)

The analysis pipeline is automatically executed when running the project using Docker or Docker Compose via the `entrypoint.sh` script.

However, if you are working inside the RStudio environment or running the project locally, you can manually execute the pipeline using the Makefile.

### Run the full analysis pipeline

```bash
make all
```
This will generate the final report at reports/predicting_online_purchasing_behavior.html

### To remove all generated files:
```bash
make clean-all
```

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

The source code for this project is licensed under the **MIT License**. Please refer to the `LICENSE.md` file for full license details.
