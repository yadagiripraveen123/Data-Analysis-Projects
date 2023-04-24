use music_data_store; # using the music store database for all the below queries to solve.

-- ========================== Question Set 1 - Easy =================================
-- Who is the senior most employee based on job title?
select title, last_name, first_name, levels, email from employee
order by levels desc limit 1;

-- Which countries have the most Invoices?
select distinct billing_country , count(*) as count from invoice
group by billing_country order by billing_country desc limit 1;

-- What are top 3 values of total invoice?
select * from invoice order by total desc limit 3; # Return all the columns from the invoice table
select total from invoice order by total desc limit 3; # Return total column from the invoice table

/*Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals*/
select billing_city, sum(total) as invoice_totals from invoice
group by billing_city order by invoice_totals desc limit 1;

/*Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money*/
select customer_id, sum(total) as best_customer from invoice
group by customer_id order by best_customer desc limit 1; -- This will result the output of the customer_id and total money he spent.

select concat(first_name,' ',last_name) as best_customer from customer
where customer_id=(select customer_id from invoice group by customer_id
order by sum(total) desc limit 1); -- This will the best customer name.

-- ============================= Question Set 2 – Moderate ==================================
/*Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A*/
select distinct email ,first_name , last_name , g.name as name
from customer c join invoice i on i.customer_id = c.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track on t.track_id = il.track_id
join g on genre.genre_id = track.genre_id
WHERE g.name LIKE 'Rock'
order by email;

/*Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands*/
select ar.name, count(t.name) as total_track_count from artist ar join album a
on ar.artist_id = a.artist_id join track t on a.album_id = t.album_id join genre g 
on t.genre_id=g.genre_id where g.name= 'rock' group by ar.name, g.name order by 
total_track_count desc limit 10;
select * from track;

/*Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first*/
select name, milliseconds from track where milliseconds >(select avg(milliseconds) from track)
order by milliseconds desc;

-- ============================= Question Set 3 – Advance ==================================
/* Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent */
select c.customer_id, c.first_name, c.last_name, a.name,sum(il.unit_price*il.quantity) as total_spent
from invoice as i join customer as c on c.customer_id = i.customer_id
join invoice_line as il on il.invoice_id = i.invoice_id
join track as t on t.track_id = il.track_id
join album as al on al.album_id = t.album_id
join artist as a on a.artist_id = al.artist_id
group by c.customer_id, c.first_name, c.last_name, a.name order by total_spent DESC;

/*We want to find out the most popular music Genre for each country. We determine the most 
popular genre as the genre with the highest amount of purchases. Write a query that returns 
\each country along with the top Genre. For countries where the maximum number of purchases
is shared return all Genres*/
WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY customer.country, genre.name, genre.genre_id
		ORDER BY customer.country),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY country
		ORDER BY country)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

/*Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount*/
SELECT customer.customer_id, customer.first_name, customer.last_name, 
invoice.billing_country,SUM(invoice.total) AS total_spending
FROM invoice JOIN customer ON customer.customer_id = invoice.customer_id
GROUP BY customer_id,first_name,last_name,billing_country ORDER BY total_spending DESC;

