-- Cleaning the Data 

Select * 
From PortfolioProject..NashVilleHousing

-------------------------------------------------------------------------------------------------------

-- Standardize Date Format 

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject..NashVilleHousing

Update PortfolioProject..NashVilleHousing
set SaleDate = CONVERT(Date, SaleDate)

Alter Table NashVilleHousing
Add SaleDateConverted Date

Update PortfolioProject..NashVilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

-------------------------------------------------------------------------------------------------------

-- Populate Property Address Data (Handling Null Values or Missing Values)

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

-------------------------------------------------------------------------------------------------------

-- Breaking out Address into individual  columns (Address, city, State)

-- 1. Do this for PropertyAddress

select  PropertyAddress
From PortfolioProject..NashVilleHousing

Select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as City
From PortfolioProject..NashVilleHousing

Alter Table PortfolioProject..NashVilleHousing
Add PropertySplitAddress Nvarchar(255)

Update PortfolioProject..NashVilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) - 1)


Alter Table PortfolioProject..NashVilleHousing
Add PropertySplitCity Nvarchar(255)

Update PortfolioProject..NashVilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))


-- 2. Do this for OwnerAddress

Select OwnerAddress 
From PortfolioProject..NashVilleHousing

Select 
/* ParseName is doing things in backward */
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject..NashVilleHousing

Alter Table PortfolioProject..NashVilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update PortfolioProject..NashVilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table PortfolioProject..NashVilleHousing
Add OwnerSplitCity Nvarchar(255)

Update PortfolioProject..NashVilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table PortfolioProject..NashVilleHousing
Add OwnerSplitState Nvarchar(255)

Update PortfolioProject..NashVilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


Select * 
From PortfolioProject..NashVilleHousing

-------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct SoldAsVacant, Count(SoldAsVacant)
From PortfolioProject..NashVilleHousing
group by SoldAsVacant
order by 2 

select 
SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
From PortfolioProject..NashVilleHousing

Update PortfolioProject..NashVilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End

-------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCTE AS(

Select * ,
	ROW_NUMBER() over(
	Partition by
	ParcelId,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by 
	UniqueID	
	) row_num
From PortfolioProject ..NashVilleHousing

)
Delete
from RowNumCTE
where row_num > 1



Select * 
From 
PortfolioProject ..NashVilleHousing


-------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Alter Table PortfolioProject ..NashVilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table PortfolioProject ..NashVilleHousing
Drop Column SaleDate

Select * 
From 
PortfolioProject ..NashVilleHousing