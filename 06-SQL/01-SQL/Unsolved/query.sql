-- Select all the employees who were born between January 1, 1952 and December 31, 1955 and their titles and title date ranges
-- Order the results by emp_no

with upcoming_retirees as (select * from employees 
where to_char(birth_date, 'YYYY-MM-DD') between '1952-01-01' and '1955-12-31')
select upcoming_retirees.emp_no, 
		upcoming_retirees.first_name,
		upcoming_retirees.last_name,
		upcoming_retirees.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		from upcoming_retirees join titles 
		on upcoming_retirees.emp_no=titles.emp_no
		order by emp_no;
        
-- Select only the current title for each employee

with employee_data as (
with upcoming_retirees as (select * from employees 
where to_char(birth_date, 'YYYY-MM-DD') between '1952-01-01' and '1955-12-31')
	
select upcoming_retirees.emp_no, 
		upcoming_retirees.first_name,
		upcoming_retirees.last_name,
		upcoming_retirees.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		from upcoming_retirees join titles 
		on upcoming_retirees.emp_no=titles.emp_no
		order by emp_no),
		
most_recent_emp as (
select emp_no, max(from_date) as most_recent from titles group by emp_no)

select employee_data.emp_no, employee_data.first_name, employee_data.last_name, employee_data.title as current_title from employee_data join most_recent_emp on ((employee_data.emp_no=most_recent_emp.emp_no) and (employee_data.from_date=most_recent_emp.most_recent));



-- Count the total number of employees about to retire by their current job title

with most_recent_title as (
with employee_data as (
with upcoming_retirees as (select * from employees 
where to_char(birth_date, 'YYYY-MM-DD') between '1952-01-01' and '1955-12-31')
	
select upcoming_retirees.emp_no, 
		upcoming_retirees.first_name,
		upcoming_retirees.last_name,
		upcoming_retirees.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		from upcoming_retirees join titles 
		on upcoming_retirees.emp_no=titles.emp_no
		order by emp_no),
		
most_recent_emp as (
select emp_no, max(from_date) as most_recent from titles group by emp_no)

select employee_data.emp_no, employee_data.first_name, employee_data.last_name, employee_data.title as current_title from employee_data join most_recent_emp on ((employee_data.emp_no=most_recent_emp.emp_no) and (employee_data.from_date=most_recent_emp.most_recent)))

select current_title, count (*) as emp_cnt from most_recent_title group by current_title;


-- Count the total number of employees per department
with cnt_by_dept as(
select dept_no, count(emp_no) as emp_cnt from dept_emp group by dept_no )
select dept_name, cnt_by_dept.emp_cnt from departments join cnt_by_dept on (departments.dept_no=cnt_by_dept.dept_no);


-- Bonus: Find the highest salary per department and department manager

--Highest salary per department manager
with most_recent_manager_salaries as (
with most_recent_salaries as (
with most_recent_emp as( 
select emp_no,
		max(from_date) as most_recent_appt 
		from salaries group by emp_no)
select most_recent_emp.*, 
		salaries.salary 
		from salaries join most_recent_emp 
		on salaries.emp_no=most_recent_emp.emp_no 
		and salaries.from_date=most_recent_emp.most_recent_appt
		order by emp_no),

current_managers as(
select dept_no, emp_no, from_date from dept_manager where to_date= '9999-01-01')
	
select current_managers.dept_no, 
		most_recent_salaries.emp_no, 
		most_recent_salaries.salary 
		from current_managers join
		most_recent_salaries on current_managers.emp_no=most_recent_salaries.emp_no)
select max(salary) from most_recent_manager_salaries


--Highest salary per department
with most_recent_emp_salaries as (
with most_recent_emp_date as(
with most_recent_emp as (select emp_no, max(from_date) as from_date from dept_emp group by emp_no)
select most_recent_emp.emp_no, 
		most_recent_emp.from_date, 
		dept_emp.dept_no
		from most_recent_emp join dept_emp 
		on most_recent_emp.emp_no=dept_emp.emp_no
			and dept_emp.from_date=most_recent_emp.from_date)
			select most_recent_emp_date.emp_no,
					most_recent_emp_date.dept_no,
					salaries.salary
					from most_recent_emp_date join salaries
					on most_recent_emp_date.emp_no=salaries.emp_no
					and most_recent_emp_date.from_date=salaries.from_date
					order by emp_no)
		select dept_no, 
				max(salary) as highest_salary from
				most_recent_emp_salaries
				group by dept_no
				order by dept_no 

