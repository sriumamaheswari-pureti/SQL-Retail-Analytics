
-- ========== INSERT CUSTOMERS (50 ROWS) ==========

INSERT INTO customers
SELECT 
    LEVEL AS customer_id,
    'Cust_' || LEVEL AS customer_name
FROM dual
CONNECT BY LEVEL <= 50;


-- ========== INSERT STORES ==========

INSERT INTO stores (store_id, store_name) VALUES (1, 'CMR');
INSERT INTO stores (store_id, store_name) VALUES (2, 'SR');
INSERT INTO stores (store_id, store_name) VALUES (3, 'Lucky');


-- ========== INSERT PRODUCTS ==========

INSERT INTO products (product_id, category) VALUES (1, 'Electronics');
INSERT INTO products (product_id, category) VALUES (2, 'Fashion');
INSERT INTO products (product_id, category) VALUES (3, 'Grocery');
INSERT INTO products (product_id, category) VALUES (4, 'Home');


-- ========== INSERT SALES (1000 ROWS) ==========

INSERT INTO sales
SELECT
    LEVEL                             AS sale_id,
    MOD(LEVEL, 50) + 1               AS customer_id,
    MOD(LEVEL, 3) + 1                AS store_id,
    MOD(LEVEL, 4) + 1                AS product_id,
    DATE '2025-01-01' + MOD(LEVEL,90) AS sale_date,
    ROUND(DBMS_RANDOM.VALUE(100,10000)) AS amount,
    MOD(LEVEL, 5) + 1               AS quantity,
    CASE 
        WHEN MOD(LEVEL, 4) = 0 THEN NULL
        ELSE ROUND(DBMS_RANDOM.VALUE(10,500)) 
    END                              AS discount
FROM dual
CONNECT BY LEVEL <= 1000;

