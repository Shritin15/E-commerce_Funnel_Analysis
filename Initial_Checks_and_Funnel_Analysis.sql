select Count(*)
from 
	user_behavior;
--------------------------------------------------------
select * 
from 
	user_behavior
limit 10;
--------------------------------------------------------
select
	MIN(event_time),
	Max(event_time)
from
	user_behavior;
----------------------------------------------------------
select 
	event_type,
	count(*)
from
	user_behavior
Group by 
	event_type;
------------------------------------------------------------
--Funnel Metrics
select 
	Count(Distinct Case when event_type = 'view' then user_id END) as unique_viewers,
	count(Distinct case when event_type = 'cart' then user_id END) as unique_add_to_cart,
	Count(Distinct case when event_type = 'purchase' then user_id END) as unique_purchase
from
	user_behavior;

--Conversion rates
select 
	Cast(Count(Distinct case when event_type = 'cart' then user_id end) as Decimal) * 100/ 
	Count(Distinct case when event_type = 'view' then user_id END) as view_to_cart_rate,
	Cast(Count(distinct case when event_type = 'purchase' then user_id END) as Decimal) * 100/
	Count(Distinct case when event_type = 'cart' then user_id END) as cart_to_purchase_rate,
	Cast(Count(Distinct case when event_type = 'purchase' then user_id END ) as Decimal ) * 100/
	Count(Distinct case when event_type = 'view' then user_id END) as overall_conversion_rate
from
	user_behavior;

------------------------------------------------------------------------------------------------------










