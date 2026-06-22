
drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountpercent numeric(5,2),
availableQuantity Integer,
discountedSellingPrice Numeric(8,2),
weightIn
)

-----Data Exploration

----count of rows
select count(*) from zepto;


----Sample Data
select * from zepto
limit 10;

----Null Values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null;


-------Different Product Categories
select Distinct category from zepto
order by category;	


------Product in stock VS Out of Stock
select outofstock, count(sku_id)
from zepto
group by outofstock;

----Product Names Present Multiple Times
Select name, count(sku_id) as "No of SKUs"	 
from zepto
group by name
order by count(sku_id) desc;

----Data Cleaning


----products with price = 0
select * from zepto
where mrp = 0 or discountedsellingprice = 0;

Delete from zepto
where mrp = 0;

------Convert Paise to Rupees
update zepto 
set mrp = mrp/100.0, 
discountedsellingprice = discountedsellingprice/100.0;

select mrp, discountedsellingprice from zepto;



-- Q1. Find the top 10 best-value products based on the discount percentage.  

select Distinct name, mrp, discountedsellingprice, discountpercent 
from zepto
order by discountpercent desc
limit 10;


-- Q2. What are the Products with High MRP but Out of Stock  

Select Distinct name, Mrp, outofstock 
from zepto
where outofstock is true and mrp > 300
order by Mrp desc;

-- Q3. Calculate Estimated Revenue for each category  

select distinct category, 
sum(discountedsellingprice * availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.  

select distinct name, mrp, discountpercent
from zepto
where mrp > 500 and discountpercent < 10 
order by mrp desc, discountpercent desc;  


-- Q5. Identify the top 5 categories offering the highest average discount percentage. 

select category, round(avg(discountpercent),2) as Avg_discount_percentage
from zepto
group by category
order by avg_discount_percentage desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

select distinct name, discountedsellingprice, weightingms,
round(discountedsellingprice/weightingms,2) as price_per_gram 
from zepto
where weightingms >= 100 
order by price_per_gram;



-- Q7. Group the products into categories like Low, Medium, Bulk.  

select distinct name, weightingms,
case when weightingms < 1000 then 'low'
     when weightingms < 5000 then 'Medium'
	 Else 'Bulk'
	 End as Weight_category
from zepto;
 

-- Q8. What is the Total Inventory Weight Per Category

select category, 
sum(weightingms * availablequantity) as total_weight
from zepto
group by category
order by total_weight desc; 
 

