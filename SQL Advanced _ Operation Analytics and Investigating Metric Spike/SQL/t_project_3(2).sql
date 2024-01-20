CREATE DATABASE project4;
SHOW DATABASES;
USE project4;

#Table 1 - users
create table users(
user_id int,
created_at varchar(100), 
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50));

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Selecting from the users table
SELECT * FROM users;

#Adding a new column temp_created_at to the users table
ALTER TABLE users ADD COLUMN temp_created_at DATETIME;

#Updating temp_created_at column with the converted date from created_at column
UPDATE users SET temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');

SELECT WEEK(created_at) as Week_Number, COUNT(DISTINCT user_id) as Weekly_User_Engagement 
FROM events
GROUP BY Week_Number
ORDER BY Week_Number;

#Task 1
SELECT EXTRACT(WEEK FROM occured_at) AS week_number,
       COUNT(DISTINCT user_id) AS active_user
FROM events_tbl
WHERE event_type = 'engagement'
GROUP BY week_number
ORDER BY week_number;

﻿#Task 2
SELECT year,
       week_num,
       num_users,
       SUM(num_users) OVER (ORDER BY year, week_num) AS cum_users
FROM (
    SELECT EXTRACT(YEAR FROM created_at) AS year,
           EXTRACT(WEEK FROM created_at) AS week_num,
           COUNT(DISTINCT user_id) AS num_users
    FROM users_tbl
    WHERE state = 'active'
    GROUP BY year, week_num
) AS sub
ORDER BY year, week_num;

#Task 3
﻿WITH cte1 AS (
    SELECT DISTINCT
        user_id,
        EXTRACT(WEEK FROM occurred_at) AS signup_week
    FROM
        events
    WHERE
        event_type = 'signup flow'
        AND event_name = 'complete_signup'
        AND EXTRACT(WEEK FROM occurred_at) = 18
),
cte2 AS (
    SELECT DISTINCT
        user_id,
        EXTRACT(WEEK FROM occurred_at) AS engagement_week
    FROM
        events
    WHERE
        event_type = 'engagement'
)
SELECT
    COUNT(user_id) AS total_engaged_users,
    SUM(CASE WHEN retention_week > 0 THEN 1 ELSE 0 END) AS retained_users
FROM (
    SELECT
        a.user_id,
        a.signup_week,
        b.engagement_week,
        b.engagement_week - a.signup_week AS retention_week
    FROM
        cte1 a
    LEFT JOIN
        cte2 b ON a.user_id = b.user_id
    ORDER BY
        a.user_id
) sub;

#Task 4
WITH cte AS (
    SELECT 
        EXTRACT(YEAR FROM occurred_at) || '-' || EXTRACT(WEEK FROM occurred_at) AS weeknum_device,
        COUNT(DISTINCT user_id) AS usercnt
    FROM 
        events_tbl
    WHERE 
        event_type = 'engagement'
    GROUP BY 
        weeknum_device
    ORDER BY 
        weeknum_device
)
SELECT 
    weeknum_device,
    usercnt
FROM 
    cte;
