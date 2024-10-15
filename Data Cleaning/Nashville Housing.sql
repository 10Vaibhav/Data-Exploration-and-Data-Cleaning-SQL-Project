-- Cleaning the Data 

Select * 
From PortfolioProject..NashVilleHousing

-- Standardize Date Format 

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject..NashVilleHousing

Update PortfolioProject..NashVilleHousing
set SaleDate = CONVERT(Date, SaleDate)

Alter Table NashVilleHousing
Add SaleDateConverted Date

Update PortfolioProject..NashVilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

