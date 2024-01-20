CREATE DATABASE project3;
USE project3;

CREATE TABLE job_data (
    ds DATE,
    job_id INT NOT NULL,
    actor_id INT NOT NULL,
    event VARCHAR(15) NOT NULL,
    language VARCHAR(15) NOT NULL,
    time_spent INT NOT NULL,
    org CHAR(2)
);

select * from job_data;

INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
VALUES('2020-11-30', '21', '1001', 'skip', 'English', '15',	'A'),
('2020-11-30', '22', '1006', 'transfer', 'Arabic', '25', 'B'),
('2020-11-29', '23', '1003', 'decision', 'Persian', '20', 'C'),
('2020-11-28', '23', '1005', 'transfer', 'Persian', '22', 'D'),
('2020-11-28', '25', '1002', 'decision', 'Hindi', '11', 'B'),
('2020-11-27', '11', '1007', 'decision', 'French', '104', 'D'),
('2020-11-26', '23', '1004', 'skip', 'Persian', '56', 'A'),
('2020-11-25', '20', '1003', 'transfer', 'Italian', '45', 'C')

#Task 1 - Jobs Reviewed
SELECT * FROM job_data;

SELECT 
    AVG(t) AS 'avg jobs reviewed per day per hour',
    AVG(p) AS 'avg jobs reviewed per day per second'
FROM (
    SELECT
        ds,
        (COUNT(job_id) * 3600 / SUM(time_spent)) AS t,
        (COUNT(job_id) / SUM(time_spent)) AS p
    FROM 
        job_data
    WHERE
        MONTH(ds) = 11
    GROUP BY ds
) a;

#Task 2 - (Throughput Analysis)
SELECT ROUND (COUNT(event)/SUM(time_spent), 2) AS "Weekly Throughput" FROM job_data;

SELECT ds AS Dates, ROUND(COUNT(event)/SUM(time_spent), 2) AS "Daily Throughput" FROM job_data
GROUP BY ds ORDER BY ds;

#Task 3 - Language Share Analysis
SELECT language AS languages, ROUND(100 * COUNT(*)/total, 2) AS percentage, sub.total
FROM job_data
CROSS JOIN (SELECT COUNT(*) AS total FROM job_data) AS sub
GROUP BY language, sub.total;

#Task 4 - Duplicate Rows 
SELECT actor_id, COUNT(*) AS Duplicates FROM job_data
GROUP BY actor_id HAVING COUNT(*) > 1;