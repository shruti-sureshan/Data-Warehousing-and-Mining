/* PS:
Consider a data warehouse for a Railway reservation where there are three dimensions:Train,
Passenger, Time. Fact: Revenue. Demonstrate following OLAP operations : Slice, Dice, Roll up,
Cube and Rank.
*/


drop table railway_fact_table;
drop table train_dim;
drop table passenger_dim;
drop table time_dim;

-- DDL
create table train_dim(t_number int primary key not null, name varchar(10));
create table passenger_dim(pnr int primary key not null, name varchar(10));
create table time_dim(time_id int primary key not null, year int, month int, day int);

create table railway_fact_table(
    t_number int, 
    pnr int, 
    time_id int,
    ticket_cost int,
    primary key(t_number, pnr, time_id),
    foreign key(t_number) references train_dim(t_number),
    foreign key(pnr) references passenger_dim(pnr),
    foreign key(time_id) references time_dim(time_id)
);


-- POPULATING TABLES
insert into train_dim values(12038, 'shatabdi');
insert into train_dim values(12953, 'aug kranti');
insert into train_dim values(12437, 'rajdhani');

insert into passenger_dim values(8541654886, 'rishabh');
insert into passenger_dim values(9562147036, 'vinay');
insert into passenger_dim values(854123697, 'bhushan');
insert into passenger_dim values(5424963145, 'mandar');
insert into passenger_dim values(895621437, 'sunny');

insert into time_dim values(1, 2019, 3, 12);
insert into time_dim values(2, 2019, 3, 13);
insert into time_dim values(3, 2019, 4, 14);
insert into time_dim values(4, 2019, 4, 16);

insert into railway_fact_table values(12038, 8541654886, 1, 3000);
insert into railway_fact_table values(12437, 8541654886, 3, 5000);
insert into railway_fact_table values(12953, 8541654886, 4, 4000);
insert into railway_fact_table values(12437, 8541654886, 2, 5000);

insert into railway_fact_table values(12038, 9562147036, 1, 3000);
insert into railway_fact_table values(12437, 9562147036, 4, 5000);

insert into railway_fact_table values(12953, 854123697, 1, 4000);
insert into railway_fact_table values(12437, 854123697, 2, 5000);
insert into railway_fact_table values(12038, 854123697, 4, 3000);

insert into railway_fact_table values(12437, 5424963145, 2, 5000);

insert into railway_fact_table values(12953, 895621437, 1, 4000);
insert into railway_fact_table values(12437, 895621437, 3, 5000);




-- QUERIES

-- SLICE
SELECT ft.pnr, avg(ticket_cost)
FROM railway_fact_table ft, time_dim td
WHERE month=3
GROUP BY ft.pnr;

-- SLICE WITH INTERPRETABLE OUTPUT:
select pass.name, pass.pnr, cost 
FROM passenger_dim pass, (SELECT ft.pnr as ftpnr, avg(ticket_cost) as cost
                           FROM railway_fact_table ft, time_dim td
                           WHERE month=3
                           GROUP BY ft.pnr
                         )
WHERE pass.pnr = ftpnr;


-- DICE
-- finding the days on which a particular passenger travelled by given train.
SELECT time_id
FROM railway_fact_table
WHERE t_number=12437 and pnr=8541654886;

-- output interpretable query:
SELECT year, month, day
FROM time_dim td,
    (SELECT time_id as t_id
    FROM railway_fact_table
    WHERE t_number=12437 and pnr=8541654886)
WHERE t_id = td.time_id;


-- ROLLUP
SELECT year, month, day, avg(ticket_cost)
FROM time_dim, railway_fact_table ft
GROUP BY pnr, ROLLUP(year, month, day);


-- CUBE
SELECT t_number, time_id, avg(ticket_cost)
FROM railway_fact_table
GROUP BY cube(t_number, time_id);


-- RANK
-- shows the rank of the cost of tickets for each day.
SELECT ticket_cost, time_id, RANK() OVER (
           PARTITION BY time_id
           ORDER BY ticket_cost
       ) as rank
FROM railway_fact_table;
