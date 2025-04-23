/*Explorar la tabla “menu_items” para conocer los productos del menú.*/
SELECT * FROM menu_items;

-- Encontrar el número de artículos en el menú: 32 artículos
SELECT COUNT (item_name) FROM menu_items;

--¿Cuál es el artículo menos caro y el más caro en el menú? El artículo menos caro es el Edamame con un precio de $5.00 y el más caro es el Shrimp Scampi con un precio de $19.95.
SELECT item_name, price
	FROM menu_items
	ORDER BY 2 ASC
	LIMIT 1;

SELECT item_name, price
	FROM menu_items
	ORDER BY 2 DESC
	LIMIT 1;
	
--¿Cuántos platos americanos hay en el menú? 6 platos.
SELECT COUNT (item_name)
	FROM menu_items
	WHERE category = 'American';

--¿Cuál es el precio promedio de los platos? El precio promedio de todos los platos es de $13.29.
SELECT ROUND (AVG (price), 2) AS precio_promedio
	FROM menu_items;

--El precio promedio de los platos por cateogoría es la siguiente: American: $10.07, Mexican: $11.80, Asian: $13.48 e Italian: $16.75.
SELECT category, ROUND (AVG (price), 2) AS precio_promedio
	FROM menu_items
	GROUP BY 1;

/*Explorar la tabla “order_details” para conocer los datos que han sido recolectados.*/
SELECT * FROM order_details;

--¿Cuántos pedidos únicos se realizaron en total? Se realizaron 5,370 pedidos, de los cuales 5,343 tienen datos de los productos pedidos.
SELECT COUNT (DISTINCT order_id) AS numero_pedidos
	FROM order_details;

SELECT COUNT (DISTINCT order_id) AS numero_pedidos
	FROM order_details
	WHERE item_id != 0;

--¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos? Los pedidos 440,2675,3473,4305 y 443 tuvieron 14 artículos pedidos.
SELECT order_id, COUNT (item_id) AS numero_articulos
	FROM order_details
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5;

--¿Cuándo se realizó el primer pedido y el último pedido? El primer pedido se realizó en enero 1, 2023 y el último pedido en marzo 31, 2023.
SELECT order_date
	FROM order_details
	GROUP BY 1
	ORDER BY 1 ASC
	LIMIT 1;
	
SELECT order_date
	FROM order_details
	GROUP BY 1
	ORDER BY 1 DESC
	LIMIT 1;
	
--¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'? 308 pedidos, de los cuales 304 tienen información de productos.
SELECT COUNT (DISTINCT order_id)
	FROM order_details
	WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';

SELECT COUNT (DISTINCT order_id)
	FROM order_details
	WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05'
	AND item_id != 0;

/*Usar ambas tablas para conocer la reacción de los clientes respecto al menú.*/
SELECT * FROM menu_items;
SELECT * FROM order_details;

--Realizar un left join entre entre order_details y menu_items con el identificador item_id(tabla order_details) y menu_item_id(tabla menu_items).
SELECT O.order_id, O.order_date, O.order_time, O.item_id, M.item_name, M.category, M.price
	FROM order_details O
	LEFT JOIN menu_items M
	ON O.item_id = M.menu_item_id;

/*Una vez que hayas explorado los datos en las tablas correspondientes y respondido las
preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. El
objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del
restaurante en el lanzamiento de su nuevo menú. Para ello, crea tus propias consultas y
utiliza los resultados obtenidos para llegar a estas conclusiones.*/

--¿Cuáles fueron los 5 productos más pedidos en esos 3 meses? Hamburger, Edamame, Korean Beef Bowl, Cheeseburger, French Fries.
SELECT M.item_name, COUNT (O.item_id) AS numero_pedidos
	FROM order_details O
	LEFT JOIN menu_items M
	ON O.item_id = M.menu_item_id
	GROUP BY 1
	HAVING COUNT (item_id) != 0
	ORDER BY 2 DESC
	LIMIT 5;

--¿Cuántos productos de cada categoría fueron pedidos? Asian: 3470, Italian: 2948, Mexican: 2945, American: 2734.
SELECT M.category, COUNT (O.item_id) AS numero_pedidos
	FROM order_details O
	LEFT JOIN menu_items M
	ON O.item_id = M.menu_item_id
	GROUP BY 1
	HAVING COUNT (item_id) != 0 
	ORDER BY 2 DESC;

--¿Cuál es el producto más pedido por cateogoría? Hamburger de American, Edamame de Asian, Spaguetti & Meatballs de Italian, Steak Torta de Mexican.
SELECT M.category, M.item_name, COUNT (O.item_id) AS numero_pedidos
	FROM order_details O
	LEFT JOIN menu_items M
	ON O.item_id = M.menu_item_id
	GROUP BY 1,2 
	HAVING COUNT (item_id) != 0 
	ORDER BY 1,3 DESC;
	
--¿En qué horario del día se pidieron más productos? El horario en que se pidieron más productos fue entre las 4 y 7 pm.
SELECT COUNT (*) AS total_pedidos,
	SUM (CASE WHEN order_time BETWEEN '09:00:00' AND '12:59:59' THEN 1 ELSE 0 END) AS ventas_mañana,
	SUM (CASE WHEN order_time BETWEEN '13:00:00' AND '15:59:59' THEN 1 ELSE 0 END) AS ventas_tarde_1,
	SUM (CASE WHEN order_time BETWEEN '16:00:00' AND '18:59:59' THEN 1 ELSE 0 END) AS ventas_tarde_2,
	SUM (CASE WHEN order_time BETWEEN '19:00:00' AND '23:59:59' THEN 1 ELSE 0 END) AS ventas_noche
	FROM order_details O
	LEFT JOIN menu_items M
	ON O.item_id = M.menu_item_id
	WHERE item_id != 0;

--¿Qué productos fueron los 5 menos pedidos? Chicken Tacos, Potstickers, Cheese Lasagna, Steak Tacos, Cheese Quesadillas.
SELECT M.item_name, COUNT (O.item_id) AS numero_pedidos
	FROM order_details O
	LEFT JOIN menu_items M
	ON O.item_id = M.menu_item_id
	GROUP BY 1
	HAVING COUNT (item_id) != 0
	ORDER BY 2 ASC
	LIMIT 5;