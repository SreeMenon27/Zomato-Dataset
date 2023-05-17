/*-------------------------ZOMATO SQL ANALYSIS PROJECT (05/14/2023) By Sreekala Menon -------------------*/

/*Creating the table GoldUsers_SignUp containing data of users who have signed up for the Gold Plan */
Drop table if exists GoldUsers_SignUp;
CREATE TABLE GoldUsers_SignUp(user_id integer, goldsignup_date date);

/* Inserting values to the GoldUsers_SignUp table */
INSERT INTO GoldUsers_SignUp 
	values(1,'09-22-2017'),(3,'04-21-2017');

/* Selecting values from the GoldUsers_SignUp table */
SELECT * FROM GoldUsers_SignUp

/*Creating the Users table containing user information */
DROP TABLE IF EXISTS Users;
CREATE TABLE Users(user_id integer, signup_date date);

/* Inserting values to the Users table */
INSERT INTO Users VALUES(1,'09-02-2014'),(2,'01-15-2015'),(3,'04-11-2014');

/* Selecting values from the Users table */
SELECT * FROM Users;

/*Creating the Sales table containing user information */
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales(user_id integer, created_date date,product_id integer);

/* Inserting values to the Sales table */
INSERT INTO Sales VALUES(1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);

/* Selecting values from the Sales table */

SELECT * FROM Sales;

/* Creating the products table containing all product information */
DROP TABLE if exists Product;
CREATE TABLE Product(product_id integer,product_name text,price integer); 

/* Inserting the product information */
INSERT INTO Product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);
