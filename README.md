# Real Estate Analysis

This project explores the relationship between loan and property characteristics at origination and the subsequent performance of commercial real estate loans. The goal is to develop insights into risk patterns in lending portfolios using a dataset of multifamily, office, or retail loans originated in the United States during 2012–2013.

## 📚 Context

This case was completed as part of a university assignment focusing on:
- Exploratory Data Analysis (EDA)
- Data cleaning and manipulation in R
- Identifying key relationships in data
- Communicating insights using visualizations

## 🧠 Objective

Analyze a dataset of real estate loans to:
- Understand the structure and quality of the data
- Explore key variables and summary statistics
- Identify relationships between initial loan/property features and loan performance (e.g., default, prepayment)
- Visualize and communicate findings effectively

## 🛠️ Tools & Technologies

- **R** (primary programming language)
- **tidyverse** for data manipulation and visualization
- **readxl** for loading Excel files
- **ggplot2** and **other visualization libraries**
- Additional packages as needed for EDA and merging external datasets

## 🗂️ Project Structure

├── data/
│   ├── original_download.xlsx        # Raw data downloaded from Bloomberg terminal
│   ├── cleaned_data.csv              # Cleaned and merged dataset used for analysis
├── scripts/
│   └── case1_analysis.R              # Main R script containing all analysis steps
├── output/
│   ├── summary_statistics.csv        # Output of summary statistics tables
│   ├── visualizations/               # Folder containing all generated plots and charts
├── writeup/
│   └── Case1_Memo.pdf                # Final 1-2 page memo summarizing findings
└── README.md                         # Project overview and instructions


## 🔍 Key Steps in the Analysis

### 1. Data Acquisition
- Downloaded data from Bloomberg, including separate tabs for loans and properties.
- Focused on fixed-rate loans where possible.

### 2. Data Cleaning
- Removed unnecessary headers.
- Ensured one-to-one mapping between loans and properties.
- Merged loan and property-level data into a single DataFrame.

### 3. Exploratory Data Analysis
- Generated summary statistics and explored distributions.
- Investigated correlations among features.

### 4. Relationship Analysis
- Explored how characteristics at origination related to outcomes like:
  - Default
  - Early repayment
  - Delinquency
- Considered using external benchmark interest rates or market-level income data for deeper insights.

### 5. Visualization
- Created charts and graphs to communicate key findings.
- Used `ggplot2`, `corrplot`, and other R libraries for visual storytelling.

### 6. Final Memo
- Produced a professionally written 1–2 page memo summarizing the analysis and findings.

