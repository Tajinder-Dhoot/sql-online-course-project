create schema mavenbearbuilders;
use mavenbearbuilders;

create table order_items (
	order_item_id bigint,
    created_at datetime,
    order_id bigint,
    price_usd decimal(6,2),
    cogs_used decimal(6,2),
    website_session_id bigint,
    primary key (order_item_id)
);

select * from order_items;
select count(*) from order_items;

create table order_items_refunds (
	order_item_refund_id bigint,
    created_at datetime,
	order_item_id bigint,
	order_id bigint,
	refund_amount_usd decimal(6,2),
    primary key (order_item_refund_id),
    foreign key (order_item_id) references order_items (order_item_id)
);
select * from order_items_refunds;
select count(*) from order_items_refunds;

#drop table order_items_refunds;
delete from order_items_refunds where order_item_refund_id >= 6;

select count(*) from order_items;
select count(*) from order_items_refunds;

create table products (
	product_id bigint,
    created_at datetime,
    product_name varchar(100),
    primary key (product_id)
);

drop table  products;

insert into products values 
	(1, '2012-03-09 09:00:00', 'The Original Mr. Fuzzy'),
    (2, '2013-01-06 13:00:00', 'The Forever Love Bear')
;

select * from products;
truncate products;

alter table order_items add column product_id bigint;
update order_items set product_id = 1 where order_item_id > 0;
select * from order_items;

select * from order_items where order_item_id = 1110;
alter table order_items change column cogs_used cogs_usd decimal(6,2);

alter table order_items
add constraint order_items_product_id 
foreign key (product_id) references products (product_id);

create table orders (
	order_id bigint,
    created_at datetime,
    website_session_id bigint,
    primary_product_id bigint,
    items_purchased bigint,
    price_usd decimal(6,2),
    cogs_usd decimal(6,2),
    primary key(order_id)
);

select * from orders;
select * from order_items;

insert into orders
select 
	order_id,
    min(created_at) as created_at,
    min(website_session_id) as website_session_id,
    sum(case
		when is_primary_item = 1 then is_primary_item
        else null
        end) as primary_product_id,
    count(order_item_id) as items_purchased,
    sum(price_usd) as price_usd,
    sum(cogs_usd) as cogs_usd
from order_items
group by 1 #group by column 1 of table orders
order by 1 #order by column 1 of table orders
;

truncate orders;

#------------------------------------------------------ trigger ---------------------------------------------------------
create trigger insert_new_orders
after insert
on order_items
for each row
replace into orders
select 
	order_id,
    min(created_at) as created_at,
    min(website_session_id) as website_session_id,
    sum(case
		when is_primary_item = 1 then is_primary_item
        else null
        end) as primary_product_id,
    count(order_item_id) as items_purchased,
    sum(price_usd) as price_usd,
    sum(cogs_usd) as cogs_usd
from order_items
where order_id = new.order_id
group by 1
order by 1
;
select max(order_id) as max_order_id from order_items;
select count(*) as total_orders from orders;

create table website_sessions (
	website_session_id bigint,
    created_at datetime,
	user_id bigint,
	is_repeat_session int,
	utm_source varchar(100),
	utm_campaign varchar(100),
	utm_content varchar(100),
	device_type varchar(100),
	http_referer varchar(100)
);

select * from website_sessions;
select count(*) as total_records from website_sessions where user_id = 152826;

#------------------------------------------------ view------------------------------------------
create view monthly_sessions as 
select 
	year(created_at) as year,
    month(created_at) as month,
	utm_source as utm_source, 
	utm_campaign,
    Count(website_session_id) as no_of_sessions
from website_sessions
group by 1,2,3,4
;

drop view monthly_sessions;
select * from monthly_sessions;

use mavenbearbuilders;
select * from order_items;
select * from products;
select * from orders;
select count(order_id) from orders;
select 
	count(order_id) as total_orders,
	sum(price_usd) as total_revenue
from orders 
where created_at between '2013-11-01' and '2013-12-31';
select * from monthly_sessions;
select * from order_items_refunds;
select * from website_sessions;

select * from website_sessions where user_id = 154618;
drop procedure orders_between_date;

# ------------------------------------------------ procedures --------------------------------------------------
delimiter //
create procedure orders_between_date
(in start_date date, in end_date date)
begin
select 
	count(order_id) as total_orders,
	sum(price_usd) as  total_revenue
from orders 
where created_at between start_date and end_date;
end //
delimiter ;

call orders_between_date('2013-12-01', '2013-12-31');

create table website_pageviews (
	website_pageview_id bigint,
    created_at datetime,
	website_session_id bigint,
	pageview_url varchar(100),
    primary key (website_pageview_id) 
) ;

create table users (
	user_id bigint,
    created_at datetime,
    first_name varchar(50),
    last_name varchar(50),
    primary key (user_id)
) ;

create table support_members (
	support_member_id bigint,
    created_at datetime,
    first_name varchar(50),
    last_name varchar(50),
    primary key (support_member_id)
) ;

create table chat_sessions (
	chat_session_id bigint,
    created_at datetime,
	user_id bigint,
	support_member_id bigint,
    website_session_id bigint,
    primary key (chat_session_id)
) ;

create table chat_messages (
	chat_message_id bigint,
    created_at datetime,
    chat_session_id bigint,
    user_id bigint,
	support_member_id bigint,
    message_text varchar(200),
    primary key (chat_message_id)
) ;

create view monthly_orders_and_revenue as (
	select
		year(created_at) as year,
        month(created_at) as month,
		count(order_id) as orders,
		sum(price_usd) as revenue
	from orders
    group by 1, 2
    order by 1, 2
);

select * from monthly_orders_and_revenue;

create view monthly_website_traffic as (
	select
		year(created_at) as year,
        month(created_at) as month,
		count(website_session_id) as traffic
	from website_sessions
    group by 1, 2
    order by 1, 2
);

select * from monthly_website_traffic;

select * from website_sessions;