-- Flights
INSERT INTO flights (flight_number, airline, source, destination, departure_time, arrival_time, available_seats, price)
VALUES
('AI101', 'Air India', 'Delhi', 'Mumbai', '2025-09-10 08:00:00', '2025-09-10 10:00:00', 120, 5500.00),
('6E202', 'IndiGo', 'Bangalore', 'Chennai', '2025-09-11 09:00:00', '2025-09-11 10:30:00', 100, 3000.00),
('SG303', 'SpiceJet', 'Kolkata', 'Delhi', '2025-09-12 07:30:00', '2025-09-12 10:15:00', 150, 4800.00);

-- Users
INSERT INTO users (name, email, password)
VALUES
('Tia Chugh', 'tia@example.com', 'password123'),
('Vanshika', 'vanshika@example.com', 'pass456'),
('Siya Kakkar', 'siya@example.com', 'pass789');

-- Bookings
INSERT INTO booking (user_id, flight_id, seats_booked, booking_date, status)
VALUES
(1, 1, 2, '2025-09-06', 'CONFIRMED'),
(2, 2, 1, '2025-09-06', 'CONFIRMED'),
(3, 3, 3, '2025-09-06', 'CONFIRMED');
