---------------------------------------------
-- Amber Turner (aet34)
-- Trinity Key (tzk1)
-- HW2 for CS1555 Fall 2021
-- SQL (DDL and DML) Questions (1-3)
---------------------------------------------
DROP TABLE IF EXISTS FOREST CASCADE;
CREATE TABLE FOREST(
    forest_no varchar (10) NOT NULL,
    name varchar (30),
    area real,
    acid_level real,
    mbr_xmin real,
    mbr_xmax real,
    mbr_ymin real,
    mbr_ymax real,
    CONSTRAINT forest_no_pk
        PRIMARY KEY(forest_no)
);
ALTER TABLE FOREST ADD CONSTRAINT forest_name_un UNIQUE (name);
---------------------------------------------
-- Question #2c:
---------------------------------------------
ALTER TABLE FOREST ADD CHECK (acid_level>=0 and acid_level<=1);

--INSERT STATEMENTS
INSERT INTO FOREST VALUES ('1','Allegheny National Forest',3500,0.31,20,90,10,60);
INSERT INTO FOREST VALUES ('2','Pennsylvania Forest',2700,0.74,40,70,20,110);
INSERT INTO FOREST VALUES ('3','Stone Valley',5000,0.56,60,160,30,80);
INSERT INTO FOREST VALUES ('4','Big Woods',3000,0.92,150,180,20,120);
INSERT INTO FOREST VALUES ('5','Crooked Forest',2400,0.23,100,140,70,130);
---------------------------------------------

DROP TABLE IF EXISTS STATE CASCADE;
CREATE TABLE STATE (
    name varchar (30),
    abbreviation varchar (2) NOT NULL ,
    area real,
    population integer,
    CONSTRAINT abbreviation_pk
        PRIMARY KEY (abbreviation)
);
ALTER TABLE STATE ADD CONSTRAINT state_name_un UNIQUE (name);

--INSERT STATEMENTS
INSERT INTO STATE (name, abbreviation, area, population) VALUES ('Pennsylvania', 'PA', '50000', '14000000');
INSERT INTO STATE (name, abbreviation, area, population) VALUES ('Ohio', 'OH', '45000', '12000000');
INSERT INTO STATE (name, abbreviation, area, population) VALUES ('Virginia', 'VA', '35000', '10000000');
---------------------------------------------

DROP TABLE IF EXISTS COVERAGE CASCADE;
CREATE TABLE COVERAGE (
    --no alternate key
    forest_no varchar(10) NOT NULL,
    state varchar(2),
    percentage real,
    area real,
    CONSTRAINT forest_no_fk
        -- foreign key has nothing to do with alternate keys
        -- alternate keys have to do with the uniqueness
        -- percentage and area are not unique
        FOREIGN KEY (forest_no) REFERENCES FOREST(forest_no),
    CONSTRAINT state_fk
        FOREIGN KEY (state) REFERENCES STATE(abbreviation)
);

--INSERT STATEMENTS
INSERT INTO COVERAGE VALUES (1,'OH',1,3500);
INSERT INTO COVERAGE VALUES (2,'OH',1,2700);
INSERT INTO COVERAGE VALUES (3,'OH',0.3,1500);
INSERT INTO COVERAGE VALUES (3,'PA',0.42,2100);
INSERT INTO COVERAGE VALUES (3,'VA',0.28,1400);
INSERT INTO COVERAGE VALUES (4,'PA',0.4,1200);
INSERT INTO COVERAGE VALUES (4,'VA',0.6,1800);
INSERT INTO COVERAGE VALUES (5,'VA',1,2400);
---------------------------------------------

DROP TABLE IF EXISTS ROAD CASCADE;
CREATE TABLE ROAD(
    road_no varchar (10) NOT NULL,
    name varchar (30),
    length real,
    CONSTRAINT road_no_pk
        PRIMARY KEY (road_no)
);
ALTER TABLE ROAD ADD CONSTRAINT road_name_un UNIQUE (name);

--INSERT STATEMENTS
INSERT INTO ROAD VALUES (1,'Forbes',500);
INSERT INTO ROAD VALUES (2,'Bigelow',300);
INSERT INTO ROAD VALUES (3,'Bayard',555);
INSERT INTO ROAD VALUES (4,'Grant',100);
INSERT INTO ROAD VALUES (5,'Carson',150);
INSERT INTO ROAD VALUES (6,'Greatview',180);
INSERT INTO ROAD VALUES (7,'Beacon',333);
---------------------------------------------

DROP TABLE IF EXISTS INTERSECTION CASCADE;
CREATE TABLE INTERSECTION(
-- no alternate key
    forest_no varchar (10),
    road_no varchar (10),
    CONSTRAINT intersection_pk
        PRIMARY KEY (forest_no, road_no),
     CONSTRAINT forest_no_fk
        FOREIGN KEY (forest_no) REFERENCES FOREST(forest_no),
    CONSTRAINT road_no_fk
        FOREIGN KEY (road_no) REFERENCES ROAD(road_no)
);

--INSERT STATEMENTS
INSERT INTO INTERSECTION VALUES (1,1);
INSERT INTO INTERSECTION VALUES (1,2);
INSERT INTO INTERSECTION VALUES (1,4);
INSERT INTO INTERSECTION VALUES (1,7);
INSERT INTO INTERSECTION VALUES (2,1);
INSERT INTO INTERSECTION VALUES (2,4);
INSERT INTO INTERSECTION VALUES (2,5);
INSERT INTO INTERSECTION VALUES (2,6);
INSERT INTO INTERSECTION VALUES (2,7);
INSERT INTO INTERSECTION VALUES (3,3);
INSERT INTO INTERSECTION VALUES (3,5);
INSERT INTO INTERSECTION VALUES (4,4);
INSERT INTO INTERSECTION VALUES (4,5);
INSERT INTO INTERSECTION VALUES (4,6);
INSERT INTO INTERSECTION VALUES (5,1);
INSERT INTO INTERSECTION VALUES (5,3);
INSERT INTO INTERSECTION VALUES (5,5);
INSERT INTO INTERSECTION VALUES (5,6);
---------------------------------------------

DROP TABLE IF EXISTS WORKER CASCADE;
 CREATE TABLE WORKER(
    ssn varchar (9),
    name varchar (30),
    rank integer,
    CONSTRAINT ssn_pk
        PRIMARY KEY (ssn)
);
---------------------------------------------
-- Question #2d:
---------------------------------------------
ALTER TABLE WORKER ADD CONSTRAINT name_un UNIQUE (name);
ALTER TABLE WORKER ADD employing_state varchar(2);
---------------------------------------------
-- Question #3b:
---------------------------------------------
INSERT INTO WORKER  VALUES ('123321456','Maria',3,'OH');

--INSERT STATEMENTS
INSERT INTO WORKER (ssn, name,  rank, employing_state) VALUES ('123456789','John',6, 'OH');
INSERT INTO WORKER (ssn, name,  rank, employing_state) VALUES ('121212121','Jason',5,'PA');
INSERT INTO WORKER (ssn, name,  rank, employing_state) VALUES ('222222222','Mike',4,'OH');
INSERT INTO WORKER (ssn, name,  rank, employing_state) VALUES ('333333333','Tim',2,'VA');
---------------------------------------------

DROP TABLE IF EXISTS SENSOR CASCADE;
CREATE TABLE SENSOR(
    --no alternate key
    sensor_id integer,
    x real,
    y real,
    last_charged timestamp,
    maintainer varchar (9),
    last_read timestamp,
    CONSTRAINT sensor_id_pk
        PRIMARY KEY (sensor_id),
     CONSTRAINT maintainer_fk
         FOREIGN KEY (maintainer) REFERENCES WORKER(ssn)
);

---------------------------------------------
-- Question #2b:
---------------------------------------------
DROP DOMAIN IF EXISTS energy_dom CASCADE;
ALTER TABLE SENSOR add energy integer;
CREATE DOMAIN energy_dom AS INTEGER CHECK (value >= 0 and value <=100);
ALTER TABLE SENSOR ALTER COLUMN energy TYPE energy_dom;

--INSERT STATEMENTS
INSERT INTO SENSOR VALUES (1,33,29,TO_TIMESTAMP('6/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),'123456789',TO_TIMESTAMP('12/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO SENSOR VALUES (2,78,24,TO_TIMESTAMP('7/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),8);
INSERT INTO SENSOR VALUES (3,51,51,TO_TIMESTAMP('9/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/9/2020 8:25', 'mm/dd/yyyy hh24:mi'),4);
INSERT INTO SENSOR VALUES (4,67,49,TO_TIMESTAMP('9/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),'121212121',TO_TIMESTAMP('12/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO SENSOR VALUES (5,66,92,TO_TIMESTAMP('9/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),'123456789',TO_TIMESTAMP('11/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO SENSOR VALUES (6,100,52,TO_TIMESTAMP('9/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),'121212121',TO_TIMESTAMP('11/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),5);
INSERT INTO SENSOR VALUES (7,111,41,TO_TIMESTAMP('9/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),2);
INSERT INTO SENSOR VALUES (8,120,75,TO_TIMESTAMP('10/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),'123456789',TO_TIMESTAMP('11/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),6);
INSERT INTO SENSOR VALUES (9,124,108,TO_TIMESTAMP('10/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),'333333333',TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),7);
INSERT INTO SENSOR VALUES (10,153,50,TO_TIMESTAMP('11/10/2020 20:00', 'mm/dd/yyyy hh24:mi'),'333333333',TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),1);
INSERT INTO SENSOR VALUES (11,151,33,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),'222222222',TO_TIMESTAMP('11/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),2);
INSERT INTO SENSOR VALUES (12,151,73,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),'121212121',TO_TIMESTAMP('11/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),2);
INSERT INTO SENSOR VALUES (13,100,20,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),NULL,TO_TIMESTAMP('11/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),2);
---------------------------------------------

DROP TABLE IF EXISTS REPORT CASCADE;
CREATE TABLE REPORT(
    sensor_id integer,
    report_time timestamp,
    temperature real,
    CONSTRAINT report_pk
        PRIMARY KEY (sensor_id, report_time),
    CONSTRAINT sensor_id_fk
        FOREIGN KEY (sensor_id) REFERENCES SENSOR(sensor_id)
    -- use the alter statement to add the unique constraints
        -- not every table has a unique constraint!!
        -- every table has to have a primary key, but not every table
        -- has to have the unique constraint
);

--INSERT STATEMENTS
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('5/10/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (11,TO_TIMESTAMP('5/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),88);
INSERT INTO REPORT VALUES (12,TO_TIMESTAMP('6/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),87);
INSERT INTO REPORT VALUES (6,TO_TIMESTAMP('7/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),38);
INSERT INTO REPORT VALUES (2,TO_TIMESTAMP('9/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (1,TO_TIMESTAMP('9/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),34);
INSERT INTO REPORT VALUES (3,TO_TIMESTAMP('9/5/2020 10:00', 'mm/dd/yyyy hh24:mi'),57);
INSERT INTO REPORT VALUES (4,TO_TIMESTAMP('9/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),62);
INSERT INTO REPORT VALUES (5,TO_TIMESTAMP('9/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),52);
INSERT INTO REPORT VALUES (3,TO_TIMESTAMP('9/9/2020 8:25', 'mm/dd/yyyy hh24:mi'),61);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('9/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),37);
INSERT INTO REPORT VALUES (1,TO_TIMESTAMP('9/10/2020 20:00', 'mm/dd/yyyy hh24:mi'),58);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('9/10/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (8,TO_TIMESTAMP('9/11/2020 2:00', 'mm/dd/yyyy hh24:mi'),44);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('9/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),49);
INSERT INTO REPORT VALUES (8,TO_TIMESTAMP('9/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),51);
INSERT INTO REPORT VALUES (9,TO_TIMESTAMP('9/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),55);
INSERT INTO REPORT VALUES (10,TO_TIMESTAMP('9/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),70);
INSERT INTO REPORT VALUES (11,TO_TIMESTAMP('9/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),88);
INSERT INTO REPORT VALUES (11,TO_TIMESTAMP('9/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (12,TO_TIMESTAMP('9/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),60);
INSERT INTO REPORT VALUES (2,TO_TIMESTAMP('10/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (1,TO_TIMESTAMP('10/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),34);
INSERT INTO REPORT VALUES (3,TO_TIMESTAMP('10/5/2020 10:00', 'mm/dd/yyyy hh24:mi'),57);
INSERT INTO REPORT VALUES (5,TO_TIMESTAMP('10/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),52);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('10/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),37);
INSERT INTO REPORT VALUES (6,TO_TIMESTAMP('10/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),38);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('10/10/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('10/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),49);
INSERT INTO REPORT VALUES (8,TO_TIMESTAMP('10/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),51);
INSERT INTO REPORT VALUES (10,TO_TIMESTAMP('10/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),70);
INSERT INTO REPORT VALUES (11,TO_TIMESTAMP('10/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),88);
INSERT INTO REPORT VALUES (11,TO_TIMESTAMP('10/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (12,TO_TIMESTAMP('10/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),60);
INSERT INTO REPORT VALUES (2,TO_TIMESTAMP('11/1/2020 18:30', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (3,TO_TIMESTAMP('11/5/2020 10:00', 'mm/dd/yyyy hh24:mi'),57);
INSERT INTO REPORT VALUES (3,TO_TIMESTAMP('11/6/2020 11:00', 'mm/dd/yyyy hh24:mi'),53);
INSERT INTO REPORT VALUES (4,TO_TIMESTAMP('11/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),62);
INSERT INTO REPORT VALUES (5,TO_TIMESTAMP('11/7/2020 22:00', 'mm/dd/yyyy hh24:mi'),52);
INSERT INTO REPORT VALUES (3,TO_TIMESTAMP('11/9/2020 8:25', 'mm/dd/yyyy hh24:mi'),61);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('11/9/2020 22:00', 'mm/dd/yyyy hh24:mi'),37);
INSERT INTO REPORT VALUES (6,TO_TIMESTAMP('11/9/2020 23:00', 'mm/dd/yyyy hh24:mi'),38);
INSERT INTO REPORT VALUES (1,TO_TIMESTAMP('11/10/2020 20:00', 'mm/dd/yyyy hh24:mi'),58);
INSERT INTO REPORT VALUES (8,TO_TIMESTAMP('11/11/2020 2:00', 'mm/dd/yyyy hh24:mi'),44);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('11/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),49);
INSERT INTO REPORT VALUES (11,TO_TIMESTAMP('11/11/2020 22:00', 'mm/dd/yyyy hh24:mi'),76);
INSERT INTO REPORT VALUES (8,TO_TIMESTAMP('11/13/2020 22:00', 'mm/dd/yyyy hh24:mi'),51);
INSERT INTO REPORT VALUES (7,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),47);
INSERT INTO REPORT VALUES (9,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),55);
INSERT INTO REPORT VALUES (10,TO_TIMESTAMP('11/21/2020 22:00', 'mm/dd/yyyy hh24:mi'),70);
INSERT INTO REPORT VALUES (12,TO_TIMESTAMP('11/24/2020 13:40', 'mm/dd/yyyy hh24:mi'),77);
INSERT INTO REPORT VALUES (9,TO_TIMESTAMP('11/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),33);
INSERT INTO REPORT VALUES (11,TO_TIMESTAMP('11/27/2020 22:00', 'mm/dd/yyyy hh24:mi'),46);
INSERT INTO REPORT VALUES (9,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),35);
INSERT INTO REPORT VALUES (12,TO_TIMESTAMP('11/28/2020 22:00', 'mm/dd/yyyy hh24:mi'),87);
INSERT INTO REPORT VALUES (12,TO_TIMESTAMP('11/30/2020 9:03', 'mm/dd/yyyy hh24:mi'),60);
INSERT INTO REPORT VALUES (1,TO_TIMESTAMP('12/1/2020 22:00', 'mm/dd/yyyy hh24:mi'),34);
INSERT INTO REPORT VALUES (4,TO_TIMESTAMP('12/6/2020 22:00', 'mm/dd/yyyy hh24:mi'),62);

---------------------------------------------
-- Question #3c:
---------------------------------------------
--INSERT INTO WORKER VALUES('123321456', 'Trinity', 7, 'CA'); --violates primary key
--INSERT INTO COVERAGE VALUES (6,'AZ',1,3400); --foreign key constraint violation
--INSERT INTO STATE VALUES ('Washington', NULL, '95000', '10000001'); --NULL violation