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

---

# Research Question

**Can session-level browsing patterns (e.g. Bounce Rate, Special Day) predict whether an online shopping session ends in a purchase?**

---

# Dataset

The **Online Shoppers Purchasing Intention Dataset** originates from the UCI Machine Learning Repository (Sakar & Kastro, 2018). 

Dataset source:

https://archive.ics.uci.edu/dataset/468/online+shoppers+purchasing+intention+dataset

The dataset contains shopper's demographic and behavior information, including variables such as:

- Administrative
- Informational
- ProductRelated
- BounceRates
- SpecialDay
- Region
- VisitorType
- etc.

The target variable used in this project is **Revenuw**, which is a **binary** variable that indicates whether the visit has been **finalized with a transaction**.

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

To reproduce this analysis, follow the steps below.

### 1. Clone the repository

```bash
git clone https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-04.git
```

### 2. Navigate to the project directory

```bash
cd dsci-310-group-04
```

### 3. Create a Docker image from the Dockerfile

```bash
docker build -t purchase-intention-analysis .
```

### 4. Run the Docker container

```bash
docker run --rm -e PASSWORD="dsci" -p 8888:8888 purchase-intention-analysis
```

### 5. Open the Jupyter Notebook

After launching the container, open the Jupyter link shown in the terminal and run the analysis notebook named 'predicting_online_purchasing_behavior.ipynb' under reports/.

---

# Project Structure

```
.
├── README.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── CODEOWNERS
├── .gitignore
├── LICENSE
├── Dockerfile
├── docker-compose.yml
├── renv.lock
├── data/
│   └──processed/
│   └──raw/
├── docs/
│   └──milestone_1/
├── reports/
│   └──predicting_online_purchasing_behavior.ipynb
└── .github/workflows/
    └── publish_docker_image.yml 
```

---

# Dependencies

This project requires the following software and R libraries:
- rstudio(4.5.2)

- tidyverse
- glmnet
- ucimlrepo
- scales
- pROC
- caret

---

# License

The source code for this project is licensed under the **MIT License**. Please refer to the `LICENSE.md` file for full license details.
