--Diagnostic Analysis
--1) Product and category
with product_funnel as(
select 
	product_id,
	Count(Distinct Case when event_type = 'view' then user_id end) as unique_viewers,
	Count(Distinct Case when event_type = 'cart' then user_id end) as unique_cart_add
from 
	user_behavior
group by 
	product_id
)	
select 
	product_id,
	unique_viewers,
	unique_cart_add,
	Cast(unique_cart_add as decimal) * 100/ unique_viewers as view_to_cart_rate
from 
	product_funnel
where 
	unique_viewers > 100
order by 
 	view_to_cart_rate ASC -- or ASC for underperforming products
limit 10;
	
--2) Brand Funnel
With brand_funnel as (
select 	
	brand,
	Count(Distinct Case when event_type = 'view' then user_id END) as unique_viewers,
	Count(Distinct Case when event_type = 'Cart' then user_id END) as unique_cart_adds
from
	user_behavior
where 
	brand is not null
group by 
	brand
)
select 
	brand,
	unique_viewers,
	unique_cart_adds,
	Cast(unique_cart_adds as Decimal) *100 / unique_viewers as view_to_cart_rate
from 
	brand_funnel
where
	unique_viewers > 100
order by 
	view_to_cart_rate ASC
limit 10;

--3) User Duration
with session_data as(
select 
	user_session,
	Min(event_time) as session_start,
	Max(event_time) as session_end,
	Max(Case when event_type = 'cart' then 1 else 0 END) As in_cart
from 
	user_behavior
group by 
	user_session
)
select 
	in_cart,
	AVG(Extract(Epoch from (session_end - session_start))) as avg_time_spent,
	Count(*) as total_sessions
from
	session_data
group by 
	in_cart;