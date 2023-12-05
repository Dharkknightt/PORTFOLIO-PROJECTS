/* PERFORMING DATA CLEANING IN SQL USING A NASHVILLE HOUSING DATASET */

Use PROJECTS;

Select *
From projects.dbo.Nashville

 
/* CREATING A PROCEDURE TO SELECT ALL COLUMNS */
create procedure total 
as
Begin 
select * from projects.dbo.nashville
End;

 

/* STANDARDIZING THE DATE FORMAT */

Select saledate, convert(Date,SaleDate)
From projects.dbo.Nashville
 
ALTER TABLE Nashville
Add SaleDateConverted Date;

update Nashville 
set saledateconverted =  convert(Date,SaleDate);

alter table nashville 
drop column saledate

exec sp_rename 'nashville.saledateconverted','saledate', 'column'



/* POPULATING THE PROPERTY ADRESS DATA */

Exec total;

Select propertyaddress
From projects.dbo.Nashville
--Where PropertyAddress is null

order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PROJECTS.dbo.Nashville as a
JOIN PROJECTS.dbo.Nashville as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Projects.dbo.Nashville as a
JOIN Projects.dbo.Nashville as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



/* BREAKING OUT THE ADDRESS INTOINDIVIDUAL COLUMNS (ADDRESS, CITY, STATE) */

Select PropertyAddress
From PROJECTS.dbo.Nashville
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From Projects.dbo.Nashville

ALTER TABLE Nashville
Add PropertySplitAddress Nvarchar(255);

Update Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville
Add PropertySplitCity Nvarchar(255);

Update Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Exec Total;


Select OwnerAddress
From PROJECTS.dbo.Nashville


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Projects.dbo.Nashville


ALTER TABLE Nashville
Add OwnerSplitAddress Nvarchar(255);

Update Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville
Add OwnerSplitCity Nvarchar(255);

Update Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashville
Add OwnerSplitState Nvarchar(255);

Update Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Exec Total;




/* CHANGING Y AND N TO YES AND NO IN THE "SOLD AS VACANT" COLUMN */


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Projects.dbo.Nashville
Group by SoldAsVacant
order by 2




Select SoldAsVacant, CASE
       When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Projects.dbo.Nashville

Update Nashville
SET SoldAsVacant = CASE
       When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
END


/* REMOVING DUPLICATES */


WITH RowNumCTE AS(
Select *,
ROW_NUMBER() 
OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
 ORDER BY UniqueID
) row_num

From Projects.dbo.Nashville
--order by ParcelID
)
delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

-- CHECKING TO CONFIRM DELETION --
WITH RowNumCTE AS(
Select *,
ROW_NUMBER() 
OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
 ORDER BY UniqueID
) row_num

From Projects.dbo.Nashville
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

Exec Total;


/* Deleting Unused Columns */

Exec Total;

ALTER TABLE Projects.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
