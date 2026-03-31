

1. Data Understanding
Manager Requirement:
Give me overall business performance summary for the last quarter.
  
Questions:
1.	Find total number of transactions.
select count(sale_id) from sales;

2.	Find total revenue generated.
select sum(amount) as revenue from sales;
 
3.	Find total unique customers.
select count(distinct CUSTOMER_ID) as unique_cust  from customers;

4.	Find average order value.
select sum(amount)/count(*) as average from sales;

5.	Find total quantity sold.
select sum(quantity) as quantity_sold from sales;

6.	Find minimum and maximum sale amount.
select max(amount) as max_val ,min(amount) as min_val from sales;

7.	Find average discount given.
select avg(discount) from sales;


8.	Find total sales per store.
select s.store_name, sum(sa.amount) as rev from stores s join sales sa on s.store_id=sa.store_id group by s.store_name;

 

9.	Find total sales per category.
select p.category, sum(sa.amount) as rev from products p join sales sa on p.PRODUCT_ID=sa.product_id group by p.CATEGORY;

 

10.	Find number of transactions per day.
select sale_date,count(*) as daily_tnsn from sales group by sale_date ORDER by sale_date;

 

2. Data Cleaning
Manager Requirement:
Data looks inconsistent, fix NULL issues before analysis.
Questions:
11.	Replace NULL discount with 0.
select sale_id,nvl(discount,0) as rep from sales;

 

12.	Find number of NULL discounts.
select count(*) as null_val from sales where discount is null;

 

13.	Calculate net revenue (amount - discount).

select sum(amount-nvl(discount,0)) as net_rev from sales;

 

14.	Replace NULL quantity with 1.

select nvl(quantity,1) from sales;

 

15.	Identify rows where amount is NULL.

SELECT * FROM sales WHERE amount IS NULL;

 

16.	Use COALESCE to handle multiple NULL columns.

Select  sale_id, COALESCE(amount, 0)   as amount_cleaned, COALESCE(quantity, 1) as quantity_cleaned,  COALESCE(discount, 0) as discount_cleaned from sales;

 


17.	Create a cleaned column for revenue.

select sale_id,nvl(amount,0)- nvl(discount,0) as rev from sales;

 

18.	Check percentage of missing data.
select count(case when amount is null then 1 END)  /count(*) * 100 as per_amt,
count(case when quantity is null then 1 END) /count(*) * 100 as per_qnt,count(case when discount is null then 1 END) /count(*) * 100 as per_dis from sales;

 

19.	Flag rows with missing values.
select sale_id ,case when amount is null or quantity is null or discount is null then 'Missing' else 'Complete' end  as flag from sales;

 

20.	Prepare dataset for analysis.

create or replace view sales_cleaned as select sale_id,customer_id,store_id, product_id, sale_date, nvl(amount,0) as amount,nvl(quantity,1) as quantity, nvl(discount,0) as discount,  (nvl(amount,0) - nvl(discount,0)) as net_revenue from sales;
3. Filtering (WHERE)
Manager Requirement:
I want specific insights based on conditions.
Questions:
21.	Find sales in last 30 days.
select * from sales where sale_date > sysdate-30;
select * from sales where sale_date between date '2025-02-01' and date '2025-03-01';

 

22.	Find sales above 5000.
select sale_id,amount from sales where amount>5000;


 


23.	Find sales between 1000 and 5000.
select sale_id,amount from sales where amount between 1000 and 5000;

 

24.	Find sales from CMR store.
select  sale_id,s.STORE_NAME from sales sa join stores s on sa.store_id=s.store_id where s.store_name='CMR';

 


25.	Find Electronics category sales.
select  sa.sale_id,p.category from  sales sa join products p  on p.product_id=sa.product_id where p.category='Electronics';

 

26.	Find sales excluding Grocery category.
select  sale_id,p.category from  sales sa join products p  on p.product_id=sa.product_id where p.category not in('Grocery');
 

27.	Find customers from specific store.
SELECT DISTINCT c.customer_name,s.store_name FROM sales sa JOIN customers c ON sa.customer_id = c.customer_id JOIN stores s ON sa.store_id = s.store_id WHERE s.store_name = 'CMR';

 

28.	Find high discount transactions.
select sale_id,quantity from sales where discount>300;


 

29.	Find low quantity sales.
select   *  from sales where quantity <2;

 


30.	Find recent transactions.
select * from sales where sale_date between date '2025-03-21' and date '2025-03-30' ;
 select * from sales where sale_date =sysdate-10;

 

4. Aggregation (GROUP BY)
Manager Requirement:
Break down performance across business segments.
Questions:
31.	Revenue per store.
SELECT s.store_name, SUM(sa.amount) AS revenue FROM sales sa JOIN stores s ON sa.store_id = s.store_id GROUP BY s.store_name ORDER BY revenue DESC;

 


32.	Revenue per category.
SELECT p.category, SUM(s.amount) AS revenue FROM sales s JOIN products p ON p.product_id = s.product_id GROUP BY p.CATEGORY ORDER BY revenue DESC;

 


33.	Revenue per customer.
SELECT c.customer_name, SUM(sa.amount) AS revenue FROM sales sa left JOIN customers c ON sa.customer_id = c.customer_id GROUP BY c.customer_name ORDER BY revenue desc ;
 

34.	Monthly revenue.

SELECT EXTRACT(MONTH FROM sale_date) AS month,SUM(amount) AS revenue FROM sales GROUP BY  EXTRACT(MONTH FROM sale_date) ORDER BY  month;

 

35.	Daily revenue.
SELECT sale_date, SUM(amount) AS daily_revenue FROM sales GROUP BY sale_date ORDER BY sale_date;
 

36.	Average sales per store.

SELECT s.store_name, round(avg(sa.amount),2) AS revenue FROM sales sa JOIN stores s ON sa.store_id = s.store_id GROUP BY s.store_name ORDER BY revenue DESC;

 

37.	Total quantity per category.

SELECT p.category, SUM(s.quantity) AS quantity_per_category FROM sales s JOIN products p ON p.product_id = s.product_id GROUP BY p.CATEGORy;

 

38.	Total discount per store.
SELECT s.store_name, sum(nvl(sa.discount,0)) AS total_discount FROM sales sa JOIN stores s ON sa.store_id = s.store_id GROUP BY s.store_name;

 

39.	Customer-wise total spending.
SELECT c.customer_name, SUM(sa.amount) AS revenue FROM sales sa left JOIN customers c ON sa.customer_id = c.customer_id GROUP BY c.customer_name;

 

40.	Store-wise transaction count.

SELECT s.store_name, count(*) AS trans_count FROM sales sa JOIN stores s ON sa.store_id = s.store_id GROUP BY s.store_name order by trans_count desc;
 
5. HAVING
Manager Requirement:
Find top performing segments.
Questions:
41.	Customers with revenue > 20000.

SELECT c.customer_name, SUM(sa.amount) AS revenue FROM sales sa left JOIN customers c ON sa.customer_id = c.customer_id GROUP BY c.customer_name having SUM(sa.amount) > 110000 order by revenue DESC;

 


42.	Stores with revenue > 100000.

SELECT s.store_name, sum(amount) AS revenue  FROM sales sa left JOIN stores s ON sa.store_id = s.store_id GROUP BY s.store_name having sum(amount) > 100000;

 


43.	Categories with avg sales > 3000.

SELECT p.category, avg(s.amount) AS avg_sales FROM sales s JOIN products p ON p.product_id = s.product_id GROUP BY p.CATEGORy having avg(s.amount)>3000;

 


44.	Customers with more than 5 transactions.

SELECT c.customer_name, count(*) as transactions FROM sales sa  left JOIN customers c ON sa.customer_id = c.customer_id GROUP BY c.customer_name having count(*)>5;

 


45.	Stores with high discount usage.

SELECT s.store_name, sum(nvl(sa.discount,0)) AS total_discount FROM sales sa left JOIN stores s ON sa.store_id = s.store_id GROUP BY s.store_name having sum(nvl(sa.discount,0))>62000;

 

46.	Categories with low performance.

SELECT p.category,EXTRACT(MONTH FROM s.sale_date) AS month,SUM(s.amount) AS revenue FROM sales s JOIN products p ON p.product_id = s.product_id GROUP BY p.category, EXTRACT(MONTH FROM s.sale_date) HAVING SUM(s.amount) < 1190000 ORDER BY  month;

 


47.	Customers with high avg order value.

SELECT c.customer_name, avg(sa.amount) as avg_order_val FROM sales sa left JOIN customers c ON sa.customer_id = c.customer_id GROUP BY c.customer_name having avg(sa.amount)>4000;
 
48.	Find top 5 customers using HAVING.
SELECT c.customer_name, SUM(s.amount) AS total_revenue FROM sales s JOIN customers c ON s.customer_id = c.customer_id GROUP BY c.customer_name HAVING SUM(s.amount) > 100000  ORDER BY total_revenue DESC
FETCH FIRST 5 ROWS ONLY;   

 


49.	Stores with max transactions.

SELECT s.store_name, COUNT(*) AS transactions FROM sales sa JOIN stores s ON sa.store_id = s.store_id GROUP BY s.store_name ORDER BY transactions DESC FETCH FIRST 1 ROW ONLY;

 


50.	Categories with high growth.
select p.category,
 sum(case when extract(month from s.sale_date) = 1 then s.amount end) as jan_revenue, sum(case when extract(month from s.sale_date) = 2 then s.amount end) as feb_revenue,(sum(case when extract(month from s.sale_date) = 1 then s.amount end) sum(case when extract(month from s.sale_date) = 2 then s.amount end)) as growth from sales s 
 join products p on p.product_id = s.product_id group by p.category
having
  (sum(case when extract(month from s.sale_date) = 1 then s.amount end) 
         sum(case when extract(month from s.sale_date) = 2 then s.amount end)) > 0
order by growth desc;

 
6. CASE WHEN
Manager Requirement:
Segment customers for business decisions.
Questions:
51.	Classify customers as High/Medium/Low spenders.
SELECT c.customer_name,
       SUM(s.amount) AS total_spent,
      CASE 
         WHEN SUM(s.amount) >= 100000 THEN 'High Spender'
         WHEN SUM(s.amount) BETWEEN 90000 AND 100000 THEN 'Medium Spender'
         ELSE 'Low Spender'
       END AS spender_type
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id GROUP BY c.customer_name;
 


52.	Classify transactions as Big/Small.

select sale_id,amount,(case
 when amount>7000 then 'Big' else 'Small' end)
 as transactions from sales;

 

53.	Create discount flag.

select sale_id,discount,(case when discount>300 then 'Discount Applied' else 'Discount Not Applied' end) as flag from sales;

 

54.	Segment stores based on revenue.


select sa.store_name,sum(s.amount) as revenue, (case
 when sum(s.amount)>1700000 then 'Tier 1 store'
when sum(s.amount) between 1570000 and 1700000 then 'Tier 2 store'
 else 'tier 3 store' end ) as segment_stores 
from sales s  left join stores sa on s.store_id=sa.store_id group by sa.store_name;

 


55.	Categorize customers based on frequency.

select c.customer_name,count(*) as transactions,(case 
        when count(*) >15 then 'Frequent customer' 
when count(*) between 11 and 15 then 'Moderate customer ' else 'rare' end) as customer_frequency   from sales s left join customers c on s.customer_id=c.customer_id group by c.customer_name;

  

56.	Create sales buckets.

select sale_id ,  amount,
case 
         when amount < 1000 then 'bucket a: small'
        when amount between 1000 and 5000 then 'bucket b: medium'
         when amount between 5001 and 10000 then 'bucket c: large'
  else 'bucket d: very large'  end as sales_bucket  from sales;

 

57.	Identify premium customers.

select c.customer_name, count(*) as transactions,
       case 
         when count(*) > 15 then 'premium_customer'
        when count(*) between 10 and 15 then 'regular_customer'
         else 'rare_customer' end as prem_customers  from sales s
left join customers c on s.customer_id = c.customer_id  group by c.customer_name;

 


58.	Mark high-value transactions.

select sale_id,amount,(case when amount>9000 then 'High Value' else 'Low value' end) as tns from sales ;

 

59.	Classify categories based on performance.
select p.category, sum(s.amount) as revenue,
  case 
         when sum(s.amount) >= 1230000 then 'high performing'
         when sum(s.amount) between 1000000 and 1230000 then 'medium performing'
         else 'low performing'
       end as performance   from sales  s join products p on s.product_id = p.product_id  group by p.category;

 

60.	Create custom labels for reporting.
select sale_id,amount,case when amount>9000 then 'first' 
                     when amount between 5000 and 9000 then 'Second'
                     else 'Third' end as tns from sales ;

 
7. JOINS (Multiple Tables)
Manager Requirement:
Combine customer, product, and store data for insights.


Questions:
61.	Join sales with customers table.

SELECT s.sale_id, s.amount, c.customer_name
FROM sales s
left JOIN customers c ON s.customer_id = c.customer_id;

 

62.	Join sales with stores table.

SELECT s.sale_id, s.amount, sa.store_name
FROM sales s
left JOIN stores sa ON s.store_id = sa.store_id;

 


63.	Join sales with products table.

        SELECT s.sale_id, s.amount, p.product_id,p.category
FROM sales s
left JOIN products p ON s.product_id = p.product_id;
 


64.	Find customer name with store name and sales.

select c.customer_name,sa.store_name,sum(s.amount) as revenue from sales s left join customers c on s.customer_id=s.customer_id left join 
stores sa on s.store_id=sa.store_id group by c.customer_name,sa.store_name;

 


65.	Find category-wise revenue using joins.

select p.category,sum(s.amount) as revenue from sales s left join products p on s.product_id=p.product_id group by p.category order by revenue desc;

 

66.	Find store-wise customer count.

select s.store_name,count(distinct sa.customer_id) as cc from sales sa left join stores s on s.store_id=sa.store_id group by s.store_name;

 


67.	Find top product per store.

select store_name,   category,  revenue  from (
    select st.store_name,  p.category,  sum(s.amount) as revenue   rank() over (partition by        st.store_name order by sum(s.amount) desc) as rnk  from sales s
    join stores st on s.store_id = st.store_id
    join products p on s.product_id = p.product_id
    group by st.store_name, p.category
) t
where rnk = 1;

 


68.	Find customers who purchased from multiple stores.
select c.customer_name from sales sa left join customers c on c.customer_id=sa.customer_id 
 group by c.customer_name having count(distinct sa.store_id)>1;

 

69.	Find sales with product category.

select sa.sale_id,sa.amount,p.category from sales sa left join products p on p.product_id=sa.product_id;

 


70.	Find revenue per customer per store.

select c.customer_name,st.store_name,sum(s.amount) as revenue from sales s left join customers c on s.customer_id=c.customer_id 
left join stores st on s.store_id=st.store_id group by c.customer_name,st.store_name; 

 

71.	Find customers with no transactions (LEFT JOIN).

select c.customer_name from customers c left join sales s on c.customer_id=s.customer_id where s.sale_id is null;

 

72.	Find missing product mappings.

select s.sale_id from sales s left join products p  on s.product_id=p.product_id where p.product_id is null;
 

73.	Find store performance using joins.
SELECT st.store_name, SUM(s.amount) AS total_revenue
FROM sales s JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_name ORDER BY total_revenue DESC;

 

74.	Find cross-category purchases.

select c.customer_name  from sales s
join customers c on s.customer_id = c.customer_id
join products p on s.product_id = p.product_id
group by c.customer_name  having count(distinct p.category) > 1;

 


75.	Find total revenue using joins.
select st.store_name,  sum(s.amount) as total_revenue   from sales s   join stores st on s.store_id = st.store_id  group by st.store_name  order by total_revenue desc;

 




8. Window Functions
Manager Requirement:
Provide advanced analytics without losing row-level data.
Questions:
76.	Calculate total spend per customer using window function.

select customer_id,amount,sum(amount) over(partition by customer_id) as spend from sales;

 


77.	Rank customers by revenue.

select customer_id,sum(amount) as revenue,rank() over (order by sum(amount) desc) as rank from sales group by customer_id;


 


78.	Find top customer per store.
select *
from (
    select st.store_name,
           c.customer_name,
           sum(s.amount) as rev,
           rank() over (partition by st.store_name order by sum(s.amount) desc) as rnk
    from sales s
    join customers c on c.customer_id = s.customer_id
    join stores st on st.store_id = s.store_id
    group by st.store_name, c.customer_name
)where rnk = 1;

 


79.	Calculate running total of sales.

select sale_date,amount,sum(amount) over (order by sale_date rows between unbounded preceding and current row) as running_total
from sales;

 


80.	Find previous sale using LAG.

select sale_id, sale_date, amount, lag(amount) over (order by sale_date) as previous_sale
from sales;

 

81.	Find next sale using LEAD.
select sale_id, sale_date, amount, lead(amount) over (order by sale_date) as nextday_sale from sales;

 


82.	Calculate sales growth.

select sale_id,sale_date,amount, lag(amount) over (order by sale_date) as lag,
   amount - lag(amount) over (order by sale_date) as sales_growth from sales;


 


83.	Find difference between transactions.

select sale_id, sale_date, amount, amount - lag(amount) over (order by sale_date) as diff
from sales;

 

84.	Calculate cumulative revenue.

select sale_date,amount,sum(amount) over (order by sale_date rows between unbounded preceding and current row) as cumulative_revenue
from sales;

 


85.	Find moving average of sales.

select sale_id,sale_date,amount,avg(amount) over (order by sale_date rows between 2 preceding and current row) as moving_avg from sales;

 


86.	Rank stores by revenue

 select st.store_name,sum(s.amount) as revenue,rank() over (order by sum(s.amount) desc) as store_rank  from sales s join stores st on s.store_id = st.store_id
group by st.store_name;

 


87.	Find second highest sale.

select amount from (select amount,dense_rank() over (order by amount desc) as rnk
from sales)where rnk = 2;

 

88.	Partition data by store and analyze.

select st.store_name,s.sale_id,s.amount,sum(s.amount) over (partition by st.store_name) as store_total  from sales s join stores st on s.store_id = st.store_id;

 

89.	Find customer ranking per store.

select st.store_name,c.customer_name,sum(s.amount) as revenue,
       rank() over (partition by st.store_name order by sum(s.amount) desc) as rank_in_store  from sales s  join stores st on s.store_id = st.store_id
join customers c on c.customer_id = s.customer_id
group by st.store_name, c.customer_name;

 
90.	Calculate frequency using window.

select customer_id,sale_id,
       count(*) over (partition by customer_id) as transaction_count from sales;

 

9. NTILE / Segmentation
Manager Requirement:
Segment customers for marketing.
Questions:
91.	Divide customers into 4 segments.
select customer_id,sum(amount) as revenue,ntile(4) over (order by sum(amount) desc) as segment from sales group by customer_id;

 


92.	Identify top 25% customers.

select customer_id,sum(amount) as revenue,ntile(4) over (order by sum(amount) desc) as quartile,
     case 
         when ntile(4) over (order by sum(amount) desc) = 1 
       then 'top 25% customer' 
           else 'bottom 75% customer'
       end as segment
from sales group by customer_id

 



93.	Identify bottom 25% customers.

select customer_id, sum(amount) as revenue,ntile(4) over (order by sum(amount) desc) as quartile,
       case 
          when ntile(4) over (order by sum(amount) desc) = 4
           then 'bottom 25% customer' 
           else 'top 75% customer'
       end as segment
from sales group by customer_id;

 


94.	Segment stores into 3 groups.

select store_id, sum(amount) as revenue,
    ntile(3) over (order by sum(amount) desc) as store_segment  from sales group by store_id;

  


95.	Create quartiles based on revenue.

select customer_id,sum(amount) as revenue,ntile(4) over (order by sum(amount) desc) as revenue_quartile  from sales group by customer_id;

 


96.	Segment customers per store.

select st.store_name, c.customer_name, sum(s.amount) as revenue,  ntile(4) over (partition by st.store_name order by sum(s.amount) desc) as segment_in_store 
 from sales s join stores st 
on s.store_id = st.store_id join customers c on c.customer_id = s.customer_id group by st.store_name, c.customer_name;

 


97.	Identify premium segment.

select customer_id,
       sum(amount) as revenue,
       ntile(4) over (order by sum(amount) desc) as quartile,
       case 
           when ntile(4) over (order by sum(amount) desc) = 1 
           then 'top 25% customer'
           else 'other'
       end as segment
from sales group by customer_id;

 


98.	Find mid-level customers.

select customer_id,
       sum(amount) as revenue,
       ntile(4) over (order by sum(amount) desc) as quartile,
       case 
           when ntile(4) over (order by sum(amount) desc) in (2,3) 
           then 'mid-level customer'
           else 'other'
       end as segment
from sales  group by customer_id;

 


99.	Analyze bucket distribution.

select customer_id,  sum(amount) as revenue,
       ntile(5) over (order by sum(amount) desc) as five_dis  from sales  group by customer_id;

 


100.	Create marketing segments.

select customer_id,
       sum(amount) as revenue,
       case 
           when ntile(4) over (order by sum(amount) desc) = 1 then 'premium'
           when ntile(4) over (order by sum(amount) desc) = 2 then 'high'
           when ntile(4) over (order by sum(amount) desc) = 3 then 'medium'
           else 'low'
       end as marketing_segment
from sales
group by customer_id;

 

10. FIRST_VALUE / LAST_VALUE
Manager Requirement:
Compare performance with best and worst.
Questions:
101.	Find highest sale.

select first_value(amount) over(order by amount desc) as high_value from sales;

 


102.	Find lowest sale.

select last_value(amount) over(order by amount desc rows between unbounded preceding and unbounded following ) as low_value from sales;
 


103.	Compare each sale with highest.

select sale_id,amount,first_value(amount) over(order by amount desc) as highest_sale,amount-first_value(amount) over(order by amount desc) as compare from sales;

 

104.	Compare each sale with lowest.

select sale_id,  amount,   
last_value(amount) over (   order by amount desc  
    rows between unbounded preceding and unbounded following) as lowest_sale,
   amount - last_value(amount) over (order by amount desc   rows between unbounded  preceding and unbounded following ) as compare from sales;

 

105.	Find highest sale per store.

select distinct st.store_name,first_value(s.amount) over(partition by st.store_name order by s.amount desc) as high_sale from sales s join stores st on s.store_id=st.store_id;

 

106.	Find lowest sale per store.

select distinct st.store_name,last_value(s.amount) over(partition by st.store_name order by s.amount desc rows between unbounded preceding and unbounded following) as low_sale from sales s join stores st on s.store_id=st.store_id;

 


107.	Compare category performance.

select p.category,sum(s.amount) as revenue,
       first_value(p.category) over (order by sum(s.amount) desc) as best_category,
       last_value(p.category) over (order by sum(s.amount) desc rows between unbounded preceding and unbounded following   ) as worst_category from sales s
join products p on s.product_id = p.product_id group by p.category;

 

108.	Find best customer per store.

select st.store_name, c.customer_name, sum(s.amount) as revenue,
      first_value(c.customer_name) over (partition by st.store_name order by sum(s.amount) desc) as best_customer  from sales s
join stores st on s.store_id = st.store_id
join customers c on c.customer_id = s.customer_id  group by st.store_name, c.customer_name;

 


109.	Find worst performing category.

select category,
       sum(s.amount) as revenue, last_value(category) over (  order by sum(s.amount) desc 
rows between unbounded preceding and unbounded following ) as worst_category from sales s
join products p on s.product_id = p.product_id group by category;
 

110.	Analyze gap between best and worst.

select distinct
       first_value(amount) over (order by amount desc) as best_amount,
       last_value(amount) over (order by amount desc rows between unbounded preceding and unbounded following   ) as worst_amount,
      (first_value(amount) over (order by amount desc) -last_value(amount) over ( order by amount desc  rows between unbounded preceding and unbounded following)) as gap
from sales;
 
11. Date Analysis
Manager Requirement:
Analyze time-based trends.
Questions:
111.	Find daily sales.

select extract(day from sale_date) as day,sum(amount) as daily_sales
              from sales group by extract(day from sale_date) order by day;

 


112.	Find monthly sales.

select extract(month from sale_date) as month, extract(day from sale_date) as day, sum(amount) as monthly_sales  from sales group by extract(month from sale_date), extract(day from sale_date)
order by month, day;

 


113.	Find weekend sales.

select sale_date, sum(amount) as weekend_sales from sales
  where to_char(sale_date,'dy') in ('sat','sun') group by sale_date  order by sale_date;

 

114.	Find first sale date.

              select min(sale_date) as first_day_sale from sales;

 

115.	Find last sale date.
  Select max(sale_date) as last_day_sale from sales;

 

116.	Find sales in specific month.

select sale_id,sale_date,amount from sales  where extract(year from sale_date) = 2025
  and extract(month from sale_date) = 3  order by sale_date;


 


117.	Find sales growth month-wise.

select year, month, monthly_sales, monthly_sales - lag(monthly_sales) over (order by year, month) as growth  from (
    select extract(year from sale_date) as year, extract(month from sale_date) as month,
    sum(amount) as monthly_sales from sales group by extract(year from sale_date), extract(month from sale_date)
) t;

 


118.	Find inactive customers (30 days).

  select c.customer_name  from customers c  left join sales s on c.customer_id = s.customer_id  group by c.customer_name  having max(s.sale_date) < current_date - interval '30' day;     

119.	Find repeat customers.

select c.customer_name  from sales s  join customers c on s.customer_id = c.customer_id  group by c.customer_name  having count(*) > 1;

120.	Find sales trend.

select sale_date, sum(amount) as daily_sales  from sales group by sale_date
order by sale_date;

 
