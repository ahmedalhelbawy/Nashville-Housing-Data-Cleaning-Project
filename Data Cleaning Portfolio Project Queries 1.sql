

--Populate Property Address data 


Select *
 FROM PortfolioProjects.dbo.NashvilleHousing


 ------------------------------------------------------------------

 --Standardize Date Format


SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProjects.dbo.NashvilleHousing;


 Update NashvilleHousing
 SET SateDate = CONVERT(Date, SaleDate)

 ALTER TABLE NashvilleHousing
 Add saleDate Date;

 Update NashvilleHousing
 SET SateDate = CONVERT(Date, SaleDate)


----------------------------------------------------------------------


--Populate Property Address data 

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID



SELECT a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM 
     PortfolioProjects.dbo.NashvilleHousing a
JOIN 
     PortfolioProjects.dbo.NashvilleHousing b
    on a.parcelID = b.parcelID 
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null
 

 Update a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM 
     PortfolioProjects.dbo.NashvilleHousing a
JOIN
     PortfolioProjects.dbo.NashvilleHousing b
    on a.parcelID = b.parcelID 
	AND a.[UniqueID] <> b.[UniqueID]


---------------------------------------------------------------------


--Breaking out Address into Individual columns (Addess, City, State)

SELECT PropertyAddress 
FROM
     PortfolioProjects.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address 
FROM
     PortfolioProjects.dbo.NashvilleHousing



ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);


 Update
       PortfolioProjects.dbo.NashvilleHousing
 SET 
       PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 


 ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
 Add PropertySplitCity Nvarchar(255);

 Update 
       PortfolioProjects.dbo.NashvilleHousing
 SET 
       PropertySplitCit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) 



SELECT *
FROM
     PortfolioProjects.dbo.NashvilleHousing






SELECT OwnerAddress
FROM
     PortfolioProjects.dbo.NashvilleHousing



SELECT 
     PARSENAME(REPLACE(OwnerAddress, ',', ','), 3)
	,PARSENAME(REPLACE(OwnerAddress, ',', ','), 2)
	,PARSENAME(REPLACE(OwnerAddress, ',', ','), 1)
FROM
     PortfolioProjects.dbo.NashvilleHousing
--Where OnwerAddress not NULL







ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
ADD OnwerSplitAddress NVARCHAR(255);

 Update
       PortfolioProjects.dbo.NashvilleHousing
 SET 
       OnwerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', ','), 3)



 ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
 Add OnwerSplitCity Nvarchar(255);

 Update 
       PortfolioProjects.dbo.NashvilleHousing
 SET 
       OnwerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', ','), 2)



ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
ADD OnwerSplitState NVARCHAR(255);

 Update
       PortfolioProjects.dbo.NashvilleHousing
 SET 
       OnwerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', ','), 1)



SELECT *
FROM
     PortfolioProjects.dbo.NashvilleHousing



-----------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From 
     PortfolioProjects.dbo.NashvilleHousing
Group by
      SoldAsVacant
Order by 
       2





Select SoldAsVacant 
,   CASE when SoldAsVacant = 'Y' THEN 'Yes'
         when SoldAsVacant = 'N' THEN 'NO'
		 END
From 
     PortfolioProjects.dbo.NashvilleHousing


Update PortfolioProjects.dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
         when SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
		 END


----------------------------------------------------------------------


--Remove Duplicates

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
From 
     PortfolioProjects.dbo.NashvilleHousing


--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing



-------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProjects.dbo.NashvilleHousing


ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



