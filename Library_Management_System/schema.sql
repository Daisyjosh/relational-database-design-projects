DROP DATABASE LIBRARY IF EXISTS;
CREATE DATABASE LIBRARY;

CREATE TABLE membership_plan(
    plan_id INTEGER PRIMARY KEY,
    plan_name TEXT NOT NULL,
    max_books_allowed INTEGER,
    loan_duration_days INTEGER,
    fine_per_day REAL
);

CREATE TABLE user(
    user_id INTEGER PRIMARY KEY;
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    membership_date DATE,
    status TEXT DEFAULT 'active',
    plan_id INTEGER,
    FOREIGN KEY (plan_id) REFERENCES membership_plan(plan_id)
);

CREATE TABLE book (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    isbn TEXT UNIQUE,
    publication_year INTEGER
);

CREATE TABLE author (
    author_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE book_author(
    book_id INTEGER,
    author_id INTEGER,
    PRIMARY KEY (book_id,author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE book_copy (
    copy_id INTEGER PRIMARY KEY,
    book_id INTEGER,
    barcode TEXT UNIQUE,
    status TEXT DEFAULT 'available',
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

CREATE TABLE issue_record (
    issue_id INTEGER PRIMARY KEY,
    copy_id INTEGER,
    user_id INTEGER,
    issue_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (copy_id) REFERENCES book_copy(copy_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

INSERT INTO membership_plan 
(plan_id, plan_name, max_books_allowed, loan_duration_days, fine_per_day)
VALUES
(1, 'Student Plan', 3, 7, 2.0),
(2, 'Faculty Plan', 5, 14, 1.0);

INSERT INTO user 
(user_id, name, email, phone, membership_date, status, plan_id)
VALUES
(1, 'Arjun Kumar', 'arjun@example.com', '9876543210', '2026-01-01', 'active', 1),
(2, 'Meena Joseph', 'meena@example.com', '9123456780', '2026-01-05', 'active', 2);

INSERT INTO book 
(book_id, title, isbn, publication_year)
VALUES
(1, 'Clean Code', '9780132350884', 2008),
(2, 'The Pragmatic Programmer', '9780201616224', 1999);

INSERT INTO author 
(author_id, name)
VALUES
(1, 'Robert C. Martin'),
(2, 'Andrew Hunt'),
(3, 'David Thomas');

INSERT INTO book_author 
(book_id, author_id)
VALUES
(1, 1),   
(2, 3);

INSERT INTO book_copy 
(copy_id, book_id, barcode, status)
VALUES
(1, 1, 'CC001', 'available'),
(2, 1, 'CC002', 'available'),
(3, 2, 'PP001', 'available');

INSERT INTO issue_record
(issue_id, copy_id, user_id, issue_date, due_date, return_date)
VALUES
(1, 1, 1, '2026-02-15', '2026-02-22', NULL);

UPDATE book_copy
SET status = 'issued'
WHERE copy_id = 1;

INSERT INTO fine_payment
(payment_id, issue_id, amount, payment_date)
VALUES
(1, 1, 4.0, '2026-02-25');

-- show all available max_books_allowed
SELECT 
    b.title,
    bc.copy_id,
    bc.barcode
FROM book_copy bc
JOIN book b ON bc.book_id = b.book_id
WHERE bc.status = 'available';


-- show which user currently holds which book
SELECT 
    u.name AS user_name,
    b.title AS book_title,
    ir.issue_date,
    ir.due_date
FROM issue_record ir
JOIN user u ON ir.user_id = u.user_id
JOIN book_copy bc ON ir.copy_id = bc.copy_id
JOIN book b ON bc.book_id = b.book_id
WHERE ir.return_date IS NULL;

-- show total copies per book
SELECT 
    b.title,
    COUNT(bc.copy_id) AS total_copies
FROM book b
LEFT JOIN book_copy bc ON b.book_id = bc.book_id
GROUP BY b.book_id;

-- show available copipes per book
SELECT 
    b.title,
    COUNT(bc.copy_id) AS available_copies
FROM book b
JOIN book_copy bc ON b.book_id = bc.book_id
WHERE bc.status = 'available'
GROUP BY b.book_id;