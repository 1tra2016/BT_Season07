create schema bt_season07_gioi2;
set search_path to bt_season07_gioi2;

create table customer (
                          customer_id serial primary key,
                          full_name varchar(100),
                          region varchar(50)
);

create table orders (
                        order_id serial primary key,
                        customer_id int references customer(customer_id),
                        total_amount decimal(10,2),
                        order_date date,
                        status varchar(20)
);

create table product (
                         product_id serial primary key,
                         name varchar(100),
                         price decimal(10,2),
                         category varchar(50)
);

create table order_detail (
                              order_id int references orders(order_id),
                              product_id int references product(product_id),
                              quantity int
);

-- Thêm khách hàng
insert into customer (full_name, region) values
                                             ('Nguyễn Văn A', 'Hà Nội'),
                                             ('Trần Thị B', 'Đà Nẵng'),
                                             ('Lê Văn C', 'TP.HCM');

-- Thêm sản phẩm
insert into product (name, price, category) values
                                                ('Laptop Dell', 18000000.00, 'Electronics'),
                                                ('Chuột Logitech', 450000.00, 'Accessories'),
                                                ('Bàn phím cơ', 1200000.00, 'Accessories');

-- Thêm đơn hàng
insert into orders (customer_id, total_amount, order_date, status) values
                                                                       (1, 18450000.00, '2025-11-15', 'Completed'),
                                                                       (2, 1200000.00, '2025-11-16', 'Pending');

-- Thêm chi tiết đơn hàng
insert into order_detail (order_id, product_id, quantity) values
                                                              (1, 1, 1),  -- Laptop Dell
                                                              (1, 2, 1),  -- Chuột Logitech
                                                              (2, 3, 1);  -- Bàn phím cơ

create view v_revenue_by_region as
select c.region, sum(o.total_amount) as total_revenue
from customer c join orders o on c.customer_id = o.customer_id
group by c.region;

select * from v_revenue_by_region order by total_revenue desc limit(3);

--Materialized view không thể cập nhật, chỉ tạo view thôi
create view v_order as
select *
from orders
with check option;
select * from v_order;
update v_order set status = 'Completed' where order_id = 2;

create view v_revenue_above_avg as
select *
from v_revenue_by_region
where total_revenue > (
    select avg(total_revenue)
    from v_revenue_by_region
);
select * from v_revenue_above_avg;