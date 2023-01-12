select * from guided..NashVilleHousing
--standardize Date Format

select SaleDateConverted,cast(saledate as date)
from guided..NashVilleHousing

update NashVilleHousing set SaleDate - cast(saledate as date)

ALTER TABLE  NashVilleHousing
Add  SaleDateConverted Date;

update NashVilleHousing 
set SaleDateConverted = convert(date,saledate)

--property address
select * 
from guided..NashVilleHousing 
--where PropertyAddress is  null
order by ParcelID



select a.ParcelID, a.PropertyAddress , b.ParcelID, b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
from guided..NashVilleHousing as a
Join guided..NashVilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
--where PropertyAddress is  null
where a.PropertyAddress is null
update a
set PropertyAddress=isnull(a.propertyaddress,b.PropertyAddress)
from guided..NashVilleHousing as a
Join guided..NashVilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
--where PropertyAddress is  null
 

 select PropertyAddress from guided..NashVilleHousing


 select substring(propertyaddress,1,charindex(',', PropertyAddress)-1) as address,
 substring(propertyaddress,charindex(',', PropertyAddress)+1 ,len(propertyaddress)) as address
 from guided..NashVilleHousing

 use Guided 

 ALTER TABLE  NashVilleHousing
Add  propertySplitaddress nvarchar(255);

update NashVilleHousing 
set propertySplitaddress = substring(propertyaddress,1,charindex(',', PropertyAddress)-1) 

ALTER TABLE  NashVilleHousing
Add  propertyspllitcity  nvarchar(255);

update NashVilleHousing 
set propertyspllitcity = substring(propertyaddress,charindex(',', PropertyAddress)+1 ,len(propertyaddress)) 

select * from guided..NashVilleHousing
order by propertyspllitcity


select owneraddress
from guided..NashVilleHousing
select PARSENAME(replace(owneraddress,',','.'),3),
 PARSENAME(replace(owneraddress,',','.'),2),
  PARSENAME(replace(owneraddress,',','.'),1)
from guided..NashVilleHousing




 ALTER TABLE  NashVilleHousing
Add  ownersplitaddress nvarchar(255);

update NashVilleHousing 
set ownerSplitaddress =  PARSENAME(replace(owneraddress,',','.'),3)

alter table Guided..NashVilleHousing drop column owneryspllitcity;

ALTER TABLE  NashVilleHousing
Add  ownerspllitcity  nvarchar(255);

update NashVilleHousing 
set ownerspllitcity = PARSENAME(replace(owneraddress,',','.'),2);

alter table Guided..NashVilleHousing drop column  owneryspllitstate;

ALTER TABLE  NashVilleHousing
Add  ownerspllitstate nvarchar(255);

update NashVilleHousing 
set ownerspllitstate =   PARSENAME(replace(owneraddress,',','.'),1)

select * 
from NashVilleHousing



select distinct(SoldAsVacant), count(soldasvacant)
from guided..NashVilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,	case when soldasvacant ='Y' then 'YES'
		 when soldasvacant ='N' then 'NO'
	else soldasvacant
end as  new
from guided..NashVilleHousing

update NashVilleHousing
set SoldAsVacant=
	case when soldasvacant ='Y' then 'YES'
		 when soldasvacant ='N' then 'NO'
	else soldasvacant
end 
with rowNumCTE as(
select *,
row_number () over(partition by parcelid, propertyaddress, saleprice, saledate,legalreference order by uniqueid) as row_num
from guided..NashVilleHousing
--order by ParcelID
)
select *
from rowNumCTE
where row_num> 1
--order by PropertyAddress


--delete unused columns
select * 
from  guided..NashVilleHousing

alter table guided..nashvillehousing 
drop column owneraddress, taxdistrict,propertyaddress 
alter table guided..nashvillehousing 
drop column saledate