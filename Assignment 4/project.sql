
# mohsh543, rayba120      Assignment 4c

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS year CASCADE;
DROP TABLE IF EXISTS airport CASCADE;
DROP TABLE IF EXISTS passenger CASCADE;
DROP TABLE IF EXISTS weekday CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS weekly_schedule CASCADE;
DROP TABLE IF EXISTS contact CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS reservs CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS payment CASCADE;

DROP VIEW IF EXISTS allFlights CASCADE;
SET FOREIGN_KEY_CHECKS=1;

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;

DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;



# --------------------------- Table Year ------------------------
CREATE TABLE year (
    Year INT NOT NULL,
    Profitfactor DOUBLE NOT NULL,
    CONSTRAINT PK_Year PRIMARY KEY (Year)
);


# --------------------------- Table Airport ------------------------
CREATE TABLE airport (
    Airport_code VARCHAR(3) NOT NULL,
    Airport_name VARCHAR(30) NOT NULL,
    Country VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Airport PRIMARY KEY (Airport_code)
);


# --------------------------- Table Passenger ------------------------
CREATE TABLE passenger (
    Passport_number INT NOT NULL,
    Name VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Passenger PRIMARY KEY (Passport_number)
);

# --------------------------- Table Weekday ------------------------
CREATE TABLE weekday (
	ID INT NOT NULL AUTO_INCREMENT,
    Day VARCHAR(10) NOT NULL,
    Year INT NOT NULL,
    Weekdayfactor DOUBLE NOT NULL,
    CONSTRAINT PK_Weekday PRIMARY KEY (ID , Year),
    CONSTRAINT FK_Weekday_Year FOREIGN KEY (Year)
        REFERENCES year (Year)
);

# --------------------------- Table Route ------------------------
CREATE TABLE route (
	RouteID INT NOT NULL AUTO_INCREMENT,
    Routeprice DOUBLE NOT NULL,
    ARR_Airport_code VARCHAR(3) NOT NULL,
    DEP_Airport_code VARCHAR(3) NOT NULL,
    Year INT NOT NULL,
    CONSTRAINT PK_Route PRIMARY KEY (RouteID),
    CONSTRAINT FK_Route_ARR_Airport FOREIGN KEY (ARR_Airport_code)
        REFERENCES airport (Airport_code),
    CONSTRAINT FK_Route_DEP_Airport FOREIGN KEY (DEP_Airport_code)
        REFERENCES airport (Airport_code),
    CONSTRAINT FK_Route_Year FOREIGN KEY (Year)
        REFERENCES year (Year)
);

# --------------------------- Table Weekly_Scheule ------------------------
CREATE TABLE weekly_schedule (
    ScheduleID INT NOT NULL AUTO_INCREMENT,
    Departure_Time TIME NOT NULL,
    WeekdayID INT NOT NULL,
    RouteID INT NOT NULL,
    Year INT NOT NULL,
    CONSTRAINT PK_WeekSch PRIMARY KEY (ScheduleID),
    CONSTRAINT FK_WeekSch_weekday FOREIGN KEY (WeekdayID)
        REFERENCES weekday (ID),
    CONSTRAINT FK_WeekSch_Route FOREIGN KEY (RouteID)
        REFERENCES route (RouteID),
    CONSTRAINT FK_WeekSch_Year FOREIGN KEY (Year)
        REFERENCES year (Year)
);

# --------------------------- Table Contact ------------------------
CREATE TABLE contact (
    Pass_num INT NOT NULL,
    Phone_number BIGINT NOT NULL,
    Email VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Contact PRIMARY KEY (Pass_num),
    CONSTRAINT FOREIGN KEY (Pass_num)
        REFERENCES passenger (Passport_number)
);

# --------------------------- Table Flight ------------------------
CREATE TABLE flight (
    Flightnumber INT NOT NULL AUTO_INCREMENT,
    Week INT NOT NULL,
    ScheduleID INT NOT NULL,
    CONSTRAINT PK_Flight PRIMARY KEY (Flightnumber),
    CONSTRAINT FK_Flight_WeekSch FOREIGN KEY (ScheduleID)
        REFERENCES weekly_schedule (ScheduleID)
);

# --------------------------- Table Reservation ------------------------
CREATE TABLE reservation (
    Reservation_number INT NOT NULL AUTO_INCREMENT,
    Reserved_seats INT NOT NULL,
    Flight_num INT,
    Contact_Pass_num INT,
    CONSTRAINT PK_Reservation PRIMARY KEY (Reservation_number),
    CONSTRAINT FK_Reserv_Flight FOREIGN KEY (Flight_num)
        REFERENCES flight (Flightnumber),
    CONSTRAINT FK_Reserv_Contact FOREIGN KEY (Contact_Pass_num)
        REFERENCES contact (Pass_num)
);

# --------------------------- Table Reservs ------------------------
CREATE TABLE reservs (
    Pass_num INT NOT NULL,
    Reserv_num INT NOT NULL,
    CONSTRAINT PK_Reservs PRIMARY KEY (Pass_num , Reserv_num),
    CONSTRAINT FK_Reservs_Passenger FOREIGN KEY (Pass_num)
        REFERENCES passenger (Passport_number),
    CONSTRAINT FK_Reservs_Reservation FOREIGN KEY (Reserv_num)
        REFERENCES reservation (Reservation_number)
);

# --------------------------- Table Payment ------------------------
CREATE TABLE payment (
    Creditcard_number BIGINT NOT NULL,
    Creditcard_holder VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Payment PRIMARY KEY (Creditcard_number)
);

# --------------------------- Table Booking ------------------------
CREATE TABLE booking (
    Booking_num INT NOT NULL,
    Price DOUBLE,
    Card_num BIGINT NOT NULL,
    CONSTRAINT PK_Booking PRIMARY KEY (Booking_num),
    CONSTRAINT FK_Book_Res FOREIGN KEY (Booking_num)
        REFERENCES reservation (Reservation_number),
    CONSTRAINT FK_Book_Pay FOREIGN KEY (Card_num)
        REFERENCES payment (Creditcard_number)
);

# --------------------------- Table Books ------------------------
CREATE TABLE books (
    Pass_num INT NOT NULL,
    Book_num INT NOT NULL,
    Ticket_num INT NOT NULL,
    CONSTRAINT PK_Books PRIMARY KEY (Pass_num , Book_num),
    CONSTRAINT FK_Books_Passenger FOREIGN KEY (Pass_Num)
        REFERENCES passenger (Passport_number),
    CONSTRAINT FK_Books_Booking FOREIGN KEY (Book_num)
        REFERENCES booking (Booking_num)
);

# ------------------------------ Procedures ----------------------------------
SELECT ' Implementing Procedures Part 1 ' AS 'Message';

# --------------------------- Procedure addYear ------------------------
DELIMITER &&
CREATE PROCEDURE addYear(IN year INT, IN factor DOUBLE)
BEGIN
INSERT INTO year VALUES (year, factor);
END &&  
DELIMITER ; 

# --------------------------- Procedure addDay ------------------------
DELIMITER &&
CREATE PROCEDURE addDay(IN year INT, IN day VARCHAR(10), IN factor DOUBLE)
BEGIN
INSERT INTO weekday (Day, Year, Weekdayfactor) VALUES (day, year, factor);
END &&  
DELIMITER ;

# --------------------------- Procedure addDestination ------------------------
DELIMITER &&
CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN name VARCHAR(30),
IN country VARCHAR(30))
BEGIN
INSERT INTO airport VALUES (airport_code, name, country);
END &&  
DELIMITER ;

# --------------------------- Procedure addRoute ------------------------
DELIMITER &&
CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3),
IN arrival_airport_code VARCHAR(3), IN year INT ,IN  routeprice DOUBLE)
BEGIN
INSERT INTO route (Routeprice, ARR_Airport_code, DEP_Airport_code, Year) VALUES (routeprice, arrival_airport_code, 
departure_airport_code, year);
END &&  
DELIMITER ;

# --------------------------- Procedure addFlight ------------------------
DELIMITER &&
CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3),
IN arrival_airport_code VARCHAR(3), IN year INT, IN day VARCHAR(10), 
IN departure_time TIME)

BEGIN
DECLARE week INT default 1;
DECLARE DayID INT;
DECLARE SchID INT;
DECLARE Route_Flight VARCHAR(3);
# ----------------------------------------------
SELECT 'First Select begin ' AS 'Message';
SELECT 
    ID
INTO DayID FROM
    weekday
WHERE
    weekday.Year = year AND weekday.Day = day;
    SELECT 'First Select end ' AS 'Message';
# ----------------------------------------------
SELECT 'Second Select begin ' AS 'Message';
SELECT 
    RouteID
INTO Route_Flight FROM
    route
WHERE
    route.ARR_Airport_code = arrival_airport_code
        AND route.DEP_Airport_code = departure_airport_code
        AND route.Year = year;
SELECT 'Second Select end ' AS 'Message';
# ----------------------------------------------
SELECT 'Insert into weekly_schedule begin ' AS 'Message';
INSERT INTO weekly_schedule (Departure_Time, WeekdayID, RouteID, Year) VALUES (departure_time, DayID, Route_Flight, year);
SELECT 'Insert into weekly_schedule end ' AS 'Message';
# ----------------------------------------------
SELECT 'Third Select begin ' AS 'Message';
SELECT 
    ScheduleID
INTO SchID FROM
    weekly_schedule
WHERE
    weekly_schedule.WeekdayID = DayID
        AND weekly_schedule.Departure_Time = departure_time;
SELECT 'Third Select end ' AS 'Message';
# ----------------------------------------------

SELECT 'Insert into flight begin ' AS 'Message';
REPEAT 
	INSERT INTO flight (Week, ScheduleID) 
		VALUES (week, SchID); 
	SET week = week + 1;
	UNTIL week = 53
END REPEAT;
SELECT 'Insert into flight end ' AS 'Message';
# ----------------------------------------------
END &&  
DELIMITER ;






# ------------------------------ Functions ----------------------------------
SELECT ' Implementing Functions ' AS 'Message';

# --------------------------- Function calculateFreeSeats ------------------------
DELIMITER &&
CREATE FUNCTION calculateFreeSeats(flightnumber INT) RETURNS INT
BEGIN

	DECLARE free INT;
    DECLARE booked INT;
    
    IF (SELECT 
			COUNT(*)
		FROM
			reservation
		WHERE
			reservation.Flight_num = flightnumber
		) = 0
	THEN SET free = 40;
    ELSE 
		SELECT 
			SUM(Reserved_seats)
		INTO booked FROM
			reservation
		WHERE
			Reservation_number IN 
            (
            SELECT 
				Booking_num
			FROM
				booking
			)
        AND reservation.Flight_num = flightnumber;
	SET free = 40 - booked;
    END IF;
    RETURN free;
END &&
DELIMITER ;

# --------------------------- Function calculatePrice ------------------------
DELIMITER &&
CREATE FUNCTION calculatePrice(flightnumber INT) RETURNS DOUBLE
BEGIN
	DECLARE free_seats INT;
    DECLARE booked_seats INT;
    DECLARE route_price DOUBLE;
    DECLARE weekday_factor DOUBLE;
	DECLARE profit_factor DOUBLE;
    DECLARE total_price DOUBLE;


    SET free_seats = calculateFreeSeats(flightnumber);
    SET booked_seats = 40 - free_seats;

#-----------------------------------------------------------
	SELECT 
		route.Routeprice
	INTO route_price FROM
		route
	WHERE
		route.RouteID IN 
			(SELECT 
				weekly_schedule.RouteID
			FROM
				weekly_schedule
			WHERE
				weekly_schedule.ScheduleID IN 
					(SELECT 
						flight.ScheduleID
					FROM
						flight
					WHERE
						flight.Flightnumber = flightnumber)
			); 
#---------------------------------------------
	SELECT 
		weekday.Weekdayfactor
	INTO weekday_factor FROM
		weekday
	WHERE
		weekday.ID IN 
			(SELECT 
				weekly_schedule.WeekdayID
			FROM
				weekly_schedule
			WHERE
				weekly_schedule.ScheduleID IN 
					(SELECT 
						flight.ScheduleID
					FROM
						flight
					WHERE
						flight.Flightnumber = flightnumber)
			);
#-----------------------------------------------------------
	SELECT 
		year.Profitfactor
	INTO profit_factor FROM
		year
	WHERE
		year.Year IN 
			(SELECT 
				weekday.Year
			FROM
				weekday
			WHERE
				weekday.ID IN 
					(SELECT 
						weekly_schedule.WeekdayID
					FROM
						weekly_schedule
					WHERE
						weekly_schedule.ScheduleID IN 
							(SELECT 
								flight.ScheduleID
							FROM
								flight
							WHERE
								flight.Flightnumber = flightnumber)
					)
			);
#-----------------------------------------------------------
	SET total_price = (route_price * weekday_factor * ( ( booked_seats + 1 ) / 40 ) * profit_factor);
    RETURN total_price;
END &&
DELIMITER ;


# ------------------------------ Procedures ----------------------------------
SELECT ' Implementing Procedures Part 2 ' AS 'Message';

# --------------------------- Procedure addReservation ------------------------
DELIMITER &&
CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), 
IN year INT, IN week INT, IN day VARCHAR(10), IN time TIME, IN number_of_passengers INT, OUT output_reservation_nr INT)
BEGIN
	DECLARE flight_number INT;
    DECLARE free_seats INT;
    
    SELECT 
		flight.Flightnumber
	INTO flight_number FROM
		flight
	WHERE
		flight.ScheduleID IN 
			(SELECT 
				weekly_schedule.ScheduleID
			FROM
				weekly_schedule
			WHERE
				weekly_schedule.RouteID IN (SELECT 
						route.RouteID
					FROM
						route
					WHERE
						route.DEP_Airport_code = departure_airport_code
							AND route.ARR_Airport_code = arrival_airport_code) 
			)
        AND flight.ScheduleID IN 
			(SELECT 
				weekly_schedule.ScheduleID
			FROM
				weekly_schedule
			WHERE
				weekly_schedule.WeekdayID IN 
					(SELECT 
						weekday.ID
					FROM
						weekday
					WHERE
						weekday.Day = day AND weekday.Year = year)
			)
        AND flight.ScheduleID IN 
			(SELECT 
				weekly_schedule.ScheduleID
			FROM
				weekly_schedule
			WHERE
				weekly_schedule.Departure_Time = time)
        AND flight.Week = week;
# --------------------------------------------------
	IF flight_number = NULL
    THEN 
    SELECT ' There exist no flight for the given route, date and time ' AS 'Message';
    
    ELSEIF calculateFreeSeats(flight_number) < number_of_passengers 
	THEN 
    SELECT ' There are not enough seats available on the chosen flight ' AS 'Message';
    
    ELSE 
    INSERT INTO reservation (Reserved_seats, Flight_num) values (number_of_passengers, flight_number);
    SELECT last_insert_id() INTO output_reservation_nr; # it returns the first auto_increment value for the last inserted/updated table.
    END IF;
    
    
END &&
DELIMITER ;

# --------------------------- Procedure addPassenger ------------------------
DELIMITER &&
CREATE PROCEDURE addPassenger(IN reservation_nr INT, IN passport_number INT, IN name VARCHAR(30))
BEGIN
	IF EXISTS (SELECT * FROM books WHERE Book_num = reservation_nr)
    THEN 
    SELECT 'The booking has already been payed and no futher passengers can be added' AS 'Message';
    
	ELSEIF NOT EXISTS (SELECT * FROM reservation WHERE Reservation_number = reservation_nr)
	THEN
    SELECT 'The given reservation number does not exist' AS 'Message';
		
	ELSEIF NOT EXISTS (SELECT * FROM passenger WHERE passenger.Passport_number = passport_number)
    THEN
		INSERT INTO passenger VALUES (passport_number, name);
        INSERT INTO reservs VALUES (passport_number, reservation_nr);
	END IF;
    
END &&
DELIMITER ;


# --------------------------- Procedure addContact ------------------------
DELIMITER &&
CREATE PROCEDURE addContact(IN reservation_nr INT, IN passport_number INT, IN email VARCHAR(30), IN phone BIGINT)
BEGIN
	IF NOT EXISTS (SELECT * FROM reservs WHERE Reserv_num = reservation_nr AND Pass_num = passport_number)
    THEN 
    SELECT 'The person is not a passenger of the reservation' AS 'Message';
    ELSE 
    INSERT INTO contact VALUES (passport_number, phone, email);
    UPDATE reservation 
	SET 
		Contact_Pass_num = passport_number
	WHERE
		reservation.Reservation_number = reservation_nr;
    END IF;
    
    
END &&
DELIMITER ;


# --------------------------- Procedure addPayment ------------------------
DELIMITER &&
CREATE PROCEDURE addPayment(IN reservation_nr INT , IN cardholder_name VARCHAR(30), IN credit_card_number BIGINT)
BEGIN
	DECLARE flight INT;
    DECLARE passengers INT;
    DECLARE price DOUBLE;
    
    SELECT reservation.Flight_num INTO flight FROM reservation WHERE Reservation_number = reservation_nr; 
    SELECT Reserved_seats INTO passengers FROM reservation WHERE Reservation_number = reservation_nr;
    SET price = calculatePrice(flight);
    
    IF NOT EXISTS (SELECT * FROM reservation WHERE Reservation_number = reservation_nr)
    THEN
    SELECT 'The given reservation number does not exist' AS 'Message';
    
    ELSEIF (SELECT Contact_Pass_num FROM reservation WHERE Reservation_number = reservation_nr) = NULL
    THEN 
    SELECT 'The reservation has no contact yet' AS 'Message';
    
    ELSEIF calculateFreeSeats(flight) < passengers 
	THEN 
    SELECT 'There are not enough seats available on the flight anymore, deleting reservation' AS 'Message';
    
    ELSE #SELECT SLEEP (5);
		IF NOT EXISTS (SELECT * FROM payment WHERE Creditcard_number = credit_card_number)
        THEN
			INSERT INTO payment VALUES (credit_card_number, cardholder_name);
        END IF;
		INSERT INTO booking VALUES (reservation_nr, price, credit_card_number);
		UPDATE books SET Ticket_num =  FLOOR ( RAND() * ( 100 + 1 ) ) WHERE Book_num = reservation_nr;
    END IF;
END &&
DELIMITER ;


# ------------------------------ Views ----------------------------------
CREATE VIEW allFlights AS
    SELECT 
        Flight_From.Country AS departure_city_name,
        Flight_To.Country AS destination_city_name,
        weekly_schedule.Departure_Time AS departure_time,
        weekday.Day AS departure_day,
        flight.Week AS departure_week,
        weekday.Year AS departure_year,
        calculateFreeSeats(flight.Flightnumber) AS nr_of_free_seats,
        calculatePrice(flight.Flightnumber) AS current_price_per_seat
    FROM
        flight
            INNER JOIN
        weekly_schedule ON flight.ScheduleID = weekly_schedule.ScheduleID
            INNER JOIN
        weekday ON weekly_schedule.WeekdayID = weekday.ID
            INNER JOIN
        route ON weekly_schedule.RouteID = route.RouteID
            INNER JOIN
        airport AS Flight_From ON route.DEP_Airport_code = Flight_From.airport_code
            INNER JOIN
        airport AS Flight_To ON route.ARR_Airport_code = Flight_To.airport_code;




# ------------------------ Question 8 ------------------------
# 8a
# By encrypting the data.
# 8b 
# 1. Faster, since the clients doesn't need to store and compile the code/procedures, it's already done in the databsse.
# 2. They can be used by different applications without needing to having multiple copies of the same code.
# 3. They leads to more security because we can allow certain things and forbid other things.

# ------------------------ Question 9 ------------------------

# 9b
# No, because we didn't commit the transaction in session A.

# 9c
# Transaction in session B waits to transacation in session A to commit it's changes and therefore release the lock and make the changes permanent. 
# This happens because Transactions in MySQL are atomic, all or nothing, and everything happens inside the transaction is isolated from other transactions.
# If we don't commit the changes from transaction A the transaction B will time out. 


# ------------------------ Question 10 ------------------------

# 10a
# No, because there wasn't enough seats for the second booking.

#10b
# Yes, if first booking passes the if-statement : IF calculateFreeSeats(flight_number) < number_of_passengers but for some reason doesn't finish adding passengers,
# and therefore the second booking passes the if-statement as well, now both if them can add 21 passengers when the flight only has 40 seats to begin with. 

# 10c
# If we add SELECT sleep(5); before adding passengers (line 548) then the second booking will have enough time to pass the if-statement, 
# therefore overbooking will occur (second booking will have -2 as nr_of_free_seats). 

# 10d 
# Just added START TRANSACTION; at the beginning of the test-scripts and COMMIT; 
# at the end and it was enough to stop overbooking even when solution in 10c is implemented. 

# ----------------------------- Changes to EER-diagram and Relational database ------------------------------------------------------
# Many names were changed because we thought they have to be the same as "Variable" column in question 2
# Passenger's name and Creditcard_holder wasn't divided into first- and lastname as we thought from the beginnig 
# and therefore switched to only "name" and "Creditcard_holder"
# 


# ---------------------------------------- Second Index --------------------------------------
# Maybe Week in flight would be a good seconday index because usually a lot people travel in speceific weeks such as under the summer weeks. Thereofre being able to retrieve 
# all the flights under those weeks fast is good instead of searching through the whole table which contains many rows. 



