create database revision;
use revision; 

create table teammates (name_id int, name varchar(20), age bigint, address varchar(50));
insert into teammates values (1, "name1", 15, "city1");
insert into teammates values(2, "name2", 25, "city2");
insert into teammates values(3, "name2", 25, "female", "city2");

select * from teammates;
describe teammates;

# alter table--------------------------------------------------------------------
alter table teammates add column gender varchar(50);
alter table teammates add column gender varchar(50) after age;

alter table bankemployees change column branch_type branch_source varchar(50); # modifies column name and data type both
alter table teammates modify name_id bigint;
alter table teammates modify name varchar(40); # only modifies column data type
alter table bankemployees rename column branch_source to branch_origin; # only modifies column name

alter table teammates drop gender;

# update -------------------------------------------------------------------------------
update teammates set gender = "male";
update teammates set gender = "female" where name = "name2";

#delete row
delete from teammates where name_id = 2;

# delete database
drop schema revision;

#delete table
create table semo1 (name int , location varchar(20));
drop table semo1;

# to select distinct values
select distinct name from teammates;
select distinct * from teammates;

select * from teammates group by name;

#----------------------------------------------------------------------------
use world ;
select * from city;
select * from country;

select * from country where Continent = "Africa" and Population < 100000;
select * from country where (Continent = "Africa" and Population < 100000) or Region = "Caribbean";
select * from country where (Continent = "Africa" and Population < 100000) or Region = "Caribbean";

select * from country where LifeExpectancy between 73 and 75;
select * from country where LifeExpectancy in (73, 75);
select * from country where (Continent = "Africa" and Population < 100000) or LifeExpectancy between 73 and 75;

# regular expressions
select * from country where Continent like "A%" and Population < 100000;
select * from country where Continent like "_f%" and Population < 100000;

#sort -----------------------------------------------
select * from country where Population < 200000 order by Population; # ascending by default
select * from country where Population < 200000 order by Population desc;

# grouping----------------------------------------------
select count(*), Region, Population from country where Population < 200000 group by Region;
select count(*), Region, Population from country where Population < 200000 group by Region order by population desc;
select count(*) from country where Population < 200000;

# to get total GNP of every Region with population less than 200000
select count(*), Region, sum(GNP), population from country where Population < 200000 group by Region;

# to get country with max GNP from every region with population less than 200000
select count(*), Name, Region, max(GNP), population from country where population < 200000 group by Region; 

# to get avg GNP from every region and then only show entries with population less than 200000 (this is diff from above one)
select count(*), Region, avg(GNP), Population from country group by Region having Population <200000 order by Population; 

# order that should be maintained is where > group by > having > order by

# subqueries------------------------------------------------------
select * from country where Code = (select CountryCode from city where district = "Kabol");

# get Population of a country/countries whose districts are "Kabol" and "Queensland" (a way of joining tables)
select Name, Population from country where Code in (select CountryCode from city where district in ("Kabol", "Queensland"));

#-------------------------------------------------------------------------------------------
# joins
select * from city;
select * from country;
select * from countrylanguage;
select c.*, cl.* from city as c join countrylanguage as cl on c.CountryCode = cl.CountryCode;

use jointables;
select * from citizens;
select * from citizensloc;

insert into citizens values("Gurleen Singh", 22, 0, "O");
insert into citizensloc values("Sukhdeep Singh", "Sangrur");

select citizens.*, citizensloc.location from citizens join citizensloc on citizens.name = citizensloc.name;
select c.*, cl.location from citizens as c left join citizensloc as cl on c.name = cl.name;
select c.*, cl.location from citizens as c right join citizensloc as cl on c.name = cl.name;

select c.*, cl.location from citizens as c right join citizensloc as cl on c.name = cl.name group by c.age order by c.age;

#-----------------------------------------------------------------------
#String Functions
#Concat
select concat(name, age) from citizens;
select concat(name, age) from citizens where name = "Tajinder";
select c.name, cl.location, concat(c.name,cl.location) from citizens as c left join citizensloc as cl on c.name = cl.name;

#Substr
select substr(name, 5, 7) from citizens;
select substr(name, 1, 5) from citizens;
select substr(name, 1, 5) from citizens where name ="Tajinder";

#replace
select replace(name, "aji", "xyz") from citizens where name= "Tajinder";
select replace(name, "Sukh", "Nav") from citizens;
select replace(name, "Man", "Nav"), age from citizens;

#length (for string only)
select length(name), age from citizens;
select length(name) from citizens where name ="Tajinder";
select length(name), length(location) from citizensloc;

#trim---------- not supported in MySQl
#top, limit
select name from citizens limit 3;
select * from citizens limit 3;

#---------------------------------------------------------------------------
#Union and Union all
create table morecitizens1 (name varchar(20), age int, matches int, blood varchar(20));
insert into morecitizens values ('Tajinder', 26, 2, "A");
insert into morecitizens1 values ('Prabhsimran', 25, 1, "B"); 
insert into morecitizens1 values ('Surajpal', 24, 3, "B-");
insert into morecitizens1 values ('name1', 32, 2, "A-");
insert into morecitizens values ('name2', 18, 1, "A"); 
insert into morecitizens values ('name3', 19, 3, "A");

select * from morecitizens1;
select * from citizens union select * from morecitizens1;
select * from citizens union all select * from morecitizens1;

#contraints-------------------------------------------------------------
#Not Null, default, unique, primary key, foreign key 
CREATE TABLE bankemployees (
    emp_id INT,
    emp_name VARCHAR(100),
    branch_name VARCHAR(100),
    branch_id INT default 100,
    branch_type VARCHAR(100) default "main",
    emp_age int not null,
    primary key (emp_id)
);

insert into bankemployees values (1, "name1", "branch1", 25, "local", 25);
insert into bankemployees values (2, "name1", "branch1", default, default, 25);

select * from bankemployees;
describe bankemployees;

#change column name or data type -----------------------------------------------------------------------
alter table bankemployees change column branch_type branch_source varchar(50);
alter table teammates modify name varchar(40); # only modifies column data type
alter table bankemployees change column branch_type branch_source varchar(50); # modifies column name and data type both

#add contraint after the table has been created------------------------------------------
alter table bankemployees change column emp_age emp_age int not null default 30;
#alter table bankemployees add constraint (emp_name_not_null) not null emp_name; 

#views----------------------------------------
create view citizens_with_age_below_25 as
select name, age from citizens 
where age <25 
order by age;

select * from citizens_with_age;
select * from citizens_with_age_below_25;
update citizens_with_age_below_25 set age = 25 where name = "Surajpal";

create index emp_name_age 
on bankemployees (emp_name, emp_age);

SELECT *
FROM bankemployees WITH(INDEX(emp_name_age));