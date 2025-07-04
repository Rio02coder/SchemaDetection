CREATE database LittleX_7;

USE LittleX_7;

CREATE TABLE Profile (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    followees JSON -- list of Profile IDs
);

CREATE TABLE Tweet (
    id INT PRIMARY KEY,
    content TEXT NOT NULL,
    profiles JSON, -- list of Profile IDs
    likes JSON -- list of Profile IDs
);

EXPLAIN ANALYZE
SELECT t.id, t.content, t.likes
FROM Profile p
JOIN JSON_TABLE(
    CONCAT('[', JSON_QUOTE(CAST(p.id AS CHAR)), ',', p.followees, ']'),
    '$[*]' COLUMNS(profile_id INT PATH '$')
) AS all_profiles
JOIN Tweet t ON JSON_CONTAINS(t.profiles, JSON_QUOTE(CAST(all_profiles.profile_id AS CHAR)))
WHERE p.id = 10;

EXPLAIN ANALYZE SELECT jt.profile_id
FROM Tweet t
JOIN JSON_TABLE(t.profiles, '$[*]' COLUMNS(profile_id INT PATH '$')) AS jt
WHERE t.id = 800;

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'LittleX_7'
GROUP BY table_schema;