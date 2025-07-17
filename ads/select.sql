-- Название и продолжительность самого длительного трека

SELECT name, duration  from tracks
ORDER BY duration DESC 
LIMIT 1

-- Название треков, продолжительность которых не менее 3,5 минут.

SELECT name, duration FROM tracks 
WHERE duration >= 210;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно

SELECT title, release_year FROM compilations 
WHERE release_year BETWEEN 2018 AND 2020;

-- Исполнители, чьё имя состоит из одного слова.

SELECT nickname FROM singers 
WHERE nickname  NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my»

SELECT name  FROM tracks 
WHERE name LIKE '%мой%' OR name LIKE '%my%';

-- Количество исполнителей в каждом жанре

SELECT g.title, COUNT(singers_id) FROM genres g       
JOIN singer_genres sg ON sg.genres_id = g.id   
GROUP BY g.title;

-- Количество треков, вошедших в альбомы 2019–2020 годов

SELECT COUNT (t.id) FROM tracks t
JOIN albums a ON t.albums_id = a.id
WHERE a.release_year BETWEEN 2019 AND 2020;

-- Средняя продолжительность треков по каждому альбому

SELECT a.albumname, ROUND(AVG(t.duration), 2) AS avg_duration FROM albums a
JOIN tracks t ON a.id = t.albums_id
GROUP BY a.albumname
ORDER BY avg_duration DESC;

-- Все исполнители, которые не выпустили альбомы в 2020 году

SELECT s.nickname FROM singers s 
WHERE s.id NOT IN (SELECT ss.id FROM singers ss
JOIN album_singer aa ON s.id = aa.singers_id  
JOIN albums a ON a.id = aa.albums_id           
WHERE release_year = 2020)
ORDER BY nickname;

-- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)

SELECT DISTINCT c.title FROM compilations c 
JOIN compilation_track ct ON ct.compilations_id = c.id  
JOIN tracks t ON ct.tracks_id = t.id 
JOIN albums a ON t.albums_id = a.id 
JOIN album_singer al ON a.id = al.albums_id 
JOIN singers s ON s.id = al.singers_id 
WHERE s.nickname LIKE 'Сергей Лазарев';

-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра

SELECT DISTINCT a.albumname FROM albums a
JOIN album_singer als ON a.id = als.albums_id
JOIN singers s ON als.singers_id = s.id
JOIN singer_genres sg ON s.id = sg.singers_id
GROUP BY a.id, a.albumname, s.id
HAVING COUNT(DISTINCT sg.genres_id) > 1;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько

SELECT s.nickname, t.name, t.duration FROM singers s
JOIN album_singer als ON s.id = als.singers_id
JOIN tracks t ON als.albums_id = t.albums_id
WHERE t.duration = (
    SELECT MIN(duration) 
    FROM tracks 
    WHERE duration IS NOT NULL
)
ORDER BY t.duration ASC;

-- Наименования треков, которые не входят в сборники

SELECT t.name FROM tracks t
LEFT JOIN compilation_track ct ON t.id = ct.tracks_id
WHERE ct.compilations_id IS NULL;

-- Названия альбомов, содержащих наименьшее количество треков

WITH albums_tracks_counts AS (
    SELECT 
        a.id,
        a.albumname,
        COUNT(t.id) AS track_count
    FROM albums a
    LEFT JOIN tracks t ON a.id = t.albums_id
    GROUP BY a.id, a.albumname
)
SELECT albumname
FROM albums_tracks_counts
WHERE track_count = (SELECT MIN(track_count) FROM albums_tracks_counts);