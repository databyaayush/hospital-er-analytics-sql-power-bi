-- Create the database for the hospital
CREATE DATABASE hospital_er;

-- USE the Database
USE hospital_er;

-- Create the table 
DROP TABLE IF EXISTS dataset;
CREATE TABLE dataset(
	patient_id VARCHAR(20),
    add_date DATE,
    patient_first_initial VARCHAR(10),
    patient_last_name VARCHAR(20),
    gender varchar(10),
    age INT,
    race VARCHAR(100),
    referral VARCHAR(20),
    add_flag BOOLEAN,
    satisfaction_score INT,
    patient_wait_time INT
);

