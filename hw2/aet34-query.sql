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
SELECT DISTINCT c1.state, c2.state
FROM coverage as c1 JOIN coverage as c2
ON c1.forest_no = c2.forest_no
WHERE c1.state < c2.state;

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