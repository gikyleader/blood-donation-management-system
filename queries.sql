-- Blood Bank Management System (Complete)

-- =========================
-- 5.1 CREATE TABLES
-- =========================

CREATE TABLE DONOR (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender IN ('M','F','O')),
    blood_group VARCHAR(5) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE BLOOD_BANK (
    bank_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    contact_number VARCHAR(15),
    email VARCHAR(100),
    capacity INT
);

CREATE TABLE DONATION (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    bank_id INT NOT NULL,
    donation_date DATE NOT NULL,
    quantity_ml INT NOT NULL,
    hiv_test VARCHAR(10) NOT NULL,
    hepatitis_test VARCHAR(10) NOT NULL,
    malaria_test VARCHAR(10) NOT NULL,
    test_result VARCHAR(10) NOT NULL,
    FOREIGN KEY (donor_id) REFERENCES DONOR(donor_id),
    FOREIGN KEY (bank_id) REFERENCES BLOOD_BANK(bank_id)
);

CREATE TABLE BLOOD_INVENTORY (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_id INT NOT NULL,
    blood_group VARCHAR(5) NOT NULL,
    quantity_units INT NOT NULL,
    collection_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Available',
    FOREIGN KEY (bank_id) REFERENCES BLOOD_BANK(bank_id)
);

CREATE TABLE HOSPITAL (
    hospital_id INT PRIMARY KEY AUTO_INCREMENT,
    hospital_name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    contact_number VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE BLOOD_REQUEST (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    hospital_id INT NOT NULL,
    bank_id INT NOT NULL,
    blood_group VARCHAR(5) NOT NULL,
    units_requested INT NOT NULL,
    request_date DATE NOT NULL,
    urgency VARCHAR(10) NOT NULL CHECK (urgency IN ('Low','Normal','Critical')),
    status VARCHAR(15) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (hospital_id) REFERENCES HOSPITAL(hospital_id),
    FOREIGN KEY (bank_id) REFERENCES BLOOD_BANK(bank_id)
);

CREATE TABLE RECIPIENT (
    recipient_id INT PRIMARY KEY AUTO_INCREMENT,
    hospital_id INT NOT NULL,
    patient_name VARCHAR(100) NOT NULL,
    blood_group VARCHAR(5) NOT NULL,
    age INT,
    medical_condition TEXT,
    admission_date DATE,
    FOREIGN KEY (hospital_id) REFERENCES HOSPITAL(hospital_id)
);

-- =========================
-- 5.2 INSERT DATA
-- =========================

INSERT INTO DONOR VALUES
(1,'Rahul','Sharma','1990-05-12','M','A+','9876543210','rahul@gmail.com','Delhi','2023-01-10'),
(2,'Priya','Verma','1995-08-22','F','B+','9123456780','priya@gmail.com','Mumbai','2023-02-15'),
(3,'Amit','Singh','1988-03-30','M','O+','9012345678','amit@gmail.com','Bangalore','2023-03-20'),
(4,'Sneha','Rao','2000-11-05','F','AB-','8901234567','sneha@gmail.com','Hyderabad','2023-04-25'),
(5,'Vikas','Gupta','1993-07-17','M','O-','8812345678','vikas@gmail.com','Chennai','2023-05-01');

INSERT INTO BLOOD_BANK VALUES
(1,'LifeLine Blood Bank','Connaught Place, Delhi','011-23456789','lifeline@bb.com',500),
(2,'RedCross Blood Center','Andheri, Mumbai','022-34567890','redcross@bb.com',800),
(3,'HealWell Blood Bank','Indiranagar, Bangalore','080-45678901','healwell@bb.com',400);

INSERT INTO DONATION VALUES
(1,1,1,'2023-06-01',450,'Negative','Negative','Negative','Safe'),
(2,2,1,'2023-06-05',450,'Negative','Negative','Negative','Safe'),
(3,3,2,'2023-06-10',450,'Negative','Negative','Negative','Safe'),
(4,4,2,'2023-06-15',450,'Negative','Positive','Negative','Unsafe'),
(5,5,3,'2023-06-20',450,'Negative','Negative','Negative','Safe');

INSERT INTO BLOOD_INVENTORY VALUES
(1,1,'A+',50,'2023-06-01','2023-09-01','Available'),
(2,1,'B+',30,'2023-06-05','2023-09-05','Available'),
(3,2,'O+',70,'2023-06-10','2023-09-10','Available'),
(4,2,'AB-',10,'2023-06-15','2023-09-15','Reserved'),
(5,3,'O-',25,'2023-06-20','2023-09-20','Available');

INSERT INTO HOSPITAL VALUES
(1,'AIIMS Delhi','Ansari Nagar, New Delhi','011-26588500','aiims@hospital.com'),
(2,'KEM Hospital','Parel, Mumbai','022-24107000','kem@hospital.com'),
(3,'Fortis Hospital','Bannerghatta, Bangalore','080-66214444','fortis@hospital.com');

INSERT INTO BLOOD_REQUEST VALUES
(1,1,1,'A+',10,'2023-07-01','Critical','Fulfilled'),
(2,2,2,'O+',15,'2023-07-03','Normal','Fulfilled'),
(3,3,3,'O-',5,'2023-07-05','Critical','Pending'),
(4,1,2,'B+',8,'2023-07-07','Low','Pending'),
(5,2,1,'AB-',3,'2023-07-10','Critical','Fulfilled');

INSERT INTO RECIPIENT VALUES
(1,1,'Mohan Das','A+',45,'Surgery','2023-07-01'),
(2,2,'Kamla Nair','O+',62,'Accident','2023-07-03'),
(3,3,'Raj Malhotra','O-',33,'Anemia','2023-07-05'),
(4,1,'Sita Devi','B+',55,'Cancer','2023-07-07'),
(5,2,'Arjun Kapoor','AB-',28,'Thalassemia','2023-07-10');

-- =========================
-- 5.3 ALL QUERIES
-- =========================

-- Query 1
SELECT D.donor_id,
CONCAT(D.first_name,' ',D.last_name) AS donor_name,
D.blood_group, DN.donation_date, DN.quantity_ml, DN.test_result
FROM DONOR D
JOIN DONATION DN ON D.donor_id = DN.donor_id
WHERE DN.test_result = 'Safe'
ORDER BY DN.donation_date;

-- Query 2
SELECT BB.bank_name, BI.blood_group,
SUM(BI.quantity_units) AS total_units, BI.status
FROM BLOOD_BANK BB
JOIN BLOOD_INVENTORY BI ON BB.bank_id = BI.bank_id
GROUP BY BB.bank_name, BI.blood_group, BI.status
ORDER BY BB.bank_name;

-- Query 3
SELECT BR.request_id, H.hospital_name, BB.bank_name,
BR.blood_group, BR.units_requested, BR.request_date, BR.status
FROM BLOOD_REQUEST BR
JOIN HOSPITAL H ON BR.hospital_id = H.hospital_id
JOIN BLOOD_BANK BB ON BR.bank_id = BB.bank_id
WHERE BR.urgency = 'Critical'
ORDER BY BR.request_date;

-- Query 4
SELECT BB.bank_name,
COUNT(DN.donation_id) AS total_donations,
SUM(DN.quantity_ml) AS total_ml_collected
FROM BLOOD_BANK BB
LEFT JOIN DONATION DN ON BB.bank_id = DN.bank_id
GROUP BY BB.bank_name;

-- Query 5
SELECT D.donor_id,
CONCAT(D.first_name,' ',D.last_name) AS donor_name,
D.blood_group, D.registration_date
FROM DONOR D
LEFT JOIN DONATION DN ON D.donor_id = DN.donor_id
WHERE DN.donation_id IS NULL;

-- Query 6
SELECT R.recipient_id, R.patient_name, R.blood_group,
R.age, H.hospital_name, R.medical_condition, R.admission_date
FROM RECIPIENT R
JOIN HOSPITAL H ON R.hospital_id = H.hospital_id;

-- Query 7
SELECT BB.bank_name, BI.blood_group,
BI.quantity_units, BI.expiry_date
FROM BLOOD_INVENTORY BI
JOIN BLOOD_BANK BB ON BI.bank_id = BB.bank_id
WHERE BI.quantity_units < 20;

-- Query 8
SELECT D.donor_id,
CONCAT(D.first_name,' ',D.last_name) AS donor_name,
D.blood_group,
COUNT(DN.donation_id) AS times_donated
FROM DONOR D
JOIN DONATION DN ON D.donor_id = DN.donor_id
WHERE DN.test_result = 'Safe'
GROUP BY D.donor_id, donor_name, D.blood_group
ORDER BY times_donated DESC;
