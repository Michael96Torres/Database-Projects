/* 1) Return the model number and price of all products (of any type) made by manufacturer “B” */
SELECT model FROM Product WHERE maker = 'B';

/* 2) Return all manufacturers that sell Laptops, but not PC’s  */
SELECT DISTINCT maker
FROM Product
    WHERE type = 'laptop' AND maker NOT IN (
        SELECT maker
        FROM Product
        WHERE type = 'pc');

/* 3) Return all the hard-disk sizes that occur in two or more PC’s */
SELECT HD  FROM PC  GROUP BY HD HAVING COUNT(HD) > 1;

/* 4) Return all pairs of PC models that share the same speed and RAM. Pairs should only be listed once (eg: (i,j) but not also (j,i)) */
SELECT pc.model, pc1.model
FROM   pc, pc AS pc1 
WHERE  pc.model < pc1.model AND pc.speed = pc1.speed AND pc.ram = pc1.ram;

/* 6) Return all the printer(s) with the highest price*/
SELECT p1.maker, p2.model, p2.type, p2.price
FROM Product p1
INNER JOIN Printer p2 ON p1.model = p2.model
WHERE p2.price = (SELECT MAX(price) FROM Printer WHERE color = "TRUE");

/* 7) Return the maker of the color printer with the lowest price */
SELECT p1.maker, p2.model, p2.type, p2.price
FROM Product p1
INNER JOIN Printer p2 ON p1.model = p2.model
WHERE p2.price = (SELECT MIN(price) FROM Printer WHERE color = "TRUE");

/* 8) Return the average speed of laptops that cost over $1000 */
SELECT AVG(speed) FROM Laptop WHERE price > 1000;

/* 9) Return the average price of PC’s and laptops made by manufacturer “D” */
SELECT AVG(price) FROM (SELECT model, price FROM PC UNION SELECT model, price FROM Laptop) Item, Product WHERE Item.model = Product.model AND maker = 'D';

/* 10) Return the average price of PCs for each unique speed above 2.0. (For each speed value find the averages amongst those) */
SELECT speed, avg(pc.price)
FROM pc 
WHERE speed > 2.0 
GROUP BY speed;