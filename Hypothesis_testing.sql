--Worst performing Products

select 
	product_id,
	brand,
	category_code,
	price,
	Count(Distinct user_id) as total_viewers
from
	user_behavior
where 
	product_id in ('1002541','1002522','1002494','1002266','1002497','1002099','1002415','1002103','1002102','1002550')
	and event_type = 'view'
Group by 
	product_id,
	brand,
	category_code,
	price;


select 
	brand,
	category_code,
	AVG(price) as avg_price,
	Count(Distinct product_id)as total_products
from 
	user_behavior
where 
	product_id in ('1002541','1002522','1002494','1002266','1002497','1002099','1002415','1002103','1002102','1002550')
	and event_type = 'view'
Group by 
	category_code,
	brand
order by 
	total_products DESC;
	
--New Hypothesis: The problem is user specific and not product specific

WITH user_first_event AS (
    SELECT
        user_id,
        MIN(event_time) AS first_event_date
    FROM
        user_behavior
    GROUP BY
        user_id
)
SELECT
    user_id,
    first_event_date
FROM
    user_first_event
ORDER BY
    first_event_date ASC;

--Cohort analysis
WITH user_first_event AS (
    SELECT
        user_id,
        MIN(event_time) AS first_event_date
    FROM
        user_behavior
    GROUP BY
        user_id
),
cohort_data AS (
    SELECT
        DATE_TRUNC('month', u.first_event_date) AS cohort_month,
        COUNT(DISTINCT u.user_id) AS total_users,
        COUNT(DISTINCT CASE WHEN ub.event_type = 'purchase' THEN ub.user_id END) AS purchasers
    FROM
        user_first_event u
    JOIN
        user_behavior ub ON u.user_id = ub.user_id
    GROUP BY
        cohort_month
    ORDER BY
        cohort_month ASC
)
SELECT
    cohort_month,
    total_users,
    purchasers,
    CAST(purchasers AS DECIMAL) * 100 / total_users AS conversion_rate
FROM
    cohort_data;


-- New Hypothesis: Success is tied to a change in product or brand
with monthly_conversions as (
select 
	DATE_TRUNC('month', event_time) as Sales_month,
	brand,
	Count(Distinct case when event_type = 'view' then user_id END) as unique_viewers,
	Count(Distinct case when event_type = 'cart' then user_id END) as unique_cart_adds
from 
	user_behavior
where 
	brand is not null
group by 
	sales_month,
	brand
)
select 
	sales_month 
	brand,
	unique_viewers,
	unique_cart_adds,
	CAST(unique_cart_adds as decimal) * 100 / unique_viewers as view_to_cart_rate
From 
	monthly_conversions
Where 
	unique_viewers > 500
order by 
	sales_month DESC,
	view_to_cart_rate DESC
limit 20;

--Sales Month(OCT)

SELECT
    DATE_TRUNC('month', event_time) AS sales_month,
    brand,
    COUNT(*)
FROM
    user_behavior
WHERE brand IS NOT NULL
GROUP BY
    sales_month,
    brand
ORDER BY
    sales_month,
    COUNT(*) DESC
LIMIT 10;

--Sales month(NOV)
SELECT
    DATE_TRUNC('month', event_time) AS sales_month,
    brand,
    COUNT(*) AS total_events
FROM
    user_behavior
WHERE
    brand IS NOT NULL
GROUP BY
    sales_month,
    brand
ORDER BY
    sales_month DESC,
    total_events DESC
LIMIT 10;