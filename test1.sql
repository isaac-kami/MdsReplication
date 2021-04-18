
-- create a test database


create database testexample;


-- create a tablespace for the test database


create table testexample.exampletable (
        name varchar(20), firstname varchar(20)
);


-- populate tablespace


insert into testexample.exampletable (name, firstname) values ('Foster', 'Zack');
