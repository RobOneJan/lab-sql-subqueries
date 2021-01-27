#How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title,count(i.inventory_id) from film as f
join inventory as i
using (film_id)
where f.title = "Hunchback Impossible";

#List all films whose length is longer than the average of all the films.
select avg(length) as averagefilmL from film;

select distinct title, length from film
where length > (select avg(length) as averagefilmL from film);

#Use subqueries to display all actors who appear in the film Alone Trip.

#finding the film_id of alone trip
select film_id from film where title ="Alone Trip";

#getting the actors of Alone Trip
select concat(a.first_name,' ',a.last_name) as ActorName from actor as a
join film_actor as fc
using(actor_id)
where fc.film_id in (select film_id from film where title ="Alone Trip")
group by ActorName;

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.

#the category_id of family
select category_id from category where name ="family";

#getting film ids whioch belong to family
select film_id from film_category where category_id in(select category_id from category where name ="family")
group by film_id;

#getting filmnames
select title from film 
where film_id in (select film_id from film_category where category_id in(select category_id from category where name ="family")
group by film_id)
group by title;

#Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

#getting countryid from canada
select country_id from country where country ="Canada";

# city id from canada citys
select city_id from city where country_id in (select country_id from country where country ="Canada");

#getting address_ids of canada
select address_id from address where address_id in 
(select city_id from city where country_id in (select country_id from country where country ="Canada"));

#findeing out emials and names
select first_name, last_name, Email from customer where address_id in (
select address_id from address where address_id in 
(select city_id from city where country_id in (select country_id from country where country ="Canada")));

#doing the same with joins
select first_name, last_name, Email from customer as c
join address as a
using(address_id)
join city as ci
using (city_id)
join country as co
using(country_id)
where co.country="Canada";

#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

#getting the numbers of films per actor_id
select actor_id, count(film_id) AS total from film_actor
			GROUP BY actor_id
            Order by total desc
            LIMIT 1;

#getting most prolific actor_id

SELECT actor_id from(
			select actor_id, count(film_id) AS total from film_actor
			GROUP BY actor_id
            Order by total desc
            LIMIT 1) as sub1;



#getting the movies for the choosen actor


Select f.title from film as f
join  film_actor as fa
using(film_id)
where fa.actor_id in (SELECT actor_id from(
			select actor_id, count(film_id) AS total from film_actor
			GROUP BY actor_id
            Order by total desc
            LIMIT 1) as sub1)
group by f.title;




#Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

#getting sum per customer_id with the highhest amount

select customer_id from payment
group by customer_id
order by sum(amount)  desc
limit 1;

#getting the films of the super cutomer
select f.title from film as f
join inventory as i
using (film_id)
join rental as r
using(inventory_id)
where r.customer_id = (
	select customer_id from payment
	group by customer_id
	order by sum(amount)  desc
	limit 1) 
    order by f.title;


#Customers who spent more than the average payments

#getting the sum of paments per customer
select customer_id,sum(amount) as Summe from payment group by customer_id;

#getting the average payments over all customers
select avg(Summe) from (select customer_id,sum(amount) as Summe from payment group by customer_id)as sub;

#getting the customers hwho spend more than the average
select customer_id,sum(amount) as sumPay from payment 
group by customer_id
having sumPay > 
(select avg(Summe) from (select customer_id,sum(amount) as Summe from payment group by customer_id)as sub);

