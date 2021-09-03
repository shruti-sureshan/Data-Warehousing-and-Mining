/*
The college wants to record marks for the courses completed by students using the dimensions :
Course, Student, Time and a measure Aggregate Marks. Demonstrate following OLAP operations
: Slice, Dice, Roll up, Cube and Rank.
*/

-- Creating Tables
create table course_dim(course_id int primary key, name varchar(50), duration int);
create table student_dim(student_id int primary key, name varchar(50), roll_no int);
create table time_dim(time_id int primary key, year int, month int, day int);
create table college_fact_table(
    course_id int,
    student_id int,
    time_id int,
    marks int,
    primary key(course_id, student_id, time_id),
    foreign key(course_id) references course_dim(course_id),
    foreign key(student_id) references student_dim(student_id),
    foreign key(time_id) references time_dim(time_id)
);

-- Inserting Data
insert into course_dim values(1, 'Machine Learning', 6);
insert into course_dim values(2, 'Big Data', 6);
insert into course_dim values(3, 'Deep Learning', 6);
insert into course_dim values(4, 'Python', 3);
insert into course_dim values(5, 'AI', 9);

insert into student_dim values(1, 'Bhushan', 7);
insert into student_dim values(2, 'Rishabh', 5);
insert into student_dim values(3, 'Vinay', 17);
insert into student_dim values(4, 'Mandar', 1);
insert into student_dim values(5, 'Sunny', 10);

insert into time_dim values(1, 2019, 4, 18);
insert into time_dim values(2, 2019, 4, 19);
insert into time_dim values(3, 2019, 4, 20);
insert into time_dim values(4, 2019, 5, 2);
insert into time_dim values(5, 2019, 5, 5);

insert into college_fact_table values(1, 1, 1, 60);
insert into college_fact_table values(2, 2, 2, 70);
insert into college_fact_table values(3, 3, 3, 65);
insert into college_fact_table values(4, 4, 4, 80);
insert into college_fact_table values(5, 5, 5, 90);
insert into college_fact_table values(1, 4, 2, 50);
insert into college_fact_table values(2, 3, 4, 70);
insert into college_fact_table values(4, 5, 1, 85);
insert into college_fact_table values(3, 4, 5, 70);

-- 1. Cube Operation
select time_id, course_id, student_id, avg(marks)  
from college_fact_table
group by cube(time_id, course_id, student_id);

-- 2. Rollup Operation
select student_id, sum(marks)  
from college_fact_table
group by rollup(student_id);

-- 3. Slice Operation
select time_id, course_id, student_id, avg(marks)  
from college_fact_table
where course_id = 1
group by cube(time_id, course_id, student_id);

-- 4. Dice Operation
select time_id, course_id, student_id, avg(marks)  
from college_fact_table
where course_id = 1
    and student_id = 1
group by cube(time_id, course_id, student_id);

-- 5. Rank Operation
select student_id, course_id, marks,
       rank() over(order by marks) as rank
from college_fact_table order by rank asc;
