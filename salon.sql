-- Create the database
CREATE DATABSE salon;

-- Connect to the salon database
\c salon

-- Create tables
CREATE TABLE customers (
  customer_id SERIAL PRIAMRY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE appointments (
  appintment_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  service_id INT REFERENCES services(service_id),
  time VARCHAR(20) NOT NULL
);

-- Insert initial services
INSERT INTO services (name) VALUES
('Hair Cut'),
('Coloring'),
('Styling');
