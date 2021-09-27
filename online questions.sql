CREATE DATABASE ORG;
SHOW DATABASES;
USE ORG;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');

CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
		(001, 5000, '16-02-20'),
		(002, 3000, '16-06-11'),
		(003, 4000, '16-02-20'),
		(001, 4500, '16-02-20'),
		(002, 3500, '16-06-11');
CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2016-02-20 00:00:00'),
 (002, 'Executive', '2016-06-11 00:00:00'),
 (008, 'Executive', '2016-06-11 00:00:00'),
 (005, 'Manager', '2016-06-11 00:00:00'),
 (004, 'Asst. Manager', '2016-06-11 00:00:00'),
 (007, 'Executive', '2016-06-11 00:00:00'),
 (006, 'Lead', '2016-06-11 00:00:00'),
 (003, 'Lead', '2016-06-11 00:00:00');
 
 select * from worker;
select * from title;
 select * from bonus;
 
 #Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME Ascending and DEPARTMENT Descending
 select * from worker order by FIRST_NAME asc, DEPARTMENT desc;
 
 #Write an SQL query to print details of workers excluding first names, “Vipul” and “Satish” from Worker table.
 select * from worker where FIRST_NAME not in ('Vipul', 'Satish');
 
 #Write an SQL query to print details of Workers with DEPARTMENT name as “Admin”.
select * from worker where DEPARTMENT = 'Admin';
Select * from Worker where DEPARTMENT like 'Admin%';

SELECT DEPARTMENT, COUNT(WORKER_ID) as 'Number of Workers' FROM Worker GROUP BY DEPARTMENT HAVING COUNT(WORKER_ID) < 5;

 #Write an SQL query to print details of the Workers whose FIRST_NAME contains ‘a’.
 select * from worker where FIRST_NAME like '%a%';
 
 #Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘a’.
  select * from worker where FIRST_NAME like '%a';
  
  #Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘h’ and contains six alphabets.
  select * from worker where FIRST_NAME like '%h' and length(FIRST_NAME) = 6;
  Select * from Worker where FIRST_NAME like '_____h';
  
  #Write an SQL query to print details of the Workers who have joined in Feb’2014.
  select * from worker where month(JOINING_DATE) = 02 and year(JOINING_DATE) = 2014;
  
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) As Worker_Name, Salary
FROM worker 
WHERE Salary BETWEEN 50000 AND 100000;

#Write an SQL query to fetch worker names with salaries >= 50000 and <= 100000.
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) As Worker_Name, Salary
FROM worker 
WHERE WORKER_ID IN 
(SELECT WORKER_ID FROM worker 
WHERE Salary BETWEEN 50000 AND 100000);

#Write an SQL query to fetch the no. of workers for each department in the descending order.
SELECT DEPARTMENT, count(*) as No_Of_Workers 
FROM worker 
GROUP BY DEPARTMENT 
ORDER BY No_Of_Workers DESC;

#Write an SQL query to print details of the Workers who are also Managers.
select w.*, t.WORKER_TITLE from worker as w join title as t on w.WORKER_ID = t.WORKER_REF_ID where WORKER_TITLE = 'Manager';

#*******
#Write an SQL query to fetch duplicate records having matching data in some fields of a table.
SELECT WORKER_TITLE, AFFECTED_FROM, COUNT(*)
FROM Title
GROUP BY WORKER_TITLE, AFFECTED_FROM
HAVING COUNT(*) > 1;

#***********
#Write an SQL query to show only odd rows from a table.
SELECT * FROM Worker WHERE MOD (WORKER_ID, 2) <> 0;

#*********
#Write an SQL query to show only even rows from a table.
SELECT * FROM Worker WHERE MOD (WORKER_ID, 2) = 0;

#************
#Write an SQL query to clone a new table from another table.
CREATE TABLE WorkerClone (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);
SELECT * INTO WorkerClone FROM Worker;
drop table WorkerClone;

CREATE TABLE WorkerClone LIKE Worker;
select * from WorkerClone;

#*************
#Write an SQL query to show records from one table that another table does not have.
SELECT * FROM Worker
MINUS
SELECT * FROM Title;

#*****************
#Write an SQL query to show the current date and time.
SELECT CURDATE();
SELECT NOW();

#Write an SQL query to show the top n (say 10) records of a table.
SELECT Salary FROM Worker ORDER BY Salary DESC LIMIT 5;

#Write an SQL query to determine the nth (say n=5) highest salary from a table.
SELECT Salary FROM Worker ORDER BY Salary DESC LIMIT 5,1;
#SELECT Salary FROM Worker ORDER BY Salary DESC LIMIT n-1,1;

SELECT * FROM Worker ORDER BY Salary DESC;

#***********************************************************************
#Write an SQL query to determine the 5th highest salary without using TOP or limit method.
SELECT Salary
FROM Worker W1
WHERE 4 = (
 SELECT COUNT( DISTINCT ( W2.Salary ) )
 FROM Worker W2
 WHERE W2.Salary >= W1.Salary
 );
 
 select not distinct(Salary), concat(FIRST_NAME, ' ', LAST_NAME), Salary from worker group by SALARY, FIRST_NAME;
 
select FIRST_NAME, DEPARTMENT from worker W where W.DEPARTMENT='HR' 
union all 
select FIRST_NAME, DEPARTMENT from Worker W where W.DEPARTMENT='HR';