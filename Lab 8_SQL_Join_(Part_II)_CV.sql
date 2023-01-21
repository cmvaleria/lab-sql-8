-- Lab 8 | SQL Join (Part II) Cristian Valeria

use sakila;

-- In this lab, you will be using the Sakila database of movie rentals.

-- Instructions:

-- 1) Write a query to display for each store its store ID, city, and country.

-- output: store_id , city, country

select * from store; -- here get the store (group by store ID) -- store_id, address_id
select * from adress; -- adress id - city_id
select * from city; -- city -- on country_id
select * from country; -- here get the country -- country_id

select s.store_id, c.city, co.country
from store as s
join address as a
on s.address_id = a.address_id
join city as c
on a.city_id = c.city_id
join country as co
on c.country_id = co.country_id;

-- 2) Write a query to display how much business, in dollars, each store brought in.
-- is not clear what it means by 'how much business' i will suppost is = 'how much money, revenue'
 
-- output: total amount / store 
 
select * from payment; -- for the payment, but is not connected with store, but is with customer by customer_id
select * from customer ;-- connected with store by store_id

-- select *
select s.store_id, sum(p.amount) as total_income_USD
from payment as p
left join customer as c
on p.customer_id = c.customer_id
left join store as s
on c.store_id = s.store_id
group by s.store_id;


-- 3) Which film categories are longest?

-- output: lenght by category 

select * from film; -- lenght -- film_id
select * from film_category; -- conector -- 
select * from category; -- category 

select c.name as category_name, round(avg(f.length),0) as avg_lenght 
from film as f
join film_category as fc
on f.film_id = fc.film_id 
left join category as c
on fc.category_id = c.category_id
group by c.name
order by avg_lenght desc;

-- game is the category that have in avarage  longest movies


-- 4) Display the most frequently rented movies in descending order.

-- Output: titles, frecuency rate (count rentals)

select * from rental; -- all the rentals
select * from inventory; -- film_id
select * from film; -- title  

select f.title, count(r.rental_id) as rent_freq
from rental as r
left join inventory as i 
on r.inventory_id = i.inventory_id
left join film as f
on i.film_id = f.film_id
group by f.title
order by count(r.rental_id) desc;


-- 5) List the top five genres in gross revenue in descending order. --genders (categories) that generate more revenue? 
-- have to make 5 joins from payment to category :(

select c.name as category_name, sum(p.amount) as total_income_USD 
from payment as p
left join rental as r
on p.rental_id = r.rental_id
left join inventory as i
on r.inventory_id = i.inventory_id
left join film as f
on i.film_id = f.film_id -- good so far
left join film_category as fc
on f.film_id = fc.film_id
left join category as c
on fc.category_id = c.category_id
group by c.name
order by total_income_USD desc
Limit 5;

-- 6) Is "Academy Dinosaur" available for rent from Store 1?

-- have to check if this specific movie is available  in Store 1. 

-- check this visualy
select f.title, i.inventory_id, i.store_id as store
from inventory as i
left join film as f
on i.film_id = f.film_id
where f.title = 'Academy Dinosaur';

-- or direct, filtering -- 4 movies availables in store 1: 
select f.title, count(i.inventory_id) as inventory_available, i.store_id as store
from inventory as i
left join film as f
on i.film_id = f.film_id
where f.title = 'Academy Dinosaur'
group by i.store_id ;

-- 7) Get all pairs of actors that worked together.

-- i have to get all the actors on each films 

select f.film_id, a.first_name, a.last_name
from film_actor as f
left join actor as a
on f.actor_id = a.actor_id;


-- 8) Get all pairs of customers that have rented the same film more than 3 times.

-- customer_id + film

select * from customer;
select * from rental;
select * from inventory;

-- select count(i.film_id), c.first_name, c.last_name, c.customer_id
-- select i.film_id, c.customer_id, c.first_name, c.last_name 

select i.film_id, c.customer_id, c.first_name, c.last_name 
from rental as r
left join inventory as i
on r.inventory_id = i.inventory_id
left join customer as c
on r.customer_id = c.customer_id
order by i.film_id;

-- i give up, spend to much time trying now to count the coustomer_id and select the one that is more than 3 in each film id, couldnt do it 

select i.film_id, count(c.customer_id), c.customer_id
from rental as r
left join inventory as i
on r.inventory_id = i.inventory_id
left join customer as c
on r.customer_id = c.customer_id
group by i.film_id
having count(c.customer_id > 3);
-- not working

-- 9) For each film, list actor that has acted in more films.

select * from film; -- film title --film_id
select * from film_actor; -- film_id -- actor_id
select * from actor;  -- actor_id , first name, last name

-- first list of all movies

select count(a.actor_id) as film_acts, a.actor_id, a.first_name, a.last_name   -- , f.title
from film_actor as fa			-- 1000 movies
left join film as f
on fa.film_id = f.film_id 		-- all the actors (actor_id) in each movie, now just need the name
left join actor as a
on fa.actor_id = a.actor_id
group by a.actor_id
order by film_acts desc; 

-- Have the rank of actors with the most film acts, but dont know now how to join this with the movies. 
