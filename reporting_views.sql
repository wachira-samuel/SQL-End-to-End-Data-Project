drop view if exists vw_patient_reporting;

create view vw_patient_reporting as
select
    *,
    (discharge_date - admission_date) as length_of_stay,
    coalesce(treatment_cost,0)
        -
    coalesce(mobile_money_payment,0)
    as outstanding_balance
from standardized_patient_records;
--test the view
select *
from vw_patient_reporting vpr 
limit 10;