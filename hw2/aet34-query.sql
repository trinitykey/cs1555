---------------------------------------------
-- Amber Turner (aet34)
-- Trinity Key (tzk1)
-- HW2 for CS1555 Fall 2021
-- SQL (DDL and DML) Questions (4)
---------------------------------------------

---------------------------------------------
-- Question #4a:
---------------------------------------------
SELECT name
FROM FOREST
WHERE acid_level >= 0.65 and acid_level <=0.85;

---------------------------------------------
-- Question #4b:
---------------------------------------------
SELECT name
FROM (SELECT name,forest_no FROM ROAD NATURAL JOIN INTERSECTION) as name_and_no NATURAL JOIN
(SELECT forest_no FROM FOREST WHERE name = 'Allegheny National Forest') as final_join;

---------------------------------------------
-- Question #4c:
---------------------------------------------
SELECT sensor_id, name
FROM sensor LEFT JOIN worker
ON sensor.maintainer = worker.ssn;

---------------------------------------------
-- Question #4d:
---------------------------------------------
DROP TABLE IF EXISTS table1;
SELECT * INTO table1 FROM(
SELECT name, state as state_col
FROM FOREST JOIN COVERAGE
ON forest.forest_no = coverage.forest_no
GROUP BY name, state) as foo;

SELECT DISTINCT T1.state_col, T2.state_col, T1.name
FROM table1 as T1 JOIN table1 as T2
ON T1.name = T2.name AND (T1.state_col != T2.state_col)
ORDER BY T1.state_col, T2.state_col, T1.name;

---------------------------------------------
-- Question #4e:
---------------------------------------------
SELECT name, AVG(avg_temp) as final_avg, count(name) FROM (
SELECT name, AVG (temperature) as avg_temp
FROM (
	SELECT sensor_id,x,y,temperature FROM sensor NATURAL JOIN report) as nat_join
	JOIN FOREST
	ON x <= forest.mbr_xmax AND x >= forest.mbr_xmin AND y <= forest.mbr_ymax AND y >= forest.mbr_ymin
	GROUP BY name) as foo
 GROUP BY name ORDER BY final_avg DESC;

---------------------------------------------
-- Question #4f:
---------------------------------------------
SELECT count(*) as sensor_count, CASE
WHEN name IS NULL then 'NO MAINTAINER'
ELSE name
END AS WORKER
FROM sensor LEFT JOIN worker
ON sensor.maintainer = worker.ssn
GROUP BY name;