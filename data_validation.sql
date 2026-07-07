--Total records
select count(*) as total_records
from raw_patients_records rpr ;

-- 1.Missing Patient IDS
select count(*) as missing_patient_ids
from raw_patients_records rpr 
where rpr.patient_id is null
or trim(rpr.patient_id ) ='';

-- 2.Missing Hospital Names
select count(*) as missing_hospital_names
from raw_patients_records  rpr
where hospital_name is null
or trim(hospital_name) = '';


-- 3.Missing County Names
select count(*) as missing_county_names
from raw_patients_records  rpr
where rpr.county  is null
or trim(rpr.county ) = '';


-- 4.Missing Doctor identifiers
select count(*) as missing_docter_identifiers
from raw_patients_records  rpr
where rpr.doctor_id  is null
or trim(rpr.doctor_id ) = '';


-- 5.Invalid Numeric values
--a)Invalid treatment cost
select *
from raw_patients_records rpr 
where rpr.treatment_cost is not null
and rpr.treatment_cost !~ '^[0-9,.]+$';

--b)Invalid mobile money payments 
select *
from raw_patients_records rpr 
where rpr.mobile_money_payment  is not null
and rpr.mobile_money_payment  !~ '^[0-9,.]+$';

--c)age
select *
from raw_patients_records rpr 
where age is not null and trim(age) <> '' and age !~ '^[0-9,.]+$';

--d)temperature
select * 
from raw_patients_records rpr 
where temperature is not null and trim(temperature) <> '' and temperature !~ '^[0-9,.]+$';

-- 6.Invalid Dates
-- a)Invalid Admission dates
select *
from raw_patients_records rpr 
where rpr.admission_date is null
or rpr.admission_date = '';

-- b)Invalid discharge dates
select *
from raw_patients_records rpr 
where rpr.discharge_date is null
or rpr.discharge_date = '';

-- c)Invalid date order
select *
from raw_patients_records rpr 
where rpr.discharge_date < rpr.admission_date ;

--d)Incorrect date format
select  *
from raw_patients_records rpr 
where  admission_date !~ '^\d{4}-\d{2}-\d{2}$';

--Duplicate patient ids
select patient_id,
count (*) as occurences
from raw_patients_records rpr 
group by patient_id 
having count(*) >1;

-- true duplicates
select *
from raw_patients_records rpr 
where patient_id IN (
   select patient_id
    from raw_patients_records rpr2 
    group by patient_id
    having count (*) > 1
)
order by patient_id;

