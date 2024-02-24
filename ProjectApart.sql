--FIRST VIEW OF DATA - SELECT TOP 50 DATA
SELECT TOP (50) *
  FROM ApartmentData

-- Standardize Date Format
ALTER TABLE ApartmentData
ALTER COLUMN  SaleDate DATE

-- Property Address data - Distinguish Address from Town

Select PropertyAddress
From ApartmentData

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Town
From ApartmentData


--Insert Rows and Set them with the Proper Address and Town Values
ALTER TABLE ApartmentData
ADD  PropertySplitAddress varchar(255);

Update ApartmentData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE ApartmentData
ADD PropertyCity varchar(255);

Update ApartmentData
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

--Find Duplicates with null address values and fill them with their address
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From ApartmentData a
JOIN ApartmentData b
	on a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From ApartmentData a
JOIN ApartmentData b
	on a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


-- OwnerAddress data - Distinguish Address from Town and State

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From ApartmentData

--Insert the new values

ALTER TABLE ApartmentData
ADD  OwnerSplitAddress varchar(255);

Update ApartmentData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE ApartmentData
ADD OwnerSplitCity varchar(255);

Update ApartmentData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE ApartmentData
ADD OwnerSplitState varchar(255);

Update ApartmentData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--CHANGE Y TO YES AND N TO NO

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM ApartmentData
GROUP BY SoldAsVacant

SELECT SoldAsVacant ,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
	END
FROM ApartmentData

Update ApartmentData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
	END

-- Find and Remove Duplicates
WITH RowNumCTE AS (
SELECT *,

	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
	) row_num

From ApartmentData
)
--SELECT * 
--FROM RowNumCTE
--WHERE row_num > 1

DELETE 
FROM RowNumCTE
WHERE row_num > 1
