DROP SCHEMA IF EXISTS motoservice CASCADE;
CREATE SCHEMA motoservice;


CREATE TABLE motoservice._department_ (
  DEPARTMENT_ID INT PRIMARY KEY ,
  DEPARTAMENT_NM VARCHAR(50) NOT NULL
);

CREATE TABLE motoservice._worker_ (
  WORKER_ID INT PRIMARY KEY ,
  WORKER_NM VARCHAR(100) NOT NULL ,
  WORKER_BIRTHDAY DATE NOT NULL ,
  WORKER_INCOME INTEGER CHECK (WORKER_INCOME > 0),
  DEPARTMENT_ID INTEGER REFERENCES motoservice._department_(DEPARTMENT_ID)
);

CREATE TABLE motoservice._makers_ (
  MAKER_ID INTEGER PRIMARY KEY ,
  MAKER_NM VARCHAR(50) NOT NULL
);

CREATE TABLE motoservice._vehicle_ (
  VEHICLE_ID INT PRIMARY KEY ,
  MAKER_ID INT REFERENCES motoservice._makers_(MAKER_ID) ,
  VEHICLE_MODEL VARCHAR(100) NOT NULL ,
  WORKER_ID INT REFERENCES motoservice._worker_(WORKER_ID)
);

CREATE TABLE motoservice._crash_ (
  CRASH_ID INT PRIMARY KEY ,
  CRASH_NM VARCHAR(50) NOT NULL ,
  CRASH_DESC TEXT NOT NULL ,
  CRASH_COMPLEXITY INTEGER CHECK (CRASH_COMPLEXITY >= 0 and CRASH_COMPLEXITY <= 10) ,
  CRASH_FIXINGPRICE INTEGER CHECK (CRASH_FIXINGPRICE > 0)
);

CREATE TABLE motoservice._vehicle_crash_ (
  VEHICLE_ID INT REFERENCES motoservice._vehicle_(VEHICLE_ID) ,
  CRASH_ID INT REFERENCES motoservice._crash_(CRASH_ID) ,
  PRIMARY KEY (VEHICLE_ID, CRASH_ID)
);

CREATE TABLE motoservice._client_ (
  CLIENT_ID INT PRIMARY KEY ,
  CLIENT_NM VARCHAR(50) NOT NULL ,
  CLIENT_REPORTS INTEGER CHECK(CLIENT_REPORTS > 0) ,
  CLIENT_RATING INTEGER CHECK (CLIENT_RATING >= 0)
);

CREATE TABLE motoservice._vehicle_client_ (
  VEHICLE_ID INT REFERENCES motoservice._vehicle_(VEHICLE_ID) ,
  CLIENTS_ID INT REFERENCES motoservice._client_(CLIENT_ID) ,
  PRIMARY KEY (VEHICLE_ID, CLIENTS_ID)
);

--------------------------------------------------------------------------------------------------------------

INSERT INTO motoservice._department_ (DEPARTMENT_ID, DEPARTAMENT_NM) VALUES
  (1, 'Engine recovery'),
  (2, 'Design recovery'),
  (3, 'Electricity recovery');

INSERT INTO motoservice._worker_ (WORKER_ID, WORKER_NM, WORKER_BIRTHDAY, WORKER_INCOME, DEPARTMENT_ID) VALUES
  (1, 'Konstantin Leladze', '2000-01-20', 59123, 1),
  (2, 'Viktor Krasnikov', '1999-10-19', 12043, 1),
  (3, 'Eugene Astafurov', '2000-01-12', 17538, 1),
  (4, 'Dmitry Palchikov', '2000-01-12', 8390, 2),
  (5, 'Ivan Vetoshkin', '2000-01-12', 13212, 2),
  (6, 'Arutyon Barsegyan', '2000-01-12', 1523, 2),
  (7, 'Dmitry Bahmetskiy', '2000-01-12', 6463, 3),
  (8, 'Alexander Galkin',  '2000-01-12', 12332, 3),
  (9, 'Vadim Politov', '2000-01-12', 5423, 3);

INSERT INTO motoservice._makers_ (MAKER_ID, MAKER_NM) VALUES
  (1, 'Suzuki'),
  (2, 'Yamaha'),
  (3, 'Kawasaki'),
  (4, 'BMW');

INSERT INTO motoservice._vehicle_ (VEHICLE_ID, MAKER_ID, VEHICLE_MODEL, WORKER_ID) VALUES
  (1, 2, 'YBR 150', 3),
  (2, 3, 'Ninja', 2),
  (3, 2, 'YBR 350', 1),
  (4, 4, 'g310r', 7),
  (5, 1, 'gsxr1000', 5);

INSERT INTO motoservice._crash_ (CRASH_ID, CRASH_NM, CRASH_DESC, CRASH_COMPLEXITY, CRASH_FIXINGPRICE) VALUES
  (1, 'Engine failure', '-', 9, 30000),
  (2, 'Startup failure', '-', 7, 15000),
  (3, 'Lights crash', '-', 3, 5000),
  (4, 'Cladding scrathed', '-', 5, 10000);

INSERT INTO motoservice._vehicle_crash_ (VEHICLE_ID, CRASH_ID) VALUES
  (1, 1),
  (2, 1),
  (2, 2),
  (3, 1),
  (4, 2),
  (4, 3),
  (5, 4);

INSERT INTO motoservice._client_ (CLIENT_ID, CLIENT_NM, CLIENT_REPORTS, CLIENT_RATING) VALUES
  (1, 'Dmitri Ershov', 5, 30000),
  (2, 'Fyodor Ivlev', 1, 20000),
  (3, 'Stepan Motskevitch', 3, 1);

INSERT INTO motoservice._vehicle_client_ (VEHICLE_ID, CLIENTS_ID) VALUES
  (1, 1),
  (2, 3),
  (3, 1),
  (4, 2),
  (5, 2);
