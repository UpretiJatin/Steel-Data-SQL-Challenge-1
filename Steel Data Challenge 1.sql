
create database Steel_Challenge1;

use Steel_Challenge1; 

CREATE TABLE cars (
car_id INT PRIMARY KEY,
make VARCHAR(50),
type VARCHAR(50),
style VARCHAR(50),
cost_$ INT
);


INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000),
(2, 'Toyota', 'Corolla', 'Hatchback', 25000),
(3, 'Ford', 'Explorer', 'SUV', 40000),
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
(5, 'BMW', 'X5', 'SUV', 55000),
(6, 'Audi', 'A4', 'Sedan', 48000),
(7, 'Mercedes', 'C-Class', 'Coupe', 60000),
(8, 'Nissan', 'Altima', 'Sedan', 26000);


CREATE TABLE salespersons (
salesman_id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
city VARCHAR(50)
);


INSERT INTO salespersons (salesman_id, name, age, city)
VALUES (1, 'John Smith', 28, 'New York'),
(2, 'Emily Wong', 35, 'San Fran'),
(3, 'Tom Lee', 42, 'Seattle'),
(4, 'Lucy Chen', 31, 'LA');


CREATE TABLE sales (
sale_id INT PRIMARY KEY,
car_id INT,
salesman_id INT,
purchase_date DATE,
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);


INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date)
VALUES (1, 1, 1, '2021-01-01'),
(2, 3, 3, '2021-02-03'),
(3, 2, 2, '2021-02-10'),
(4, 5, 4, '2021-03-01'),
(5, 8, 1, '2021-04-02'),
(6, 2, 1, '2021-05-05'),
(7, 4, 2, '2021-06-07'),
(8, 5, 3, '2021-07-09'),
(9, 2, 4, '2022-01-01'),
(10, 1, 3, '2022-02-03'),
(11, 8, 2, '2022-02-10'),
(12, 7, 2, '2022-03-01'),
(13, 5, 3, '2022-04-02'),
(14, 3, 1, '2022-05-05'),
(15, 5, 4, '2022-06-07'),
(16, 1, 2, '2022-07-09'),
(17, 2, 3, '2023-01-01'),
(18, 6, 3, '2023-02-03'),
(19, 7, 1, '2023-02-10'),
(20, 4, 4, '2023-03-01');



/*1. What are the details of all cars purchased in the year 2022?*/

select c.car_id, count(c.car_id) as Total_Cars, c.make, c.type, c.style, year(s.purchase_date) as Year from sales s inner join cars c on s.car_id = c.car_id  
where year(s.purchase_date) = 2022
group by c.car_id;


/*2. What is the total number of cars sold by each salesperson?*/

select s1.salesman_id, s2.name, s2.age, s2.city, count(s1.car_id) as No_of_Cars_Sold from sales s1 inner join salespersons s2 on s1.salesman_id = s2.salesman_id
group by s1.salesman_id;


/*3. What is the total revenue generated by each salesperson?*/

with tt as
(select sp.salesman_id, sp.name, s.car_id from salespersons sp inner join sales s using(salesman_id))

select s1.salesman_id, s1.name, sum(c.cost_$) as Revenue from tt s1 inner join cars c using(car_id)
group by s1.name;


/* 4. What are the details of the cars sold by each salesperson?*/

with tt as
(select sp.salesman_id, sp.name, s.car_id from salespersons sp inner join sales s using(salesman_id))

select s1.salesman_id, s1.name, c.make, c.type, c.style from tt s1 inner join cars c using(car_id)
group by c.car_id;


/*5. What is the total revenue generated by each car type?*/

select c.type, sum(c.cost_$) as Revenue from sales s  inner join cars c
group by c.type;


/*6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?*/


with tt as
(select sp.salesman_id, sp.name, s.car_id, s.purchase_date from salespersons sp inner join sales s using(salesman_id))

select s1.salesman_id, s1.name, c.make, c.type, c.style, s1.purchase_date from tt s1 inner join cars c using(car_id)
where s1.name = "Emily Wong" and year(s1.purchase_date) = 2021
group by c.car_id;


/*7. What is the total revenue generated by the sales of hatchback cars?*/

select c.style, sum(c.cost_$) as Revenue from sales s inner join cars c
where c.style = "Hatchback";


/*8. What is the total revenue generated by the sales of SUV cars in the year 2022?*/

select c.style, sum(c.cost_$) as Revenue from sales s  inner join cars c
group by c.style
having c.style = "SUV";


/*9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?*/

select sp.name, sp.city, count(*) as No_of_cars_sold from salespersons sp inner join sales s using(salesman_id)
where year(s.purchase_date) = 2023
group by sp.name
order by count(*) desc
limit 1;


/*10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?*/

with tt as
(select s.car_id, sp.name, sp.age, s.purchase_date from salespersons sp inner join sales s using(salesman_id))

select s1.name, s1.age, sum(c.cost_$) as Highest_Revenue from tt s1 inner join cars c using(car_id)
where year(s1.purchase_date) = 2022
group by s1.name
order by sum(c.cost_$) desc limit 1;