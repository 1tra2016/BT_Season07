create schema bt_season07_kha2;
set search_path to bt_season07_kha2;

create table customer (
    customer_id serial primary key,
    full_name varchar(100),
    email varchar(100),
    phone varchar(15)
);

create table orders (
    order_id serial primary key,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date
);

-- Thêm khách hàng
insert into customer (full_name, email, phone) values
    ('Nguyễn Văn A', 'a.nguyen@example.com', '0901234567'),
    ('Trần Thị B', 'b.tran@example.com', '0912345678'),
    ('Lê Văn C', 'c.le@example.com', '0923456789');

-- Thêm đơn hàng
insert into orders (customer_id, total_amount, order_date) values
    (1, 250000.00, '2025-11-15'),
    (2, 175000.00, '2025-11-16'),
    (1, 320000.00, '2025-11-17');

create view v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c join orders o on c.customer_id = o.customer_id;
select * from v_order_summary;

create view v_order_edit as
select order_id, customer_id, total_amount, order_date
from orders
with check option;

update v_order_edit
set total_amount = 300000.00
where order_id = 1;
select * from v_order_edit;

create view v_monthly_sales as
select date_trunc('month', order_date) as month, sum(total_amount) as total_sales
from orders
group by date_trunc('month', order_date)
order by month;
select * from v_monthly_sales;

drop view v_monthly_sales;

--View sẽ tự động cập nhật theo bảng, còn materialized view thì cần referesh để cập nhật
--Truy vấn view sẽ chậm hơn so với materialized view