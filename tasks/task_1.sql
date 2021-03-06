DROP SCHEMA IF EXISTS motoservice CASCADE;
CREATE SCHEMA motoservice;


CREATE TABLE motoservice.departments (
  DEPARTMENT_ID INT PRIMARY KEY ,
  DEPARTAMENT_NAME VARCHAR(50) NOT NULL
);

CREATE TABLE motoservice.workers (
  WORKER_ID INT PRIMARY KEY ,
  WORKER_NAME VARCHAR(100) NOT NULL ,
  WORKER_BIRTHDAY DATE NOT NULL ,
  WORKER_INCOME INTEGER CHECK (WORKER_INCOME > 0),
  DEPARTMENT_ID INTEGER REFERENCES motoservice.departments(DEPARTMENT_ID)
);

CREATE TABLE motoservice.makers (
  MAKER_ID INTEGER PRIMARY KEY ,
  MAKER_NAME VARCHAR(50) NOT NULL
);

CREATE TABLE motoservice.vehicles (
  VEHICLE_ID INT PRIMARY KEY ,
  MAKER_ID INT REFERENCES motoservice.makers(MAKER_ID) ,
  VEHICLE_MODEL VARCHAR(100) NOT NULL ,
  WORKER_ID INT REFERENCES motoservice.workers(WORKER_ID)
);

CREATE TABLE motoservice.crashes (
  CRASH_ID INT PRIMARY KEY ,
  CRASH_NAME VARCHAR(50) NOT NULL ,
  CRASH_DESCRIPTION TEXT NOT NULL ,
  CRASH_COMPLEXITY INTEGER CHECK (CRASH_COMPLEXITY >= 0 and CRASH_COMPLEXITY <= 10) ,
  CRASH_FIXINGPRICE INTEGER CHECK (CRASH_FIXINGPRICE > 0)
);

CREATE TABLE motoservice.vehiclesCrashes (
  VEHICLE_ID INT REFERENCES motoservice.vehicles(VEHICLE_ID) ,
  CRASH_ID INT REFERENCES motoservice.crashes(CRASH_ID) ,
  PRIMARY KEY (VEHICLE_ID, CRASH_ID)
);

CREATE TABLE motoservice.clients (
  CLIENT_ID INT PRIMARY KEY ,
  CLIENT_NAME VARCHAR(50) NOT NULL ,
  CLIENT_REPORTS INTEGER CHECK(CLIENT_REPORTS > 0) ,
  CLIENT_RATING INTEGER CHECK (CLIENT_RATING >= 0)
);

CREATE TABLE motoservice.vehiclesClients (
  VEHICLE_ID INT REFERENCES motoservice.vehicles(VEHICLE_ID) ,
  CLIENTS_ID INT REFERENCES motoservice.clients(CLIENT_ID) ,
  PRIMARY KEY (VEHICLE_ID, CLIENTS_ID)
);
