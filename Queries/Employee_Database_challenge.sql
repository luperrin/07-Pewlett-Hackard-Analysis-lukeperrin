-- DELIVERABLE 1

-- Create table for retirement_titles
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ttl.title,
	ttl.from_date,
	ttl.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ttl
	ON (e.emp_no = ttl.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

-- Query to retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(ut.title),
	ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;



-- DELIVERABLE 2

-- Create Mentorship Eligibility table that holds the employees who are eligible to participate in a mentorship program
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ttl.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ttl
	ON (e.emp_no = ttl.emp_no)
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;


-- DELIVERABLE 3

-- 1. How many roles will need to be filled as the "silver tsunami" begins to make an impact?
SELECT * FROM retiring_titles;
-- a. Number of titles needing to be filled
SELECT COUNT(title) FROM retiring_titles;
-- b. Total number of positions needing to be filled
SELECT SUM("count") FROM retiring_titles;

-- 2. Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
SELECT COUNT(me.title),
	me.title
INTO eligible_mentors
FROM mentorship_eligibilty as me
GROUP BY me.title
ORDER BY COUNT(me.title) DESC;

SELECT * FROM eligible_mentors;
-- Query calculation to determine the number of expected new hires per mentor
SELECT rt.title,
	rt.count as "count_expected_new_hires",
	em.count as "count_eligible_mentors"
INTO count_mentor_newhires
FROM retiring_titles as rt
FULL OUTER JOIN eligible_mentors as em
	ON (rt.title = em.title);
	
SELECT cmn.title, 
	cmn.count_expected_new_hires, 
	cmn.count_eligible_mentors, cmn.count_expected_new_hires/cmn.count_eligible_mentors as "new_hires_per_mentor"
FROM count_mentor_newhires as cmn;



