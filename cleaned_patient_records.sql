create table clean_patient_records as 
select distinct *
from raw_patients_records rpr ;

WITH ranked_records AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY patient_id,
                            hospital_name,
                            admission_date,
                            disease,
                            treatment_cost
               ORDER BY patient_id
           ) AS rn
    FROM raw_patients_records rpr
)
SELECT *
FROM ranked_records
WHERE rn = 1;

SELECT *
FROM raw_patients_records rpr
WHERE patient_id IN (
    SELECT patient_id
    from raw_patients_records rpr
    GROUP BY patient_id
    HAVING COUNT(*) > 1
)
ORDER BY patient_id;
select *
from clean_patient_records cpr ;
where discharge_date < admission_date;