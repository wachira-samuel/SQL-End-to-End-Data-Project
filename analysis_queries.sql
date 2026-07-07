--Total hospitals
select count(distinct hospital_name) as total_hospitals
from clean_patient_records cpr;

--Hospital with the highest patient visits
select hospital_name,
count (*) as patient_visits
from clean_patient_records cpr 
group by cpr.hospital_name 
order by patient_visits desc
limit 1;

--hospital with te lowest patient visits
select hospital_name,
count (*) as patient_visits
from clean_patient_records cpr 
group by cpr.hospital_name 
order by patient_visits
limit 1;

--hospitals handling more patients than average.
with hospital_summary as(
select hospital_name, county,
count(*) as patient_visits
from clean_patient_records cpr 
group by hospital_name ,county 
)
select *
from hospital_summary	
where patient_visits >
(
	select avg(patient_visits)
	from hospital_summary
)
order by patient_visits desc;


--hospital handling patients below average
with hospital_summary as (
select
hospital_name,
count(*) as patient_visits
from vw_patient_reporting vpr
group by hospital_name
)
select *
from hospital_summary
where patient_visits <
(
select avg(patient_visits)
from hospital_summary
)
order by patient_visits;


--highest numebr of long stay,assuming long stay = more than 7 days.
select
hospital_name,
count(*) as long_stay_patients
from vw_patient_reporting vpr
where vpr.length_of_stay > 7
group by hospital_name
order by long_stay_patients desc;

--Highest number of short stay patients
select
hospital_name,
count(*) as short_stay_patients
from vw_patient_reporting vpr
where vpr.length_of_stay <=2
group by hospital_name 
order by short_stay_patients desc;

--hospitals requiring most follow up.
select
hospital_name,
count(*) as follow_up_cases
from vw_patient_reporting vpr 
where vpr.follow_up_required ='Yes'
group by hospital_name 
order by follow_up_cases desc;

--hospital requiring least follow up
select
hospital_name,
count(*)as follow_up_cases
from vw_patient_reporting vpr 
where follow_up_required ='Yes'
group by hospital_name 
order by follow_up_cases
limit 10;

--operational pressure index
select
hospital_name,
count(*) as patient_visits,
avg(length_of_stay) as average_length_of_stay,
sum(outstanding_balance) as outstanding_balance
from vw_patient_reporting vpr 
group by hospital_name 
order by patient_visits desc,
average_length_of_stay desc;

--COUNTY RELATIONSHIPS
--counties with the most hospitals
select
county,
count(distinct hospital_name) as hospitals
from vw_patient_reporting vpr 
group by county
order by hospitals desc;

--counties with the fewest hospitals
select
county,
count(distinct hospital_name) as hospitals
from vw_patient_reporting vpr 
group by county
order by hospitals;



--county hospital with highest patient visits
select
county,
hospital_name,
count(*) as patient_vists
from vw_patient_reporting vpr 
group by county, hospital_name 
order by patient_vists desc ;


----county hospital with highest treatment
select 
county,
hospital_name,
sum(treatment_cost) as total_cost
from vw_patient_reporting vpr 
group by county, hospital_name
order by total_cost desc;

--county hospital with highest outstanding balances
select
county,
hospital_name,
sum(outstanding_balance) as payment_gap
from vw_patient_reporting vpr 
group by  county,hospital_name
order by payment_gap desc;

--Unique doctors in the datasets
select
count(distinct doctor_id) as total_doctors
from vw_patient_reporting;

--Doctor that handled the most patient records
select 
doctor_id,
count(*) as patient_count
from vw_patient_reporting vpr 
group by doctor_id
order by patient_count desc
limit 2;

--Doctor that handled the most follow-up cases
select
doctor_id,
count(*) as follow_up_cases
from vw_patient_reporting vpr 
where follow_up_required = 'Yes'
group by doctor_id
order by follow_up_cases desc;

--Doctor that managed the highest treatment cost
select
doctor_id,
sum(treatment_cost) as total_treatment_cost
from vw_patient_reporting vpr
group by doctor_id
order by total_treatment_cost desc;

--Doctor that handled the most long-staying patients
select
doctor_id,
count(*) as long_stay_patients
from vw_patient_reporting vpr
where length_of_stay > 7
group by doctor_id
order by long_stay_patients desc;

--Doctor that treated patient from the highest number of disease categories
select
doctor_id,
count(distinct disease) as disease_categories
from vw_patient_reporting vpr
group by doctor_id
order by disease_categories desc;

--Doctor that worked across the highest number of hospitals
select
doctor_id,
count(distinct hospital_name) as hospitals_served
from vw_patient_reporting vpr 
group by doctor_id 
order by hospitals_served desc;

--Doctor that appear to have unusually high workloads
with doctor_summary as (
    select
        doctor_id,
        count(*) as patient_count
    from vw_patient_reporting
    group by doctor_id
)
select *
from doctor_summary
where patient_count >
(
    select avg(patient_count)
    from doctor_summary
)
order by patient_count desc;

--Doctors that handled fewer patients than average
with doctor_summary as (
    select
        doctor_id,
        count(*) as patient_count
    from vw_patient_reporting
    group by doctor_id
)
select *
from doctor_summary
where patient_count <
(
    select avg(patient_count)
    from doctor_summary
)
order by patient_count;

--workload summary by doctor
select 
doctor_id,
count(*) as patient_count,
sum(treatment_cost) as total_cost,
avg(length_of_stay) as average_length_of_stay,
sum(outstanding_balance) as outstanding_balance
from vw_patient_reporting vpr 
group by doctor_id
order by patient_count desc;


--Cost reconciliation analysis
--Total treatment cost
select
sum(treatment_cost) as total_treatment_cost
from vw_patient_reporting;

--totla mobile money payments
select
sum(mobile_money_payment) as total_mobile_money_payment
from vw_patient_reporting;

--Overall payment gap
select
sum(outstanding_balance) as total_payment_gap
from vw_patient_reporting;

--Hospitals with the largets payment gaps
select
hospital_name,
sum(outstanding_balance) as payment_gap
from vw_patient_reporting
group by hospital_name
order by payment_gap desc;

--counties with the largest payment gaps
select
county,
sum(outstanding_balance) as payment_gap
from vw_patient_reporting
group by county
order by payment_gap desc;

--Disease categories contributing most to unpaid balances
select
disease,
sum(outstanding_balance) as payment_gap
from vw_patient_reporting
group by disease
order by payment_gap desc;

--Patients with no recorded mobile money payment
select
patient_id,
hospital_name,
treatment_cost
from vw_patient_reporting
where mobile_money_payment is null
or mobile_money_payment = 0;

--Records requiring finance review
select
patient_id,
hospital_name,
treatment_cost,
mobile_money_payment,
outstanding_balance
from vw_patient_reporting
where mobile_money_payment > treatment_cost
or outstanding_balance > 50000;

--Payment reconciliation summary
select
hospital_name,
sum(treatment_cost) as total_treatment_cost,
sum(mobile_money_payment) as total_payments,
sum(outstanding_balance) as total_outstanding_balance
from vw_patient_reporting
group by hospital_name
order by total_outstanding_balance desc;

--SQL Window functions
--Rank hospitals by patient count
select
hospital_name,
count(*) as patient_visits,
rank() over(order by count(*) desc) as hospital_rank
from vw_patient_reporting
group by hospital_name
order by hospital_rank;

--Rank hospitals by total treament cost
select
hospital_name,
sum(treatment_cost) as total_treatment_cost,
rank() over(order by sum(treatment_cost) desc) as cost_rank
from vw_patient_reporting
group by hospital_name
order by cost_rank;

--Rank hospitals by outstanding balance
select
hospital_name,
sum(outstanding_balance) as outstanding_balance,
rank() over (order by sum(outstanding_balance)desc) as balance_rank
from vw_patient_reporting vpr
group by hospital_name
order by balance_rank;

--Rank counties by total treatment cost
select
county,
sum(treatment_cost) as total_treatment_costs,
rank() over(order by sum(treatment_cost) desc) as count_rank
from vw_patient_reporting vpr 
group by county 
order by count_rank;

--Rank counties by payment gap
select
    county,
    sum(outstanding_balance) as payment_gap,
    rank() over(order by sum(outstanding_balance) desc) as county_rank
from vw_patient_reporting
group by county
order by county_rank;

--Rank doctors by workload
select
    doctor_id,
    count(*) as patient_count,
    rank() over(order by count(*) desc) as doctor_rank
from vw_patient_reporting
group by doctor_id
order by doctor_rank;

--Rank diseases by follow_up cases
select
    disease,
    count(*) as follow_up_cases,
    rank() over(order by count(*) desc) as disease_rank
from vw_patient_reporting
where follow_up_required = 'Yes'
group by disease
order by disease_rank;

--Rank county hospital according to pateint volume
select
    county,
    hospital_name,
    count(*) as patient_visits,
    rank() over(order by count(*) desc) as combination_rank
from vw_patient_reporting
group by county, hospital_name
order by combination_rank;

--Identify top three hospitals in each county
with hospital_rank as (
select
county,
hospital_name,
count(*) as patient_visits,
dense_rank() over(
     partition by county
     order by count(*) desc
    ) as hospital_rank
from vw_patient_reporting
group by county, hospital_name
)
select *
from hospital_rank
where hospital_rank <= 3
order by county, hospital_rank;

--Identify top 3 diseases in each hospital
with disease_rank as (
select
hospital_name,
disease,
count(*) as total_cases,
dense_rank() over(
	partition by hospital_name
	order by count(*)desc
) as disease_rank
from vw_patient_reporting
group by hospital_name, disease
)
select *
from disease_rank
where disease_rank <=3
order by hospital_name, disease_rank;


--create opital reporting view
create or replace view vw_hospital_summary as
select
hospital_name,
county,
count(*) as patient_visits,
sum(treatment_cost) as total_treatment_cost,
sum(outstanding_balance) as payment_gap,
avg(length_of_stay) as average_length_of_stay
from vw_patient_reporting
group by hospital_name, county;


--create county reporting view
create or replace view vw_county_summary as
select
county,
count(*) as patient_visits,
count(distinct hospital_name) as hospitals,
sum(treatment_cost) as total_treatment_cost,
sum(outstanding_balance) as payment_gap
from vw_patient_reporting
group by county;

--Create doctor workload view
create or replace view vw_doctor_summary as
select
doctor_id,
count(*) as patient_count,
sum(treatment_cost) as total_treatment_cost,
avg(length_of_stay) as average_length_of_stay,
count(case when follow_up_required='Yes' then 1 end) as follow_up_cases
from vw_patient_reporting
group by doctor_id;


--create payment reconciliation view
create or replace view vw_payment_summary as
select
hospital_name,
sum(treatment_cost) as treatment_cost,
sum(mobile_money_payment) as payments_received,
sum(outstanding_balance) as outstanding_balance
from vw_patient_reporting
group by hospital_name;

--create follow-up reporting view
create or replace view vw_follow_up_summary as
select
doctor_id,
hospital_name,
disease,
count(*) as follow_up_cases
from vw_patient_reporting
where follow_up_required='Yes'
group by doctor_id, hospital_name, disease;

