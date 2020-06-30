CREATE DATABASE IF NOT EXISTS library;

CREATE TABLE translations(
    trans_code varchar(2),
    language varchar(20),
    PRIMARY KEY (trans_code)
);

CREATE TABLE authors(
    author_id int(10),
    first_name varchar(40),
    last_name varchar(40),
    PRIMARY KEY (author_id)    
);

CREATE TABLE publishing_houses(
    publisher_id int(10),
    name varchar(40),
    PRIMARY KEY (publisher_id)
);

CREATE TABLE personal_details(
    ssn int(8),
    first_name varchar(20),
    last_name varchar(20),
    PRIMARY KEY (ssn)
);

CREATE TABLE customers(
    customer_id int(10),
    ssn int(8),
    PRIMARY KEY (customer_id),
    FOREIGN KEY (ssn) REFERENCES personal_details(ssn)
);

CREATE TABLE employees(
    employee_id int(10),
    ssn int(8),
    PRIMARY KEY (employee_id),
    FOREIGN KEY (ssn) REFERENCES personal_details(ssn)
);

CREATE TABLE subject_areas(
    subject_area_name varchar(20),
    PRIMARY KEY (subject_area_name)
);

CREATE TABLE collaborations(
    collaboration_id int(10),
    author_id int(10),
    PRIMARY KEY (collaboration_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE books(
    book_id int(10),
    publisher_id int(10),
    collaboration_id int(10),
    trans_code varchar(2),
    subject_area varchar(20),
    title varchar(20),
    PRIMARY KEY (book_id),
    FOREIGN KEY (publisher_id) REFERENCES publishing_houses(publisher_id),
    FOREIGN KEY (collaboration_id) REFERENCES collaborations(collaboration_id),
    FOREIGN KEY (trans_code) REFERENCES translations(trans_code),
    FOREIGN KEY (subject_area) REFERENCES subject_areas(subject_area_name)
);

CREATE TABLE journals(
    journal_id int(10),
    publisher_id int(10),
    subject_area varchar(20),
    title varchar(20),
    issue varchar(8),
    PRIMARY KEY (journal_id),
    FOREIGN KEY (publisher_id) REFERENCES publishing_houses(publisher_id),
    FOREIGN KEY (subject_area) REFERENCES subject_areas(subject_area_name)
);

CREATE TABLE articles(
    article_id int(10),
    journal_id int(10),
    reference_id int(10),
    PRIMARY KEY (article_id),
    FOREIGN KEY (journal_id) REFERENCES journals(journal_id)
);

CREATE TABLE article_references(
    reference_id int(10),
    occurrence int(10),
    referenced_id int(10),
    PRIMARY KEY (reference_id),
    FOREIGN KEY (occurrence) REFERENCES articles(article_id),
    FOREIGN KEY (referenced_id) REFERENCES articles(article_id)
);

ALTER TABLE articles ADD FOREIGN KEY (reference_id) REFERENCES article_references(reference_id);

CREATE TABLE book_inventory(
    unique_book_id int(10),
    book_id int(10),
    shelf int(2),
    PRIMARY KEY (unique_book_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE journal_inventory(
    unique_journal_id int(10),
    journal_id int(10),
    shelf int(2),
    PRIMARY KEY (unique_journal_id),
    FOREIGN KEY (journal_id) REFERENCES journals(journal_id)
);

CREATE TABLE book_keywords(
    book_keyword varchar(20),
    subject_area varchar(20),
    book_id int(10),
    PRIMARY KEY (book_keyword),
    FOREIGN KEY (subject_area) REFERENCES subject_areas(subject_area_name),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE journal_keywords(
    journal_keyword varchar(20),
    subject_area varchar(20),
    journal_id int(10),
    PRIMARY KEY (journal_keyword),
    FOREIGN KEY (subject_area) REFERENCES subject_areas(subject_area_name),
    FOREIGN KEY (journal_id) REFERENCES journals(journal_id)
);

CREATE TABLE reservations(
    unique_book_id int(10),
    reserved_until datetime,
    reserved_by int(10),
    PRIMARY KEY (unique_book_id, reserved_until),
    FOREIGN KEY (unique_book_id) REFERENCES book_inventory(unique_book_id),
    FOREIGN KEY (reserved_by) REFERENCES customers(customer_id)
);

CREATE TABLE lendings(
    lending_id int(10),
    unique_book_id int(10),
    borrowed_at datetime DEFAULT CURRENT_TIMESTAMP,
    returned_at datetime,
    borrowed_by int(10),
    employee_out int(10),
    employee_in int(10),
    payment_amount double(4,2),
    paid_at datetime,
    PRIMARY KEY (lending_id),
    FOREIGN KEY (unique_book_id) REFERENCES book_inventory(unique_book_id),
    FOREIGN KEY (borrowed_by) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_out) REFERENCES employees(employee_id),
    FOREIGN KEY (employee_in) REFERENCES employees(employee_id)
);
