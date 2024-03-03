# ApartnmentData
This SQL script is part of a data preprocessing or cleaning project, related to USA real estate data stored in the "ApartmentData" table.

Let's analyze each section of the script:

## Select Top 50 Data:

Retrieve the top 50 rows from the "ApartmentData" table.
## Standardize Date Format:

Change the data type of the "SaleDate" column to DATE.
## Distinguish Address from Town:

Split the "PropertyAddress" column into separate columns for the address and town.
##  Insert Rows and Set Proper Address and Town Values:

Add new columns ("PropertySplitAddress" and "PropertyCity").
Update these new columns with the split values of address and town, respectively.
## Find Duplicates with Null Address Values:

Identify duplicate rows based on the "ParcelID" where the "PropertyAddress" is null.
Update null "PropertyAddress" values with the corresponding values from non-null rows with the same "ParcelID."
## Distinguish Address from Town and State in OwnerAddress:

Split the "OwnerAddress" column into separate columns for address, city, and state.
## Insert the New Values:

Add new columns for the split values of owner address, city, and state.
Update these new columns with the split values.
## Change 'Y' to 'Yes' and 'N' to 'No' for SoldAsVacant:

Update the values in the "SoldAsVacant" column, replacing 'Y' with 'Yes' and 'N' with 'No'.
## Find and Remove Duplicates:

Use a Common Table Expression (CTE) with the ROW_NUMBER() function to identify and number duplicate rows based on certain columns.
Delete rows with row numbers greater than 1, effectively removing duplicates.
