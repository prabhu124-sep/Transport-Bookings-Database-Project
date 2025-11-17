-- Passengers Table
CREATE TABLE Passengers (
    passenger_id INTEGER PRIMARY KEY,
    name TEXT,
    gender TEXT,
    age_group TEXT,
    registration_date TEXT,
    city TEXT
);

-- Vehicles Table
CREATE TABLE Vehicles (
    vehicle_id INTEGER PRIMARY KEY,
    vehicle_type TEXT,
    capacity INTEGER,
    registration_year INTEGER,
    condition_rating INTEGER,
    assigned_route TEXT
);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id INTEGER,
    passenger_id INTEGER,
    vehicle_id INTEGER,
    trip_date TEXT,
    route TEXT,
    seat_number INTEGER,
    ticket_price REAL,
    satisfaction_rating INTEGER,
    status TEXT,
    PRIMARY KEY (booking_id, passenger_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


--1. View First Few Rows

SELECT * FROM Passengers LIMIT 5;
SELECT * FROM Vehicles LIMIT 5;
SELECT * FROM Bookings LIMIT 5;

--2. Missing Value Count Per Column
--Passengers Table

SELECT
  SUM(passenger_id IS NULL) AS miss_passenger_id,
  SUM(name IS NULL) AS miss_name,
  SUM(gender IS NULL) AS miss_gender,
  SUM(age_group IS NULL) AS miss_age_group,
  SUM(registration_date IS NULL) AS miss_registration_date,
  SUM(city IS NULL) AS miss_city
FROM Passengers;

--Vehicles Table

SELECT
  SUM(vehicle_id IS NULL) AS miss_vehicle_id,
  SUM(vehicle_type IS NULL) AS miss_vehicle_type,
  SUM(capacity IS NULL) AS miss_capacity,
  SUM(registration_year IS NULL) AS miss_registration_year,
  SUM(condition_rating IS NULL) AS miss_condition_rating,
  SUM(assigned_route IS NULL) AS miss_assigned_route
FROM Vehicles;

--Bookings Table

SELECT
  SUM(booking_id IS NULL) AS miss_booking_id,
  SUM(passenger_id IS NULL) AS miss_passenger_id,
  SUM(vehicle_id IS NULL) AS miss_vehicle_id,
  SUM(trip_date IS NULL) AS miss_trip_date,
  SUM(route IS NULL) AS miss_route,
  SUM(seat_number IS NULL) AS miss_seat_number,
  SUM(ticket_price IS NULL) AS miss_ticket_price,
  SUM(satisfaction_rating IS NULL) AS miss_satisfaction_rating,
  SUM(status IS NULL) AS miss_status
FROM Bookings;


--3. Preprocessing: Replace NULLs
--Passengers Table

UPDATE Passengers
SET
  gender = COALESCE(gender, 'unknown'),
  age_group = COALESCE(age_group, 'unknown'),
  registration_date = COALESCE(registration_date, 'unknown'),
  city = COALESCE(city, 'unknown');

--Vehicles Table

UPDATE Vehicles
SET
  vehicle_type = COALESCE(vehicle_type, 'unknown'),
  capacity = COALESCE(capacity, 0),
  registration_year = COALESCE(registration_year, 0),
  condition_rating = COALESCE(condition_rating, 0),
  assigned_route = COALESCE(assigned_route, 'unknown');

  --Bookings Table

UPDATE Bookings
SET
  trip_date = COALESCE(trip_date, 'unknown'),
  route = COALESCE(route, 'unknown'),
  seat_number = COALESCE(seat_number, 0),
  ticket_price = COALESCE(ticket_price, 0),
  satisfaction_rating = COALESCE(satisfaction_rating, 0),
  status = COALESCE(status, 'unknown');

  -- 4. Check That NULLs Are Replaced

SELECT * FROM Passengers WHERE gender IS NULL OR age_group IS NULL OR registration_date IS NULL OR city IS NULL;

SELECT * FROM Vehicles WHERE vehicle_type IS NULL OR capacity IS NULL OR registration_year IS NULL OR condition_rating IS NULL OR assigned_route IS NULL;

SELECT * FROM Bookings WHERE trip_date IS NULL OR route IS NULL OR seat_number IS NULL OR ticket_price IS NULL OR satisfaction_rating IS NULL OR status IS NULL;

-- 5. Data Understanding & Aggregates (example queries)
--a. Average Ticket Price Per Vehicle

SELECT Vehicles.vehicle_type, AVG(Bookings.ticket_price) AS avg_price, COUNT(Bookings.booking_id) AS total_bookings
FROM Bookings
JOIN Vehicles ON Bookings.vehicle_id = Vehicles.vehicle_id
GROUP BY Vehicles.vehicle_id
ORDER BY avg_price DESC
LIMIT 5;

--b. Seat Number Distribution

SELECT seat_number, COUNT(*) AS frequency
FROM Bookings
GROUP BY seat_number
ORDER BY seat_number;

--c. Most Used Routes

SELECT route, COUNT(*) AS num_bookings
FROM Bookings
GROUP BY route
ORDER BY num_bookings DESC;

--d. Booking Status Counts

SELECT status, COUNT(*) AS count
FROM Bookings
GROUP BY status
ORDER BY count DESC;

--e. Passengers With Most Bookings

SELECT Passengers.name, COUNT(Bookings.booking_id) AS num_bookings
FROM Bookings
JOIN Passengers ON Bookings.passenger_id = Passengers.passenger_id
GROUP BY Passengers.passenger_id
ORDER BY num_bookings DESC
LIMIT 10;


