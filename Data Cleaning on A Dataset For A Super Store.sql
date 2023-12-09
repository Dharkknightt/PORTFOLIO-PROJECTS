/* WORKING ON A DATASET FOR A SUPERSTORE */

create database PROJECTS

use PROJECTS

/* IMORTED THE CSV FILE INTO THE PROJECTS DATABASE */

select * from SampleSuperstore 
where Ship_Mode is null 
or Segment is null
or Country is null
or City is null
or State is null
or Postal_Code is null
or Region is null
or Category is null
or Sub_Category is null
or Sales is null
or Quantity is null
or Discount is null
or Profit is null




/* DELETING THE ROW WITH A NULL VALUE */

delete from SampleSuperstore 
where Profit is null



/*SELECTING FROM THE TABLE */

select * from SampleSuperstore 
select top 100 * from SampleSuperstore;



/* FINDING THE TOTAL NUMBER OF EACH SHIPMENT MODE */

select count(*)as Total_Number, Ship_Mode from SampleSuperstore group by Ship_Mode



/* MODIFYING THE DATATYPES OF SOME COLUMNS */

alter table samplesuperstore alter column sales int 
alter table samplesuperstore  alter column discount decimal(3,2)
alter table samplesuperstore alter column 




/* CREATING A NEW COLUMN "PROFIT_MARGIN" */

alter table samplesuperstore add Profit_Margin varchar(20)


/* POPULATING THE "PROFIT_MARGIN" COLUMN" */

update samplesuperstore set profit_Margin = 
case
when profit > 0 then 'PROFIT'
When Profit < 0 then 'LOSS'
When Profit = 0 then 'Break-even'
End




/* MODIFYING THE PROFIT COLUMN DATATYPE */

Alter table samplesuperstore alter column profit decimal (6,2);



/* VIEWING SOME DATA BY ORDER OF THE POSTAL CODE */

select postal_code, region, samplesuperstore.State, country, city from samplesuperstore
group by Region, samplesuperstore.state, Country, City, Postal_Code
order by Postal_Code asc;


/* DETERMINING THE TOTAL SALES OF THE FIRST 100 ROWS OF DATA */

select sum(sales) as total_sales
from (select top 100 sales from SampleSuperstore)
as total_sales
