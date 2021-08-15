use subqueriesandjoin;
select * from company;

select branch from company where name = 'Yahoo';

use jointables;
select * from citizens; 
insert into citizens values('Sukhdeep Singh', 27, 5, 'O');
alter table citizens add column bloodGroup varchar (20);
alter table citizens drop column bloodGroup;

update citizens set bloodGroup = 'A';
delete from citizens where name = 'Sukhdeep Singh';

# to select unique items fro table
select distinct * from citizens;

select name from citizens where age = 24 and exp = 3;
select * from citizens where age <= 24 or exp =5;

# print age between 24 and 26 (includes 24 and 26)
select * from citizens where age in (24,26);
select * from citizens where age between 24 and 26;

select * from citizens where age not between 24 and 26;

# regular expressions 
select * from citizens where name like '_a%'; #second char is 'a'
select * from citizens where name like 'M%'; # first char is 'M'

# groups
use `survey`;
select * from salary_survey;
select sum(years_experience), is_manager from salary_survey group by is_manager;
select max(years_experience), min(years_experience), is_manager from salary_survey group by is_manager;

# Count 
select count(*) from salary_survey;
select count(*), job_title from salary_survey group by job_title;
select count(*), job_title from salary_survey group by job_title having count(*) < 10;

# Sub Queries
use jointables;
select * from citizens; 
select * from citizensloc;
select * from citizens where name = (select name from citizensloc where location = 'jalandhar');
select * from citizens where name in (select name from citizensloc where location = 'hoshiarpur');

select name from citizeninsert_new_orderssloc where location = 'jalandhar';

# Joins 
select c.name, cl.location from citizens as c join citizensloc as cl on c.name = cl.name; 
select c.*, cl.location from citizens as c join citizensloc as cl on c.name = cl.name having location ='hoshiarpur';
select c.name, cl.location from citizens as c inner join citizensloc as cl on c.name = cl.name;
select c.name, cl.location from citizens as c left join citizensloc as cl on c.name = cl.name;
select c.name, cl.location from citizens as c right join citizensloc as cl on c.name = cl.name;

update citizensloc set location = 'hoshiarpur' where name = 'Surajpal';
insert into citizensloc values('Kulbir Singh', 'Ropar');

#String functions
select concat(name, exp) as exp from citizens;