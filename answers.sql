/* 1.Which tracks appeared in the most playlists? how many playlist did they appear in? */

SELECT tracks.TrackId, tracks.Name AS 'Track' , COUNT(playlist_track.PlaylistId) AS 'Playlist_Count'
FROM tracks
JOIN playlist_track
ON tracks.TrackId = playlist_track.TrackId
GROUP BY playlist_track.TrackId
ORDER BY Playlist_Count DESC;

/* 2. Which track generated the most revenue? */

SELECT tracks.TrackId, tracks.Name as 'Track', SUM(invoice_items.UnitPrice) as 'Total Sales'
FROM invoice_items
JOIN tracks
ON tracks.TrackId = invoice_items.TrackId
GROUP BY tracks.TrackID
ORDER BY SUM(invoice_items.UnitPrice) DESC

/* Which album? */

SELECT albums.AlbumId, albums.Title as 'Album', SUM(invoice_items.UnitPrice) as 'Total Sales'
FROM invoice_items
JOIN tracks
ON tracks.TrackId = invoice_items.TrackId
JOIN albums
ON tracks.AlbumId = albums.AlbumId
GROUP BY albums.AlbumId
ORDER BY SUM(invoice_items.UnitPrice) DESC

/* Which genre? */

SELECT genres.GenreId, genres.Name as 'Genre', ROUND(SUM(invoice_items.UnitPrice),2) as 'Total Sales'
FROM invoice_items
JOIN tracks
ON tracks.TrackId = invoice_items.TrackId
JOIN genres
ON tracks.GenreId = genres.GenreId
GROUP BY genres.GenreId
ORDER BY SUM(invoice_items.UnitPrice) DESC

/** 3. Which countries have the highest sales revenue? What percent of total revenue does each country make up? **/

SELECT invoices.BillingCountry, ROUND(SUM(invoices.total),2),
ROUND(
(SUM(invoices.total) / 
(SELECT SUM(invoices.total)
FROM invoices)
) * 100
,2) AS '% of Total Revenue'
FROM invoices
GROUP BY BillingCountry ORDER BY SUM(invoices.total) DESC;

/** 4. How many customers did each employee support, what is the average revenue for each sale, and what is their total sale?**/

WITH orders AS (SELECT invoices.InvoiceId, invoices.CustomerId, invoices.Total as 'Sum', customers.SupportRepId
FROM invoices
JOIN customers
ON invoices.CustomerId = customers.CustomerId
)

SELECT EmployeeId, FirstName, LastName, COUNT(DISTINCT orders.CustomerId) as 'Customers helped',ROUND(AVG(orders.Sum),2) AS 'Avg Sale', ROUND(SUM(orders.Sum),2) AS 'Total Sale'
FROM orders
JOIN employees
ON orders.SupportRepId = employees.EmployeeId
GROUP BY EmployeeId ORDER BY Count(orders.CustomerId) DESC;


