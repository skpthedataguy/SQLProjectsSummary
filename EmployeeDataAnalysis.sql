create table emp_detail (ID INT,FIRSTNAME VARCHAR(25),LASTNAME VARCHAR(25),GENDER VARCHAR(25),SALARY INT)

INSERT INTO emp_detail
VALUES
(1,'Ben','Hoskins','Male',70000),
(2,'Mark','Hastings','Male',60000),
(3,'Steve','Pound','Male',45000),
(4,'Ben','Hoskins','Male',70000),
(5,'Philip','Hastings','Male',45000),
(6,'Mary','Lambeth','Female',30000),
(7,'Valarie','Vikines','Female',35000),
(8,'John','Stanmore','Male',80000)

select * from emp_detail

--2nd highest salary (Process 1)
select max(SALARY) from emp_detail
where salary<(select max(salary) from emp_detail)
--2nd highest salary (Process 2)
select top 1 salary from(select top 2 salary from emp_detail order by salary desc) as sal_2nd order by SALARY
--2nd highest salary (Process 3)
with cte_salary
as
(select top 2 salary from emp_detail order by SALARY desc)
select top 1 salary from cte_salary order by SALARY

--this will show the duplicate values like, 80,000 70,000 and 70,000
select top 3 salary from emp_detail order by SALARY desc

--so, to avoid this, use distinct
select distinct top 3 salary from emp_detail order by salary desc

--2nd highest salary (Process 4)
with cte_myemp
as
(select SALARY,DENSE_RANK() over (order by salary desc) as rnk from emp_detail)
select distinct salary from cte_myemp
where rnk=2

--for showing whole table and the specific result together....use GO...
select * from emp_detail order by SALARY desc
go
with cte_myemp
as
(select SALARY,DENSE_RANK() over (order by salary desc) as rnk from emp_detail)
select distinct salary from cte_myemp
where rnk=2

--avoid ROW_NUMBER() when there are possibilities of duplicate values

select salary,ROW_NUMBER() over (order by salary desc) as row_counting from emp_detail
--this above line of code will assign different row numbers for duplicate values, so using that no. will make mistake
select * from emp_detail order by salary desc
go
with cte_empsalarydetails
as
(select salary,ROW_NUMBER() over (order by salary desc) as row_counting from emp_detail)
select salary from cte_empsalarydetails
where row_counting=3
--after executing the above, the 3rd salary will come as 70,000 but it should be 60,000 