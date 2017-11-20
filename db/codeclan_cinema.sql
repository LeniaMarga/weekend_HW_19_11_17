---when you drop, you drop the one with the reference first
---when you create you create the one with no reference first

DROP TABLE tickets;
DROP TABLE films;
DROP TABLE customers;

CREATE TABLE films(
  id SERIAL4 PRIMARY KEY,
  price INT4,
  title VARCHAR(255) NOT NULL
);

CREATE TABLE customers(
  id SERIAL4 PRIMARY KEY,
  funds INT4,
  name VARCHAR(255)
);

CREATE TABLE tickets(
  id SERIAL4 PRIMARY KEY,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE
);
