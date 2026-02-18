DROP DATABASE IF EXISTS COLLEGE_MANAGEMENT_SYSTEM;
CREATE DATABASE COLLEGE_MANAGEMENT_SYSTEM;
USE COLLEGE_MANAGEMENT_SYSTEM;


-- Create Students Table
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    year INTEGER CHECK(year BETWEEN 1 AND 4),
    department TEXT NOT NULL,
    cgpa REAL CHECK(cgpa BETWEEN 0 AND 10)
);

-- Create Faculty Table
CREATE TABLE faculty (
    faculty_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    department TEXT NOT NULL,
    salary REAL NOT NULL
);

-- Create Courses Table
CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY,
    course_name TEXT NOT NULL,
    credits INTEGER NOT NULL,
    faculty_id INTEGER,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
);

-- Create Enrollments Table
CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    grade TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Create Attendance Table
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    percentage REAL CHECK(percentage BETWEEN 0 AND 100),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insertion of Data

INSERT INTO students VALUES (1, 'Aron', 'Josh', 1, 'CSE', 8.5);
INSERT INTO students VALUES (2, 'Joseph', 'Josh', 2, 'ECE', 8.8);
INSERT INTO students VALUES (3, 'Jerolin', 'Sathish', 4, 'AIML', 10);
INSERT INTO students VALUES (4, 'Mirabella', 'James', 4, 'AIDS', 10);
INSERT INTO students VALUES (5, 'Riya', 'Josh', 2, 'EEE', 8.8);
INSERT INTO students VALUES (6, 'Diya', 'Josh', 3, 'MECH', 8.9);
INSERT INTO students VALUES (7, 'Suzhina', 'Josh', 2, 'CIVIL', 8.9);
INSERT INTO students VALUES (8, 'Daisy', 'Mariyal', 1, 'CSE', 8.1);
INSERT INTO students VALUES (9, 'Rubickson', 'Dimal', 4, 'IT', 8.2);
INSERT INTO students VALUES (10, 'Ruby', 'Dimal', 3, 'IT', 8.3);

INSERT INTO faculty VALUES (1, 'Dr. Smith', 'CSE', 90000);
INSERT INTO faculty VALUES (2, 'Dr. Kumar', 'ECE', 75000);
INSERT INTO faculty VALUES (3, 'Dr. Sanmathy', 'EEE', 85000);
INSERT INTO faculty VALUES (4, 'Dr. Diya', 'MECH', 65000);
INSERT INTO faculty VALUES (5, 'Dr. Keerthika', 'CIVIL', 85000);
INSERT INTO faculty VALUES (6, 'Dr. Rebeca', 'AIML', 185000);
INSERT INTO faculty VALUES (7, 'Dr. Rachel', 'AIDS', 185000);
INSERT INTO faculty VALUES (8, 'Dr. Joshua', 'IT', 170000);



INSERT INTO courses VALUES (101, 'Database Systems', 4, 1);
INSERT INTO courses VALUES (102, 'Digital Electronics', 3, 2);


INSERT INTO enrollments VALUES (1, 1, 101, 'A');
INSERT INTO enrollments VALUES (2, 2, 102, 'B');

INSERT INTO attendance VALUES (1, 1, 101, 92.5);
INSERT INTO attendance VALUES (2, 2, 102, 88.0);

-- Show all students with enrolled course names
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Find average CGPA by department
SELECT department, AVG(cgpa) AS avg_cgpa
FROM students
GROUP BY department;

-- Find students with attendance > 90%
SELECT s.first_name, a.percentage
FROM students s
JOIN attendance a ON s.student_id = a.student_id
WHERE a.percentage > 90;

-- Find faculty earning above average salary
SELECT name
FROM faculty
WHERE salary > (SELECT AVG(salary) FROM faculty);