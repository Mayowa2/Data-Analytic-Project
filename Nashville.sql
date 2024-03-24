CREATE DATABASE Portfolio_Project

SELECT *
FROM [dbo].[NashvilleHousing]

/*

Cleaning Data in SQL Queries

*/

-- Standardize Date Format

SELECT * 
FROM [dbo].[NashvilleHousing]


ALTER TABLE [dbo].[NashvilleHousing]
ADD SalesDateConverted DATE

UPDATE [dbo].[NashvilleHousing]
SET SalesDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address data
SELECT PropertyAddress
FROM [dbo].[NashvilleHousing]
WHERE  PropertyAddress IS NULL

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM [dbo].[NashvilleHousing] A
JOIN [dbo].[NashvilleHousing] B
ON A.ParcelID = B.ParcelID
WHERE A.[UniqueID ]!=B.[UniqueID ]
AND A.PropertyAddress IS NULL


UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM [dbo].[NashvilleHousing] A
JOIN [dbo].[NashvilleHousing] B
ON A.ParcelID = B.ParcelID
WHERE A.[UniqueID ]!=B.[UniqueID ]




SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM [dbo].[NashvilleHousing]

ALTER TABLE [dbo].[NashvilleHousing]
ADD PropertySplitAddress Varchar(250)

ALTER TABLE [dbo].[NashvilleHousing]
ADD PropertySplitCity Varchar(250)


UPDATE [dbo].[NashvilleHousing] 
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

UPDATE [dbo].[NashvilleHousing] 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


SELECT OwnerAddress
FROM [dbo].[NashvilleHousing]
WHERE  PropertyAddress IS NULL

SELECT SUBSTRING(OwnerAddress,1,CHARINDEX(',',OwnerAddress)-1)
,SUBSTRING(OwnerAddress,CHARINDEX(',',OwnerAddress)+1, CHARINDEX(',',OwnerAddress)-1)),
FROM [dbo].[NashvilleHousing]


SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3)
	,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
	,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [dbo].[NashvilleHousing]


ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerSplitAddress Varchar(250)

ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerSplitCity Varchar(250)

ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerSplitState Varchar(250)

UPDATE [dbo].[NashvilleHousing] 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE [dbo].[NashvilleHousing] 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE [dbo].[NashvilleHousing] 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
FROM [dbo].[NashvilleHousing]



-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT SoldAsVacant
FROM [dbo].[NashvilleHousing]

SELECT DISTINCT SoldAsVacant, Count(SoldAsVacant)
FROM [dbo].[NashvilleHousing]
GROUP BY SoldAsVacant


SELECT *
,CASE
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END 
FROM [dbo].[NashvilleHousing]

UPDATE [dbo].[NashvilleHousing]
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END 


	-- Remove Duplicates

WITH RowNumCTE AS(
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

From [dbo].[NashvilleHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress





--Delete Unused Columns

ALTER TABLE[dbo].[NashvilleHousing]
DROP COLUMN PropertyAddress, OwnerAddress

ALTER TABLE[dbo].[NashvilleHousing]
DROP COLUMN SaleDate

SELECT*
FROM[dbo].[NashvilleHousing]