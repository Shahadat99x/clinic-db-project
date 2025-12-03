create database courseproject
use courseproject;

CREATE TABLE Patients (
	PatientID INT IDENTITY(1,1) PRIMARY KEY,
	NAME NVARCHAR(255) NOT NULL,
	Phone NVARCHAR(50) UNIQUE NOT NULL,
	Email NVARCHAR(50),
	DateOfBirth Date,
	Address NVARCHAR(255),
	RegistrationDate Date NOT NULL
);

select*from Patients

CREATE TABLE Doctors(
	DoctorID INT IDENTITY(1,1) PRIMARY KEY,
	NAME NVARCHAR(255) NOT NULL,
	Phone NVARCHAR(50) UNIQUE NOT NULL,
	Email NVARCHAR(50)UNIQUE,
	Qualification NVARCHAR(100),
	Experience INT,
	JoinDate DATE
);

SELECT*FROM Patients


CREATE TABLE Specialization(
	SpecializationID INT IDENTITY(1,1) PRIMARY KEY,
	SpecializationName NVARCHAR(50) NOT NULL
);

CREATE TABLE DoctorSpecializations(
	DocSpecID INT IDENTITY(1,1) PRIMARY KEY,
	DoctorID INT  NOT NULL,
	SpecializationID INT  NOT NULL,
	UNIQUE (DoctorID, SpecializationID),
	FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
	FOREIGN KEY (SpecializationID) REFERENCES Specialization(SpecializationID)
);

select*from DoctorSpecializations

CREATE TABLE Appointments(
	AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
	PatientID INT NOT NULL,
	DoctorID INT NOT NULL,
	AppointmentDate DATE NOT NULL,
	AppointmentTime TIME NOT NULL,
	Status NVARCHAR(50) NOT NULL,
	FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
	FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
	
	);

select*from Appointments

CREATE TABLE Payments(
	PaymentID INT IDENTITY(1,1) PRIMARY KEY,
	AppointmentID INT NOT NULL UNIQUE,
	Amount DECIMAL(10,2) NOT NULL,
	PaymentDate DATE NOT NULL DEFAULT GETDATE(),
	PaymentMethod NVARCHAR(50) NOT NULL,
	FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

SELECT*FROM Payments
--DROP TABLE Payments -- for test



INSERT INTO Patients (Name, Phone, Email, DateOfBirth, Address, RegistrationDate)
VALUES
    ('JARIN', '+37067984625', 'Jarin@email.com', '2001-02-01', 'Vilnius', '2025-11-25'),
    ('Vishal', '+37069842687', 'vc@email.com', '2002-02-28', 'Vilnius', '2025-11-20'),
    ('Monika P', '+37061234567', 'monika.p@gmail.com', '1995-07-14', 'Kaunas', '2025-11-10'),
    ('Arnas Jan', '+37064588912', 'arnas.j@inbox.lt', '1988-03-22', 'Vilnius', '2025-11-18'),
    ('Elena', '+37067334455', 'elena.k@mail.com', '2000-11-05', 'Klaipeda', '2025-11-17');


INSERT INTO Doctors (Name, Phone, Email, Qualification, Experience, JoinDate)
VALUES
    ('Dr. Tomas Petrauskas', '+37060011223', 'tomas.p@clinic.lt', 'Cardiologist', 12, '2018-04-12'),
    ('Dr. Jurga Milkaite', '+37061122334', 'jurga.m@clinic.lt', 'Dermatologist', 8, '2020-06-09'),
    ('Dr. Jonas Stanius', '+37062233445', 'jonas.s@clinic.lt', 'General Practitioner', 15, '2015-02-20'),
    ('Dr. Inga Rimkute', '+37063344556', 'inga.r@clinic.lt', 'Pediatrician', 10, '2019-07-14'),
    ('Dr. Karolis Sabonis', '+37064455667', 'karolis.s@clinic.lt', 'ENT Specialist', 7, '2021-03-03');

INSERT INTO Specialization (SpecializationName)
VALUES
    ('Cardiology'),
    ('Dermatology'),
    ('General Medicine'),
    ('Pediatrics'),
    ('ENT'),
    ('Dental Medicine'),
    ('Physiotherapy');


INSERT INTO DoctorSpecializations (DoctorID, SpecializationID)
VALUES
    (1, 1), -- Tomas ? Cardiology
    (3, 3),  -- Jonas ? General Medicine
    (2, 2),  -- Jurga ? Dermatology
    (4, 4),  -- Inga ? Pediatrics
    (5, 5),  -- Karolis ? ENT
    (3, 7);  -- Jonas ? Physiotherapy (multi-specialty)


	UPDATE DoctorSpecializations    -----testing perpose or Delte form... then insert again
SET SpecializationID = 3
WHERE DoctorID = 1 AND SpecializationID = 1;


SELECT * FROM Patients;
SELECT * FROM Doctors;
SELECT * FROM Specialization;


INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status)
VALUES
    (1, 2, '2025-11-26', '10:30', 'Scheduled'),
    (2, 1, '2025-11-27', '14:15', 'Scheduled'),
    (3, 3, '2025-11-28', '09:00', 'Completed'),
    (4, 4, '2025-11-29', '11:45', 'Cancelled'),
    (5, 5, '2025-11-30', '16:00', 'Scheduled');


INSERT INTO Payments (AppointmentID, Amount, PaymentMethod)
VALUES
    (3, 25.00, 'Card'),
    (1, 30.00, 'Cash'),
    (5, 20.00, 'Card');

CREATE INDEX IDX_PAYmentandPaymenttable 
ON Payments (PaymentDate);


--SET SHOWPLAN_ALL ON;

SELECT * 
FROM Payments
WHERE PaymentDate > '2025-11-01';

--SET SHOWPLAN_ALL OFF;

--Update task

select * from Patients

UPDATE Patients
SET Phone = '+37066545'
WHERE Name = 'JARIN';

DELETE FROM Patients
WHERE PatientID = 6;

--INSERT INTO Patients (Name, Phone, Email, DateOfBirth, Address, RegistrationDate)
--VALUES ('Badsha Temp', '+37060000000', 'temp@email.com', '2000-01-01', 'Test Address', GETDATE());


CREATE TABLE TEMPFORTRUNCATE(
	ID INT,
	NAME NVARCHAR(50));

INSERT INTO TEMPFORTRUNCATE( ID, NAME)
	VALUES(1,'TEMP');

SELECT * FROM TEMPFORTRUNCATE


TRUNCATE TABLE TEMPFORTRUNCATE;

--3query1count,group by



SELECT Doctors.Name, COUNT(Appointments.AppointmentID)
FROM Appointments
INNER JOIN Doctors
ON Appointments.DoctorID = Doctors.DoctorID
GROUP BY Doctors.Name;

--query2

SELECT Specialization.SpecializationName As Specialization,
COUNT(DoctorSpecializations.DoctorID) AS DoctorCount
FROM DoctorSpecializations
INNER JOIN Specialization
	ON DoctorSpecializations.SpecializationID = Specialization.SpecializationID

GROUP BY Specialization.SpecializationName
ORDER BY Specialization.SpecializationName ASC;

--query3 PAGINATION

SELECT * FROM Patients --offset,fetch is modern way
ORDER BY NAME
OFFSET 0 ROWS 
FETCH NEXT 3 ROWS ONLY;

SELECT TOP 3 * FROM Patients ORDER BY NAME;  -- this is also way

--query4 sum,avg

SELECT
	Doctors.NAME AS DOCTORNAME,
	SUM(PAYMENTS.AMOUNT) AS TOTALREVENUE,
	AVG(PAYMENTS.AMOUNT)AS AVERAGEPAYMENT	
FROM Payments
INNER JOIN Appointments
 ON Payments.AppointmentID = Appointments.AppointmentID
 INNER JOIN Doctors
	ON Appointments.DoctorID = Doctors.DoctorID
GROUP BY DOCTORS.NAME
ORDER BY TOTALREVENUE DESC;

--task4 
-- left join app. and patients table


SELECT
    Patients.Name,
    Appointments.AppointmentDate,
    Appointments.Status
FROM Patients
LEFT JOIN Appointments
    ON Patients.PatientID = Appointments.PatientID;

--join 3 table pa+app+doc

SELECT
Patients.NAME AS PATIENTNAME,
Doctors.NAME AS DOCTORNAME, 
Appointments.AppointmentDate
FROM Appointments
INNER JOIN Patients 
	ON Appointments.PatientID = Patients.PatientID
INNER JOIN Doctors 
	ON Appointments.DoctorID = Doctors.DoctorID;

--CREATE view

CREATE VIEW vw_AppointmentsDetails AS
SELECT
	 Patients.NAME AS PatientName,
	 Doctors.NAME AS DOCTORNAME,
	 Appointments.AppointmentDate,
	 Appointments.Status
FROM Appointments
INNER JOIN Patients ON Appointments.PatientID = Patients.PatientID
INNER JOIN Doctors ON Appointments.DoctorID = Doctors.DoctorID

SELECT * FROM vw_AppointmentsDetails; --check 

--task 5 
--store procedure

CREATE PROCEDURE sp_AddPatient
	@name NVARCHAR(255),
	@Phone NVARCHAR(50),
	@Email NVARCHAR(50),
	@DateOfBirth Date,
	@Address NVARCHAR(255)
AS
BEGIN
	INSERT INTO Patients (NAME, Phone, Email, DateOfBirth, Address, RegistrationDate)
		VALUES(@name, @Phone, @Email, @DateOfBirth, @Address, GETDATE());
END;

EXEC sp_AddPatient
	@NAME = 'Badsha F',
	@Phone = '+37098746325',
	@Email = 'badsha@email.com',
	@DateOfBirth = '2000-02-10',
	@Address = 'Vilnius';

SELECT * FROM Patients; --CHECK

--SQL FUNCTION calculate age

CREATE FUNCTION CalculateAge (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DateOfBirth, GETDATE());
END;

SELECT dbo.CalculateAge('2000-05-10') as AGE; -- specific date 


SELECT											-- from whole table
    Name, 
    dbo.CalculateAge(DateOfBirth) AS Age
FROM Patients;


--sql trigger

CREATE TABLE PaymentsLog (				--LOG TABLE
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentID INT,
    AppointmentID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    PaymentMethod NVARCHAR(50),
    LogDate DATETIME
);

SELECT * FROM PaymentsLog; --chk

CREATE TRIGGER tr_LOGNewPayments
ON Payments
AFTER INSERT
AS 
BEGIN
	INSERT INTO PaymentsLog (PaymentID, AppointmentID, Amount, PaymentDate, PaymentMethod, LogDate)
SELECT 
    PaymentID,
    AppointmentID,
    Amount,
    PaymentDate,
    PaymentMethod,
    GETDATE()
FROM inserted;
END;

---insert new date for show in log 


INSERT INTO Payments (AppointmentID, Amount, PaymentMethod)  --chek table before
VALUES (4, 45.00, 'Cash');

SELECT * FROM PaymentsLog; -- result

----manual transaction

BEGIN TRAN;

DECLARE @NewAppointmentID INT;

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status) -- insert new app
VALUES (1, 2, '2025-12-10', '10:00', 'Scheduled');

SET @NewAppointmentID = SCOPE_IDENTITY(); -- capture new appid

INSERT INTO Payments (AppointmentID, Amount, PaymentMethod)			--insert pamnt
VALUES (@NewAppointmentID, 30.00, 'Card'); 


--COMMIT;

--ROLLBACK;




-- Check
SELECT * FROM Appointments WHERE AppointmentID = @NewAppointmentID;
SELECT * FROM Payments WHERE AppointmentID = @NewAppointmentID;








	