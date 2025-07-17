select * from hotel_revenue_data;

-- cleaning 

-- create table to work on 
create table hotel_rev_w
like hotel_revenue_data;

insert into hotel_rev_w
select * from hotel_revenue_data;

select * from hotel_rev_w;

-- cheak doublcates 

SELECT ï»¿booking_id, COUNT(*)
FROM hotel_rev_w
GROUP BY ï»¿booking_id
HAVING COUNT(*) > 1;
-- no doublecates 

-- search null values

SELECT *
FROM hotel_rev_w
WHERE ï»¿booking_id IS NULL
   OR hotel IS NULL
   OR check_in_date IS NULL
   OR nights IS NULL
   OR guests IS NULL
   OR is_canceled IS NULL
   OR customer_rating IS NULL
   OR adr IS NULL
   OR room_type IS NULL
   OR country IS NULL
   OR complaints IS NULL
   OR customer_type IS NULL
   OR channel IS NULL;

--  no nulls 
-- check table data types 
select * from hotel_rev_w;
show columns from hotel_rev_w;

-- problem in date coulmn
select 
str_to_date(check_in_date, '%Y-%m-%d') as cheak_in_date 
from hotel_rev_w;

ALTER TABLE hotel_rev_w
ADD COLUMN check_in_date1 DATE;


UPDATE hotel_rev_w
SET check_in_date1 = STR_TO_DATE(LEFT(check_in_date, 10), '%Y-%m-%d')
WHERE check_in_date IS NOT NULL;

-- delete and rename coumns 
alter table hotel_rev_w
drop column check_in_date;

alter table hotel_rev_w
change check_in_date1 check_in_date date;

alter table hotel_rev_w
change ï»¿booking_id booking_id int;

-- Inquiries

-- total booking 
select count(*)as total_booking
from hotel_rev_w;
-- 5000

-- cancellation percentage

SELECT 
    SUM(is_canceled) AS total_canceled,
    COUNT(*) AS total_reservations,
    (SUM(is_canceled) * 100.0 / COUNT(*)) AS cancellation_percentage
FROM hotel_rev_w;

-- total incoume for complete booking per hotel

select hotel ,sum(adr * nights ) as sum_t
from hotel_rev_w
where is_canceled = 0
group by hotel ;

-- avrage rate per hotel

select hotel , avg(customer_rating) as avg_rate
from hotel_rev_w
group by hotel;

-- how many complaints per counry 

select country , sum(case when complaints then 1 else 0 end) as how_many_complaints
from hotel_rev_w 
group by country
;

-- top 5 countrys in complaints

select country , sum(case when complaints then 1 else 0 end) as how_many_complaints
from hotel_rev_w 
group by country 
order by how_many_complaints desc
limit 5
;

-- monthely income
with income_per_month as 
(
select hotel , nights , adr , is_canceled, check_in_date , MONTH(check_in_date) AS month_number
from hotel_rev_w
)
SELECT month_number , SUM(adr * nights) AS total_income
FROM income_per_month
WHERE is_canceled = 0
group by month_number 
order by month_number 
;

-- canceled per every room type 

SELECT 
    room_type,
    SUM(is_canceled) AS canceled,
    (SUM(is_canceled) * 100 / COUNT(*)) AS cancellation_percentage
FROM hotel_rev_w
GROUP BY room_type;



SELECT 
  MONTH(a.check_in_date) AS month_number,
  a.country AS country1,
  b.country AS country2,
  COUNT(*) AS booking_pairs
FROM hotel_rev_w a
JOIN hotel_rev_w b 
  ON MONTH(a.check_in_date) = MONTH(b.check_in_date)
  AND a.country < b.country
WHERE a.is_canceled = 0 AND b.is_canceled = 0
GROUP BY 
  MONTH(a.check_in_date),
  a.country,
  b.country
ORDER BY 
  month_number, booking_pairs DESC;




select * from hotel_rev_w;




