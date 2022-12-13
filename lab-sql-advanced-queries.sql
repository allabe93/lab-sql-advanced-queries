-- 1. List each pair of actors that have worked together.
select fa1.actor_id, fa2.actor_id, fa1.film_id
from sakila.film_actor fa1
join sakila.film_actor fa2
on fa1.actor_id < fa2.actor_id
and fa1.film_id = fa2.film_id;

-- 2. For each film, list actor that has acted in more films.
-- Solution #1:
with cte as (
select actor_id, count(film_id) as total_movies
from film_actor
group by actor_id
order by actor_id
),
cte2 as (
select film_id, actor_id, total_movies, 
row_number() over (partition by film_id order by total_movies desc) as flag
from cte
join film_actor using (actor_id) 
order by film_id asc, total_movies desc
)
select film_id, actor_id from cte2
where flag = 1;

-- Solution #2:
with cte as (
select *,
row_number() over (partition by film_id order by total_films desc) as flag
from (
select film_id, actor_id, total_films
from (
select actor_id, count(film_id) as total_films 
from sakila.film_actor
group by actor_id
) sub1
join film_actor using(actor_id)
) sub2 
)
select film_id, actor_id, total_films from cte
where flag = 1;