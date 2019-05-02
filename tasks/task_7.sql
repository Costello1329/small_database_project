DROP SCHEMA IF EXISTS motoservice CASCADE;
CREATE SCHEMA motoservice;


CREATE TABLE motoservice._department_ (
  DEPARTMENT_ID INT PRIMARY KEY ,
  DEPARTMENT_NM VARCHAR(50) NOT NULL
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
  CLIENT_PASSPORT VARCHAR(10) NOT NULL ,
  CLIENT_REPORTS INTEGER CHECK(CLIENT_REPORTS > 0) ,
  CLIENT_RATING INTEGER CHECK (CLIENT_RATING >= 0)
);

CREATE TABLE motoservice._vehicle_client_ (
  VEHICLE_ID INT REFERENCES motoservice._vehicle_(VEHICLE_ID) ,
  CLIENTS_ID INT REFERENCES motoservice._client_(CLIENT_ID) ,
  PRIMARY KEY (VEHICLE_ID, CLIENTS_ID)
);

--------------------------------------------------------------------------------------------------------------

INSERT INTO motoservice._department_ (DEPARTMENT_ID, DEPARTMENT_NM) VALUES
  (1, 'Engine recovery'),
  (2, 'Design recovery'),
  (3, 'Electricity recovery');

INSERT INTO motoservice._worker_ (WORKER_ID, WORKER_NM, WORKER_BIRTHDAY, WORKER_INCOME, DEPARTMENT_ID) VALUES
  (1, 'Konstantin Leladze', '2000-01-20', 59123, 1),
  (2, 'Viktor Krasnikov', '1999-10-19', 12043, 1),
  (3, 'Eugene Astafurov', '1999-09-01', 17538, 1),
  (4, 'Dmitry Palchikov', '1999-03-09', 8390, 2),
  (5, 'Ivan Vetoshkin', '1999-01-29', 13212, 2),
  (6, 'Arutyon Barsegyan', '1999-08-21', 1523, 2),
  (7, 'Dmitry Bahmetskiy', '1999-04-21', 6463, 3),
  (8, 'Ruslan Alishaev',  '1998-10-24', 12332, 3),
  (9, 'Vadim Politov', '1999-11-04', 5423, 3);

INSERT INTO motoservice._makers_ (MAKER_ID, MAKER_NM) VALUES
  (1, 'Suzuki'),
  (2, 'Yamaha'),
  (3, 'Kawasaki'),
  (4, 'BMW');

INSERT INTO motoservice._vehicle_ (VEHICLE_ID, MAKER_ID, VEHICLE_MODEL, WORKER_ID) VALUES
  (1, 2, 'YBR 150', 3),
  (2, 3, 'Ninja 650', 2),
  (3, 2, 'YBR 350', 1),
  (4, 4, 'g310r', 7),
  (5, 1, 'gsxr1000', 5),
  (6, 3, 'Z10000SX', 9);

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
  (5, 4),
  (5, 3);

INSERT INTO motoservice._client_ (CLIENT_ID, CLIENT_NM, CLIENT_PASSPORT, CLIENT_REPORTS, CLIENT_RATING) VALUES
  (1, 'Dmitri Ershov', '0000123456', 5, 30000),
  (2, 'Fyodor Ivlev', '0000123456', 1, 20000),
  (3, 'Strapon Motskevitch', '0000123456', 3, 1);

INSERT INTO motoservice._vehicle_client_ (VEHICLE_ID, CLIENTS_ID) VALUES
  (1, 1),
  (2, 3),
  (3, 1),
  (4, 2),
  (5, 2);

--------------------------------------------------------------------------------------------------------------
/*
SELECT *
  FROM motoservice._department_;

SELECT motoservice._vehicle_.VEHICLE_MODEL
  FROM motoservice._vehicle_
 WHERE motoservice._vehicle_.MAKER_ID = 3;

UPDATE motoservice._makers_
   SET MAKER_ID = MAKER_ID;

SELECT *
  FROM motoservice._worker_;

UPDATE motoservice._worker_
   SET WORKER_INCOME = WORKER_INCOME + 100000;

SELECT *
  FROM motoservice._worker_;

SELECT *
  FROM motoservice._vehicle_;

DELETE
  FROM motoservice._vehicle_
 WHERE VEHICLE_MODEL = 'Z10000SX';

SELECT *
  FROM motoservice._vehicle_;

SELECT WORKER_NM, WORKER_INCOME, DEPARTMENT_NM
  FROM (SELECT * FROM motoservice._worker_ ORDER BY WORKER_INCOME DESC) AS TMP
       INNER JOIN motoservice._department_ ON motoservice._department_.DEPARTMENT_ID = TMP.DEPARTMENT_ID;

--------------------------------------------------------------------------------------------------------------

-- В результате запроса таблица сотрудников будет выведена по убыванию их прибыли.
SELECT *
  FROM motoservice._worker_
 ORDER BY WORKER_INCOME;

-- В результате запроса будет выведена таблица с отделами, средняя прибыль по которым выше средней прибыли по всему мотосервису.
SELECT DEPARTMENT_ID, AVG(WORKER_INCOME) AS AVG_DPT_INCOME
  FROM motoservice._worker_
 GROUP BY DEPARTMENT_ID
HAVING AVG(WORKER_INCOME) >= (SELECT AVG(WORKER_INCOME) FROM motoservice._worker_)
 ORDER BY AVG_DPT_INCOME;

-- В результате запроса получим среднюю прибыль для каждого отдела.
SELECT DEPARTMENT_ID, AVG(WORKER_INCOME) AS AVG_INCOME
  FROM motoservice._worker_
 GROUP BY DEPARTMENT_ID
 ORDER BY AVG_INCOME;

-- В результате запроса таблица клиентов будет выведена по возрастанию их рейтинга.
SELECT *
  FROM motoservice._client_
 ORDER BY CLIENT_RATING;

-- Агрегирующая ф-ция
-- В результате запроса получим разницу между прибылью сотрудника и средней прибылью отдела, в котором он работает.
SELECT *, WORKER_INCOME - AVG(WORKER_INCOME)
  OVER (PARTITION BY DEPARTMENT_ID) AS INCOME_DELTA
  FROM motoservice._worker_
 ORDER BY INCOME_DELTA;

-- Ранжирующая ф-ция
-- "Разбить" таблицу работников на другие таблицы, присваивая каждой строке новый номер строки в другой таблице, где в одной таблице работники из одного отдела, отсортированные по прибыли
SELECT *,
ROW_NUMBER() OVER(PARTITION BY DEPARTMENT_ID ORDER BY WORKER_INCOME DESC) AS ROW_NUM
  FROM motoservice._worker_;

-- Смещающая ф-ция
-- Для каждого отдела сопоставляем каждому работнику следующую по величине прибыль и предыдущую
SELECT *,
   LAG (WORKER_NM) OVER(PARTITION BY DEPARTMENT_ID ORDER BY WORKER_INCOME) AS PREV_INCOME,
  LEAD (WORKER_NM) OVER(PARTITION BY DEPARTMENT_ID ORDER BY WORKER_INCOME) AS NEXT_INCOME
  FROM motoservice._worker_;

--------------------------------------------------------------------------------------------------------------

-- Список сотрудников мотосервиса с скрытой датой рождения.
CREATE OR REPLACE VIEW motoservice.workers_view AS (
   SELECT WORKER_NM,
          --OVERLAY(WORKER_BIRTHDAY placing repeat('*', char_length(WORKER_BIRTHDAY)) from 1 for char_length(WORKER_BIRTHDAY)) AS birthday,
          DEPARTMENT_NM
     FROM (SELECT * FROM motoservice._worker_ ORDER BY WORKER_INCOME DESC) AS TMP
    INNER JOIN motoservice._department_
       ON motoservice._department_.DEPARTMENT_ID = TMP.DEPARTMENT_ID
);

-- Список клиентов с сокрытием персональных данных.
CREATE OR REPLACE VIEW motoservice.clients_personal_data AS (
   SELECT CLIENT_NM AS name,
          OVERLAY(CLIENT_PASSPORT placing repeat('*', char_length(CLIENT_PASSPORT)) from 1 for char_length(CLIENT_PASSPORT)) AS password,
          CLIENT_REPORTS AS reports
     FROM motoservice._client_
 ORDER BY CLIENT_RATING
);

-- Список мотоциклов в ремонте по производителям.
CREATE OR REPLACE VIEW motoservice.moto_makers AS (
  SELECT MAKER_NM, VEHICLE_MODEL
    FROM (SELECT * FROM motoservice._makers_) AS TMP
   INNER JOIN motoservice._vehicle_
      ON motoservice._vehicle_.MAKER_ID = TMP.MAKER_ID
);

-- Список поломок мотоциклов Kawasaki в ремонте.
CREATE OR REPLACE VIEW motoservice.moto_kawasaki_crashes AS (
  SELECT VEHICLE_ID, VEHICLE_MODEL, CRASH_NM as crashName
    FROM (SELECT VEHICLE_ID, VEHICLE_MODEL, CRASH_ID as crashId
            FROM (SELECT VEHICLE_ID AS vehicleId, VEHICLE_MODEL
                   FROM (SELECT * FROM motoservice._makers_) AS TMP
                  INNER JOIN motoservice._vehicle_
                     ON motoservice._vehicle_.MAKER_ID = TMP.MAKER_ID
                  WHERE MAKER_NM LIKE 'Kawasaki') AS TMP
           INNER JOIN motoservice._vehicle_crash_
              ON motoservice._vehicle_crash_.VEHICLE_ID = TMP.vehicleId) AS TMP
    INNER JOIN motoservice._crash_
       ON motoservice._crash_.CRASH_ID = TMP.crashId
);

-- Список всех мотоциклов в ремонте со сломанным двигателем.
CREATE OR REPLACE VIEW motoservice.moto_crashes AS (
  SELECT VEHICLE_ID, VEHICLE_MODEL
    FROM (SELECT VEHICLE_ID, VEHICLE_MODEL, CRASH_ID as crashId
            FROM (SELECT VEHICLE_ID AS vehicleId, VEHICLE_MODEL
                   FROM (SELECT * FROM motoservice._makers_) AS TMP
                  INNER JOIN motoservice._vehicle_
                     ON motoservice._vehicle_.MAKER_ID = TMP.MAKER_ID) AS TMP
           INNER JOIN motoservice._vehicle_crash_
              ON motoservice._vehicle_crash_.VEHICLE_ID = TMP.vehicleId) AS TMP
    INNER JOIN motoservice._crash_
       ON motoservice._crash_.CRASH_ID = TMP.crashId
    WHERE CRASH_NM LIKE 'Engine failure'
);
*/
--------------------------------------------------------------------------------------------------------------

-- Возвращает работников с з/п > f1, но < f2
CREATE FUNCTION motoservice.worker_income_in_range(f1 int, f2 int)
RETURNS TABLE(worker_nm varchar(50), worker_income int) AS $$
SELECT worker_nm,
       worker_income
FROM   MOTOSERVICE._worker_
WHERE  WORKER_INCOME >= f1
AND    WORKER_INCOME <= f2 $$
LANGUAGE SQL;

SELECT *
FROM MOTOSERVICE.worker_income_in_range(20000, 100000);

-- Возвращает кол-во мотоциклов, с типом краша crash_id
CREATE OR REPLACE FUNCTION
  MOTOSERVICE.count_crashes(crash_id INT)
  RETURNS bigint AS $$
  SELECT COUNT(_vehicle_crash_)
  FROM MOTOSERVICE._vehicle_crash_
  WHERE crash_id = CRASH_ID $$
  LANGUAGE SQL;

SELECT
motoservice.count_crashes(100);

--------------------------------------------------------------------------------------------------------------
