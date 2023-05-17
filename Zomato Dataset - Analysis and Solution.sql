/*-------------------------ZOMATO SQL ANALYSIS PROJECT (05/14/2023) By Sreekala Menon -------------------*/


/*-------------------------ANALYSIS---------------------*/

/* 1. What is total amount each customer spent on zomato ? */

SELECT 
	S.user_id as User_Id, 
	SUM(P.price) as Total_Amount
FROM SALES S
INNER JOIN Product P
ON S.product_id = P.product_id
GROUP BY user_id
ORDER BY user_id;

/* 2.How many days has each customer visited zomato? */

SELECT user_id as User_Id, count(DISTINCT created_date) as Visit_Counts
FROM Sales
GROUP BY user_id
ORDER BY user_id;

/* 3.What was the first product purchased by each customer? */

SELECT 
	user_id as User_Id, product_id as Product_Id
FROM (
		SELECT 
			user_id, product_id, created_date,
			DENSE_RANK() OVER(PARTITION BY user_id ORDER BY created_date) as rnk
		FROM Sales 
	 )S
WHERE S.rnk = 1
ORDER BY user_id;

/* 4.what is most purchased item on menu & how many times was it purchased by all customers ? */

SELECT user_id as User_Id, count(product_id) as PROD_COUNT
FROM Sales WHERE product_id IN
(
		SELECT 
			TOP 1 product_id 
		FROM Sales
		GROUP BY product_id 
		ORDER BY COUNT(product_id) DESC
) 
GROUP BY user_id;

/* 5.which item was most popular for each customer? */

--- Using CTE 
WITH prod_list AS(
				SELECT 
					user_id,product_id,
					COUNT(product_id) as Prod_Count
				FROM Sales
				GROUP BY user_id, product_id
				)

SELECT 
	user_id, product_id 
FROM (
			SELECT *,
			ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY prod_count DESC) AS rn
			FROM prod_list
	) s
WHERE rn = 1
ORDER BY user_id ;

/* 6.which item was purchased first by customer after they become a gold member ? */

SELECT 
	user_id, product_id 
FROM (

		SELECT 
			s.user_id, s.product_id,
			RANK() OVER(PARTITION BY s.user_id ORDER BY created_date) as rnk
		FROM Sales S
		INNER JOIN GoldUsers_SignUp U
		ON S.user_id = U.user_id AND S.created_date >= U.goldsignup_date 
	) PROD
WHERE prod.rnk = 1
ORDER BY user_id;

/* 7. Which item was purchased just before the customer became a gold member? */

SELECT 
	user_id, product_id 
FROM (

		SELECT 
			s.user_id, s.product_id,S.created_date, U.goldsignup_date,
			RANK() OVER(PARTITION BY s.user_id ORDER BY created_date desc) as rnk
		FROM Sales S
		INNER JOIN GoldUsers_SignUp U
		ON S.user_id = U.user_id AND S.created_date < U.goldsignup_date 
	) PROD
WHERE prod.rnk = 1
ORDER BY user_id;

/* 8. what is total orders and amount spent for each member before they become a gold member? */

SELECT 
	S.user_id, count(S.created_date) AS Total_Orders, sum(P.price) AS Total_Price
FROM Sales S
JOIN GoldUsers_SignUp U
ON S.user_id = U.user_id AND S.created_date < U.goldsignup_date
JOIN Product P
ON S.product_id = P.product_id
GROUP BY S.user_id
ORDER BY S.user_id
;

/* 9. If buying each product generates points for eg 5rs=2 zomato point 
  and each product has different purchasing points for eg for 
  p1 5rs=1 zomato point,for p2 10rs=5 zomato point (so, 2 rs = 1 zomato point)  and p3 5rs=1 zomato point,  
 calculate points collected by each customer and  */


WITH PRODLIST AS (
		 SELECT 
			S.user_id AS userid, S.product_id AS product, P.price AS price, 
			CASE WHEN P.product_id = 1 THEN P.price/5
				 WHEN P.product_id = 2 THEN P.price/2
				 WHEN P.product_id = 3 THEN P.price/5
			END AS points
		FROM Sales S
		INNER JOIN Product P
		ON S.product_id = P.product_id
		---ORDER BY userid, S.product_id;
)

SELECT 
	userid,
	SUM(points) AS Total_Points
FROM PRODLIST
GROUP BY userid
ORDER BY userid;

/* for which product most points have been given till now.*/
WITH PRODLIST AS (
		 SELECT 
			S.user_id AS userid, S.product_id AS product, P.price AS price, 
			CASE WHEN P.product_id = 1 THEN P.price/5
				 WHEN P.product_id = 2 THEN P.price/2
				 WHEN P.product_id = 3 THEN P.price/5
			END AS points
		FROM Sales S
		INNER JOIN Product P
		ON S.product_id = P.product_id
		---ORDER BY userid, S.product_id;
)

/* selecting the top product with the hightest points */
SELECT 
	top 1 product
FROM PRODLIST
GROUP BY product
ORDER BY sum(points) DESC;


/* 10. In the first year after a customer joins the gold program (including the join date ), irrespective of what customer has purchased, they 
earn 5 zomato points for every 10rs spent. Who earned more 1 or 3 what is the earning in first yr ? 1zp = 2rs */

SELECT TOP 1 userid, SUM(points) AS Total_Points
FROM (

	SELECT 
		G.user_id AS userid, S.product_id, G.goldsignup_date, S.created_date, P.price, p.price*5/10 AS points
	FROM GoldUsers_SignUp G
	INNER JOIN Sales S
	ON G.user_id=S.user_id AND S.created_date >= G.goldsignup_date AND S.created_date <= DATEADD(YEAR, 1, G.goldsignup_date)
	INNER JOIN Product P
	ON S.product_id = P.product_id
	---ORDER BY user_id;
)pts
GROUP BY userid
ORDER BY Total_Points desc


/* 11. rnk all transaction of the customers 
My thoughts - there should have been another criteria provided like rnk by product id or user id. since none is provided I am using created date*/


SELECT 
	*,
	RANK() OVER(PARTITION BY user_id ORDER BY created_date) as RANK
FROM Sales;


/* 12. rank all transaction for each member whenever they are zomato gold member for every non gold member transaction mark as na */
/* Tricky coz the Rank function returns int and 'na' is string, so type conversion required using CAST function */

SELECT user_id, product_id, created_date, CASE WHEN FLAG = 0 THEN 'na' ELSE FLAG END AS Ranks
FROM(
	SELECT 
		S.user_id, 
		S.created_date, S.product_id, G.goldsignup_date,
		CAST((CASE WHEN S.created_date>=G.goldsignup_date THEN RANK() OVER(PARTITION BY S.user_id ORDER  BY S.created_date desc) ELSE 0  END) AS varchar) AS FLAG
	FROM Sales S
	LEFT JOIN GoldUsers_SignUp g
	ON S.user_id = G.user_id
	)r











