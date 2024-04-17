--Data Cleaning Portfolio Project 

-- Cleaning Data in SQL Queries

Select *
From [Portfolio Project].dbo.NashvilleHousing

--Standardize Data Format

Select SaleDate, Convert(DATE,SaleDate)
From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE


--Populate Property Address data

Select PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing
Where PropertyAddress is null


Select *
From [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a 
JOIN [Portfolio Project].dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a 
JOIN [Portfolio Project].dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From [Portfolio Project].dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))
     

Select *

From [Portfolio Project].dbo.NashvilleHousing




Select OwnerAddress
from [Portfolio Project].dbo.NashvilleHousing


Select 
Parsename(Replace(OwnerAddress,',','.'),3)
,Parsename(Replace(OwnerAddress,',','.'),2)
,Parsename(Replace(OwnerAddress,',','.'),1)
From [Portfolio Project].dbo.NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState = Parsename(Replace(OwnerAddress,',','.'),1)




--Change Y and N to Yes and No in 'Sold as Vacant'

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END
From [Portfolio Project].dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END


--Remove Duplicates

With RowNumCTE AS(
Select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY 
				      UniqueID
					  ) row_num

From [Portfolio Project].dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


--Delete Unused Columns 

Select *

From [Portfolio Project].dbo.NashvilleHousing


Alter TABLE [Portfolio Project].dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter TABLE [Portfolio Project].dbo.NashvilleHousing
Drop Column  SaleDate
