/*
For a super market chain, consider the following dimensions, namely product_dim, store, time_dim,
promotion_dim. The schema contains a central fact table with sales facts Design star schema for this
application. Also show OLAP operations.
*/


-- Create Tables
create table product_dim(product_id int primary key, name varchar(50), cost int);
create table store_dim(store_id int primary key, province varchar(50), country varchar(50));
create table promotion_dim(promo_id int primary key, province varchar(50), country varchar(50), cost int);
create table time_dim(time_id int primary key, year int, month int, day int);

create table store_fact_table(
    product_id int, 
    store_id int, 
    promo_id int, 
    time_id int, 
    sales int,
    foreign key(product_id) references product_dim(product_id),
    foreign key(store_id) references store_dim(store_id),
    foreign key(promo_id) references promotion_dim(promo_id),
    foreign key(time_id) references time_dim(time_id),
    primary key(product_id, store_id, promo_id, time_id)
);


-- Inserting data into tables
insert into product_dim values(1, 'Red Gear Gaming Mouse', 12150);
insert into product_dim values(2, 'Razer BlackWidow Elite', 12800);
insert into product_dim values(3, 'Acer Predator X21', 600000);
insert into product_dim values(4, 'Asus ROG Centurion 7.1.', 40000);

insert into time_dim values(1, 2019, 4, 18);
insert into time_dim values(2, 2019, 4, 19);
insert into time_dim values(3, 2019, 4, 20);
insert into time_dim values(4, 2019, 5, 2);
insert into time_dim values(5, 2019, 5, 5);

insert into store_dim values(1, 'NYC', 'USA');
insert into store_dim values(2, 'Mumbai', 'India');
insert into store_dim values(3, 'Chennai', 'India');

insert into promotion_dim values(1, 'NYC', 'USA', 5000);
insert into promotion_dim values(2, 'Mumbai', 'India', 4000);
insert into promotion_dim values(3, 'Chennai', 'India', 9000);

insert into store_fact_table values(1, 1, 1, 1, 9000);
insert into store_fact_table values(2, 2, 1, 3, 8000);
insert into store_fact_table values(1, 3, 1, 4, 10500);
insert into store_fact_table values(2, 3, 1, 5, 15000);
insert into store_fact_table values(1, 2, 2, 3, 7000);
insert into store_fact_table values(1, 3, 2, 4, 8000);
insert into store_fact_table values(2, 1, 2, 3, 10000);
insert into store_fact_table values(1, 1, 3, 2, 7000);
insert into store_fact_table values(1, 2, 3, 4, 50000);
insert into store_fact_table values(2, 1, 2, 5, 20000);
insert into store_fact_table values(1, 3, 1, 2, 9500);


-- 1. Cube Operation
select product_id, store_id, promo_id, avg(sales)
from store_fact_table
group by cube(product_id, store_id, promo_id);

-- 2. Slice Operation 
select product_id, store_id, promo_id, avg(sales)
from store_fact_table
where product_id = 1
group by cube(product_id, store_id, promo_id);

-- 3. Dice Operation
select product_id, store_id, promo_id, avg(sales)
from store_fact_table
where product_id = 1
    and store_id = 1
group by cube(product_id, store_id, promo_id);

-- 4. Rollup Operation
select product_id, sum(sales)
from store_fact_table
group by rollup(product_id);

-- 5. Rank Operation
select product_id, store_id, sales,
       rank() over(order by sales) as rank,
       dense_rank() over(order by sales) as dense_rank
from store_fact_table order by rank asc;
