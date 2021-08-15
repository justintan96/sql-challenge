-- Creating Table (Exported from EDB)
-- When i imported the code from EDB it put all my data set names into "" however this version of pgAdmin i'm in does not need that 
-- Didn't have time to correct it and re-run so i have to include it everytime i want to reference it


CREATE TABLE "Titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "Salaries" (
    "emp_no" INT   NOT NULL,
    "Salary" INT   NOT NULL
);

CREATE TABLE "Employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Department_Manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "Department_Employment" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "Departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "Titles" ("title_id");

ALTER TABLE "Department_Manager" ADD CONSTRAINT "fk_Department_Manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Department_Manager" ADD CONSTRAINT "fk_Department_Manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Department_Employment" ADD CONSTRAINT "fk_Department_Employment_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Department_Employment" ADD CONSTRAINT "fk_Department_Employment_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

SELECT * FROM "Departments";
SELECT * FROM "Titles";
SELECT * FROM "Employees";
SELECT * FROM "Department_Employment";
SELECT * FROM "Department_Manager";
SELECT * FROM "Salaries";

--1. List the following details of each employee: employee number, last name, first name, sex, and salary.
--first, when you want to list we start with selecting the variables in reference (dataset.data) to which dataset they came from
--second you make the reference FROM "where?" i.e which table/dataset 
--next if the variables you want to list do not come from the same data set you need to join by the variable that exist in both sets 
--you can do multiple joins until you have all the variables you want to list

-- i really cannot figure out why my salaries is being stubborn in this first question 

SELECT "Employees".emp_no, "Employees".last_name, "Employees".first_name, "Employees".sex, "Salaries".Salary
FROM "Employees"
JOIN "Salaries" ON "Employees".emp_no = "Salaries".emp_no;

--2. List first name, last name, and hire date for employees who were hired in 1986.

SELECT first_name, last_name, hire_date 
FROM "Employees"
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;

--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.

SELECT "Departments".dept_no, "Departments".dept_name, "Department_Manager".emp_no, "Employees".last_name, "Employees".first_name
FROM "Departments"
JOIN "Department_Manager"
ON "Departments".dept_no = "Department_Manager".dept_no
JOIN "Employees"
ON "Department_Manager".emp_no = "Employees".emp_no;

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT "Department_Employment".emp_no, "Employees".last_name, "Employees".first_name, "Departments".dept_name
FROM "Department_Employment"
JOIN "Employees"
ON "Department_Employment".emp_no = "Employees".emp_no
JOIN "Departments"
ON "Department_Employment".dept_no = "Departments".dept_no;

--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

SELECT "Employees".first_name, "Employees".last_name, "Employees".sex
FROM "Employees"
WHERE first_name = 'Hercules'
AND last_name Like 'B%'

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT "Departments".dept_name, "Employees".last_name, "Employees".first_name
FROM "Department_Employment"
JOIN "Employees"
ON "Department_Employment".emp_no = "Employees".emp_no
JOIN "Departments"
ON "Department_Employment".dept_no = "Departments".dept_no
WHERE "Departments".dept_name = 'Sales';

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT "Departments".dept_name, "Employees".last_name, "Employees".first_name, "Department_Employment".emp_no
FROM "Department_Employment"
JOIN "Employees"
ON "Department_Employment".emp_no = "Employees".emp_no
JOIN "Departments"
ON "Department_Employment".dept_no = "Departments".dept_no
WHERE "Departments".dept_name = 'Sales' 
OR "Departments".dept_name = 'Development';

--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT last_name,
COUNT(last_name) AS "frequency"
FROM "Employees"
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;
