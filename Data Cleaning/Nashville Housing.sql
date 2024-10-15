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

-- Populate Property Address Data 

select * 
From PortfolioProject..NashVilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashVilleHousing as a 
join PortfolioProject..NashVilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a 
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashVilleHousing as a 
join PortfolioProject..NashVilleHousing as b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null