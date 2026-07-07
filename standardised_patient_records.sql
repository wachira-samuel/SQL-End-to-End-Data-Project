drop table if exists standardized_patient_records;
create table standardized_patient_records as
select
    patient_id,
    trim(hospital_name) as hospital_name,
    trim(county) as county,
    case
        when admission_date ~ '^\d{4}-\d{2}-\d{2}$'
            then admission_date::date
        when admission_date ~ '^\d{2}/\d{2}/\d{4}$'
            then to_date(admission_date,'DD/MM/YYYY')
        when admission_date ~ '^\d{4}\.\d{2}\.\d{2}$'
            then to_date(admission_date,'YYYY.MM.DD')
        when admission_date ~ '^[A-Za-z]{3}-\d{4}$'
            then to_date('01-' || admission_date,'DD-Mon-YYYY')
        else null
    end as admission_date,
    case
        when discharge_date ~ '^\d{4}-\d{2}-\d{2}$'
            then discharge_date::date
        when discharge_date ~ '^\d{2}/\d{2}/\d{4}$'
            then to_date(discharge_date,'DD/MM/YYYY')
        when discharge_date ~ '^\d{4}\.\d{2}\.\d{2}$'
            then to_date(discharge_date,'YYYY.MM.DD')
        when discharge_date ~ '^[A-Za-z]{3}-\d{4}$'
            then to_date('01-' || discharge_date,'DD-Mon-YYYY')
        else null
    end as discharge_date,
    case
        when age ~ '^\d+$'
            then age::integer
        else null
    end as age,
    case
        when lower(trim(gender))='male' then 'Male'
        when lower(trim(gender))='female' then 'Female'
        else 'Unknown'
    end as gender,
    trim(disease) as disease,
    nullif(
        regexp_replace(treatment_cost,'[^0-9.]','','g'),
        ''
    )::numeric(12,2) as treatment_cost,
    nullif(
        regexp_replace(insurance_cover,'[^0-9.]','','g'),
        ''
    )::numeric(12,2) as insurance_cover,
    nullif(
        regexp_replace(mobile_money_payment,'[^0-9.]','','g'),
        ''
    )::numeric(12,2) as mobile_money_payment,
    trim(blood_pressure) as blood_pressure,
    nullif(
        regexp_replace(temperature,'[^0-9.]','','g'),
        ''
    )::numeric(4,1) as temperature,
    trim(doctor_id) as doctor_id,
    case
        when upper(trim(follow_up_required)) in ('Y','YES')
            then 'Yes'
        when upper(trim(follow_up_required)) in ('N','NO')
            then 'No'
        else 'Unknown'
    end as follow_up_required
from clean_patient_records;

-- verify data types
select
    column_name,
    data_type
from information_schema.columns
where table_name='standardized_patient_records'
order by ordinal_position;