-- Hospital management

-- Creating Tables:
create table doctor_dim(doctor_id int primary key, dname varchar(50), dphone varchar(10), specialization varchar(20));
create table patient_dim(patient_id int primary key, pname varchar(50), pphone varchar(10), pgender char(1));
create table time_dim(time_id int primary key, year int, month int, day int);
create table hospital_fact_table(
    doctor_id int, 
    patient_id int, 
    time_id int, 
    charges int,
    primary key(doctor_id, patient_id, time_id),
    foreign key(doctor_id) references doctor_dim(doctor_id),
    foreign key(patient_id) references patient_dim(patient_id),
    foreign key(time_id) references time_dim(time_id)
);

-- Inserting Data:
insert into patient_dim values(1, 'mandar acharekar', '2309473956', 'M');
insert into patient_dim values(2, 'bhushan borole', '2309473956', 'M');
insert into patient_dim values(3, 'sunny d''souza', '2309476357', 'M');

insert into doctor_dim values(1, 'rishabh bhatnagar', '8888989238', 'radiologist');
insert into doctor_dim values(2, 'vinay deshmukh', '8888983238', 'cardiologist');

insert into time values(1, 2019, 4, 18);
insert into time values(2, 2019, 4, 19);
insert into time values(3, 2019, 4, 20);
insert into time values(4, 2019, 5, 2);
insert into time values(5, 2019, 5, 5);

insert into hospital_fact_table values(1, 1, 1, 20000);
insert into hospital_fact_table values(2, 2, 1, 2000);
insert into hospital_fact_table values(1, 3, 1, 5000);
insert into hospital_fact_table values(2, 3, 1, 7000);
insert into hospital_fact_table values(1, 2, 2, 8000);
insert into hospital_fact_table values(1, 3, 2, 3000);
insert into hospital_fact_table values(2, 1, 2, 2000);
insert into hospital_fact_table values(1, 1, 3, 7000);
insert into hospital_fact_table values(1, 2, 3, 14000);
insert into hospital_fact_table values(2, 1, 4, 4000);
insert into hospital_fact_table values(1, 3, 5, 6000);


-- 1. CUBE operation:
select time_id, doctor_id, patient_id, avg(charges)  
from hospital_fact_table
group by cube(time_id, doctor_id, patient_id);

-- 2. SLICE:
select doctor_id, patient_id, avg(charges)  
from hospital_fact_table
where time_id=1
group by cube(time_id, doctor_id, patient_id);

-- 3. DICE:  # check it once.
select doctor_id, patient_id, avg(charges)  
from hospital_fact_table
where time_id=3
  and patient_id=2
  and doctor_id=1
group by cube(time_id, doctor_id, patient_id);

-- 4. ROLLUP
select doctor_id, sum(charges)  
from hospital_fact_table
group by rollup(doctor_id);

-- 5. RANK AND DENSE RANK:
select patient_id, doctor_id, charges,
       rank() over(order by charges) as rank,
       dense_rank() over(order by charges) as dense_rank
from hospital_fact_table order by rank asc;
