  -- create test database

create database testing;   

 -- create test tablespace

create table testing.test(
 fruit varchar(20), veggie varchar(20)
 );
 
-- populate tablespace

 insert into testing.test (fruit, veggie) values ("apple", "salad");
