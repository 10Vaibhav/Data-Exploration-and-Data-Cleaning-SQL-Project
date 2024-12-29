# SQL Data Analysis Projects

This repository contains SQL scripts for analyzing and cleaning two different datasets: Nashville Housing Data and COVID-19 Data. The projects demonstrate various SQL techniques for data cleaning, transformation, and exploratory data analysis.

## Project 1: Nashville Housing Data Cleaning

### Overview
This project focuses on cleaning and standardizing Nashville housing data to make it more suitable for analysis. The cleaning process includes various SQL operations to handle missing values, standardize formats, and improve data quality.

### Data Cleaning Operations
1. **Date Standardization**
   - Converted SaleDate to standard date format
   - Created new column SaleDateConverted for cleaned dates

2. **Property Address Data**
   - Populated missing Property Address data
   - Used self-join to fill null values based on ParcelID matches

3. **Address Breaking**
   - Split PropertyAddress into separate columns for address and city
   - Split OwnerAddress into address, city, and state using PARSENAME
   - Created new columns to store the split address components

4. **Standardizing Values**
   - Converted 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant field
   - Used CASE statements for consistent formatting

5. **Data Cleaning**
   - Removed duplicate records using ROW_NUMBER() and CTEs
   - Dropped unused columns to optimize the dataset

## Project 2: COVID-19 Data Exploration

### Overview
This project analyzes COVID-19 death and vaccination data to uncover insights about the pandemic's impact across different locations and time periods.

### Analysis Components
1. **Death Analysis**
   - Calculated death percentages by country
   - Analyzed total deaths vs total cases
   - Identified countries with highest death counts
   - Created continental death statistics

2. **Infection Analysis**
   - Calculated infection rates relative to population
   - Identified countries with highest infection rates
   - Tracked total cases vs population percentage

3. **Vaccination Analysis**
   - Created rolling counts of vaccinations
   - Analyzed population vs vaccination rates
   - Used CTE and Temp Tables for complex calculations

4. **Visualization Preparation**
   - Created views for storing transformed data
   - Prepared datasets for later visualization

### Technical Components Used
- CTEs (Common Table Expressions)
- Temporary Tables
- Windows Functions
- Views
- Joins
- Aggregate Functions
- Data Type Conversion
- String Functions

## 📄 License
This repository is licensed under the [MIT License](LICENSE).

