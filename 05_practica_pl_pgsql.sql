
--función sin parametro de entrada para devolver el precio máximo
CREATE OR REPLACE FUNCTION precio_maximo()
RETURNS NUMERIC 
AS $$
DECLARE
    precio NUMERIC;
BEGIN
    SELECT MAX(precio) INTO precio FROM product;
    RETURN precio;
END $$ LANGUAGE 'plpgsql';

SELECT precio_maximo();

--parametro de entrada
--Obtener el numero de ordenes por empleado
CREATE OR REPLACE FUNCTION numero_ordenes_por_empleado(empleado_id INT)
RETURNS INT 
AS $$
DECLARE
    numero_ordenes INT;
BEGIN
    SELECT COUNT(*) INTO numero_ordenes FROM orders WHERE employee_id = 1;
    RETURN numero_ordenes;
END $$ LANGUAGE 'plpgsql';

SELECT numero_ordenes_por_empleado(1);

--Obtener la venta de un empleado con un determinado producto
CREATE OR REPLACE FUNCTION venta_producto_empleado(empleado_id INT, producto_id INT)
RETURNS NUMERIC 
AS $$
DECLARE
    venta NUMERIC;
BEGIN
    SELECT SUM(od.quantity) INTO venta
    FROM order_details od , orders o 
    WHERE o.order_id = od.order_id AND o.employee_id = empleado_id AND od.product_id = producto_id;
    RETURN venta;
END $$ LANGUAGE 'plpgsql';

SELECT venta_producto_empleado(1, 1);

--Crear una funcion para devolver una tabla con producto_id,
--nombre, precio y unidades en strock, debe obtener los productos terminados en n
CREATE OR REPLACE FUNCTION productos_terminados_en_n()
RETURNS TABLE(codProduct SMALLINT, name VARCHAR, price REAL, stock SMALLINT)
AS $$
BEGIN
    RETURN QUERY SELECT P.product_id, P.product_name, P.unit_price, p.units_in_stock FROM products P WHERE product_name LIKE '%n';
END $$ LANGUAGE 'plpgsql';

SELECT * FROM productos_terminados_en_n();

-- Creamos la función contador_ordenes_anio()
--QUE CUENTE LAS ORDENES POR AÑO devuelve una tabla con año y contador
CREATE OR REPLACE FUNCTION contador_ordenes_anio()
RETURNS TABLE(anio NUMERIC, contador BIGINT)
AS $$
BEGIN
    RETURN QUERY SELECT EXTRACT(YEAR FROM order_date) AS anio, COUNT(*) AS contador FROM orders GROUP BY anio;
END $$ LANGUAGE 'plpgsql';



SELECT * FROM contador_ordenes_anio();

--Lo mismo que el ejemplo anterior pero con un parametro de entrada que sea el año
CREATE OR REPLACE FUNCTION contador_ordenes_anio_parametro(anio INT)
RETURNS TABLE(anio NUMERIC, contador BIGINT)
AS $$
BEGIN
    RETURN QUERY SELECT EXTRACT(YEAR FROM order_date) AS anio, COUNT(*) AS contador FROM orders WHERE EXTRACT(YEAR FROM order_date) = anio GROUP BY anio;
END $$ LANGUAGE 'plpgsql';

SELECT * FROM contador_ordenes_anio_parametro(1996);

 --PROCEDIMIENTO ALMACENADO PARA OBTENER PRECIO PROMEDIO Y SUMA DE 
--UNIDADES EN STOCK POR CATEGORIA
CREATE OR REPLACE FUNCTION stock_Categoria(id SMALLINT)
RETURNS TABLE(category_id SMALLINT, category_name VARCHAR, precio_promedio NUMERIC, suma_unidades_stock BIGINT)
AS $$
BEGIN
    RETURN QUERY SELECT C.category_id, C.category_name, AVG(P.unit_price), SUM(P.units_in_stock) FROM products P, categories C WHERE P.category_id = C.category_id AND C.category_id=id GROUP BY C.category_id;
END $$ LANGUAGE 'plpgsql';

SELECT * FROM stock_categoria(1);