/*SELECT id, first_name, role as actoresActivos, COUNT(actoresActivos) FROM actors LEFT JOIN roles ON actors.id = roles.actor_id LIMIT 5;*/


SELECT first_name || " " ||  last_name as full_names, COUNT(first_name || " " ||  last_name) as contador FROM actors GROUP BY full_names ORDER BY contador DESC LIMIT 10;


SELECT first_name, last_name, role, COUNT(role) as role_count FROM actors LEFT JOIN roles ON actors.id = roles.actor_id GROUP BY first_name, last_name ORDER BY role_count DESC LIMIT 5;


SELECT genre, COUNT(id) as num_movies_by_genres FROM movies_genres LEFT JOIN movies ON movies_genres.movie_id = movies.id GROUP BY genre ORDER BY num_movies_by_genres DESC LIMIT 5;

/*SELECT mg.genre, COUNT(m.id) AS total_movies
FROM movies_genres mg
JOIN movies m ON mg.movie_id = m.id
GROUP BY mg.genre
ORDER BY total_movies ;*/

/*Lista el nombre y apellido de todos los actores que actuaron en la película 'Braveheart' de 1995, ordenados alfabéticamente por sus apellidos.*/

SELECT first_name, last_name FROM actors a JOIN roles r ON a.id = r.actor_id JOIN movies m ON r.movie_id = m.id WHERE m.name = "Braveheart" AND m.year = 1995 ORDER BY last_name;

/*Listá todos los directores que dirigieron una película de género 'Film-Noir' en un año bisiesto (hagamos de cuenta que todos los años divisibles por 4 son años bisiestos, aunque no sea verdad en la vida real).

Tu query deberá retornar el nombre del director, el nombre de la película y el año, ordenado por el nombre de la película.*/

SELECT d.first_name, d.last_name, m.name, m.year 
FROM directors d 
JOIN movies_directors md ON d.id = md.director_id
JOIN movies m ON md.movie_id = m.id
JOIN movies_genres mg ON m.id = mg.movie_id
WHERE mg.genre = "Film-Noir" AND m.year % 4 = 0 ORDER BY m.name

/*Listá todos los actores que hayan trabajado con Kevin Bacon en una película de Drama (incluí el nombre de la película) y excluí al Sr. Bacon de los resultados.*/

SELECT pelicula, actors.first_name, actors.last_name
FROM (SELECT movies.name as 'pelicula', actors.first_name, actors.last_name, movies.id as 'id_pelicula'
FROM roles
INNER JOIN actors ON roles.actor_id = actors.id
INNER JOIN movies ON roles.movie_id = movies.id
INNER JOIN movies_genres ON movies.id = movies_genres.movie_id
WHERE actors.first_name = 'Kevin' AND actors.last_name = 'Bacon' AND movies_genres.genre = 'Drama') AS 'tabla_kevin'
INNER JOIN roles ON tabla_kevin.id_pelicula = roles.movie_id
INNER JOIN actors ON roles.actor_id = actors.id
WHERE NOT actors.first_name = 'Kevin' AND actors.last_name = 'Bacon'

/*¿Cúales son los actores que actuaron en un film antes de 1900 y también en un film después del 2000?

NOTA: no estamos pidiendo todos los actores pre-1900 y post-2000, sino aquellos que hayan trabajado en ambas eras.*/

SELECT first_name, last_name, id
FROM actors
WHERE id IN(
  SELECT actor_id
  FROM roles 
  WHERE movie_id IN(
  SELECT id
  FROM movies
  WHERE year < 1900
)
)
INTERSECT
SELECT first_name, last_name, id
FROM actors
WHERE id IN(
  SELECT actor_id
  FROM roles 
  WHERE movie_id IN(
  SELECT id
  FROM movies
  WHERE year > 2000
)
)
ORDER BY id;

/*Buscá actores que hayan tenido cinco, o más, roles distintos en la misma película luego del año 1990.

Escribí un query que retorne el nombre del actor, el nombre de la película y el número de roles distintos que hicieron en esa película (que va a ser ≥5).*/

/*SELECT 
    a.first_name AS nombre_actor,
    m.name AS nombre_pelicula,
    COUNT(DISTINCT r.role) AS num_roles
FROM 
    actors a
JOIN 
    roles r ON a.id = r.actor_id
JOIN 
    movies m ON m.id = r.movie_id
GROUP BY 
    a.first_name, m.name
HAVING 
    COUNT(DISTINCT r.role) >= 5;*/

SELECT a.first_name||' '|| a.last_name  AS full_name, m.name as "Movie", m.year as  "Year" COUNT(r.role) as roles_counter
FROM actors a
JOIN roles r ON a.id = r.actor_id
JOIN movies m ON r.movie_id = m.id 
WHERE m.year > 1990 
GROUP BY a.id, m.id
HAVING roles_counter >= 5
ORDER BY roles_counter DESC LIMIT 10;