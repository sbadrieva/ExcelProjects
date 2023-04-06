----COHORT RETENTION ANALYSIS----

---The following SQL query is performed to find the cohort retention rates for a company's online retail sales. 

---First we will clean the dataset and get rid of records that don't have information we need.
--135,080 records do not have a customer ID. We will only look at the records with a customer ID.
--406,829 records do have an ID.

DROP TABLE IF EXISTS #online_retail_clean
;WITH online_retail AS
(
SELECT *
FROM Cohort_Analysis.dbo.Online_Retail
WHERE CustomerID is NOT NULL AND Quantity>0 AND UnitPrice>0
)
, duplicate_data AS
(
--Some records do not have positive values for qantity and unit price, these are purchases that had issues. We will remove them. 397,884 rows remain.
SELECT *, ROW_NUMBER() OVER (PARTITION BY InvoiceNo, StockCode,Quantity ORDER BY InvoiceDate) AS dup_flag
FROM online_retail
)
--Some records are duplicates so we will remove those as well. We are left with 392,669 records.
--This is now the clean data that we will use in our cohort analysis. We will put this result into a temp table called #online_retail_clean.
SELECT *
INTO #online_retail_clean
FROM duplicate_data
WHERE dup_flag=1


---We now have our clean data and can begin cohort analysis.
--We will group by customer, find the date of their first transaction, and use date from parts to get just month and year.
--We will make the day 01 for all dates because cohorts will be grouped by month. We will put the results into a temp table called #cohort.

DROP TABLE IF EXISTS #cohort
SELECT CustomerID, MIN(InvoiceDate) AS first_purchase_date, DATEFROMPARTS(year(min(InvoiceDate)), month(min(InvoiceDate)),1) AS Cohort_Date
INTO #cohort
FROM #online_retail_clean
GROUP BY CustomerID

--We want to now find the cohort index value for each transaction. This is the number of months that have passed since the first date the customer made a purchase. To do this we will join our clean retail dataset with the cohort table that has the first date of purchase for each customer. We will then find the difference in months for each transaction the customer made to find the cohort index for that transaction.
DROP TABLE IF EXISTS #cohort_index_table
SELECT o.*, c.Cohort_Date, DATEDIFF(MM,c.Cohort_Date,o.InvoiceDate)+1 AS cohort_index
INTO #cohort_index_table
FROM #online_retail_clean AS o
LEFT JOIN #cohort AS c
	ON o.CustomerID=c.CustomerID


--The usage of the DISTINCT keyword comes when the user wants to return unique rows in a column of a table in the result. So rows with complete duplicates will not be shown.
SELECT DISTINCT CustomerID,Cohort_Date,cohort_index
FROM #cohort_index_table
ORDER BY 1,3


--Using the above query we will create a pivot table of count of customer id's for each cohort index and month.
DROP TABLE IF EXISTS #cohort_pivot
SELECT *
INTO #cohort_pivot
FROM(
	SELECT DISTINCT CustomerID,Cohort_Date,cohort_index
	FROM #cohort_index_table
) tbl
pivot(
	COUNT(CustomerID)
	FOR cohort_index IN
	(
	[1],
	[2],
	[3],
	[4],
	[5],
	[6],
	[7],
	[8],
	[9],
	[10],
	[11],
	[12],
	[13])
) AS pivot_table
ORDER BY 1


--We will make another pivot table that shows the results as  rates.
DROP TABLE IF EXISTS #cohort_pivot_percent
SELECT Cohort_Date,
	   (1.0*[1]/[1])*100 AS [1],
	   (1.0*[2]/[1])*100 AS [2],
	   (1.0*[3]/[1])*100 AS [3],
	   (1.0*[4]/[1])*100 AS [4],
	   (1.0*[5]/[1])*100 AS [5],
	   (1.0*[6]/[1])*100 AS [6],
	   (1.0*[7]/[1])*100 AS [7],
	   (1.0*[8]/[1])*100 AS [8],
	   (1.0*[9]/[1])*100 AS [9],
	   (1.0*[10]/[1])*100 AS [10],
	   (1.0*[11]/[1])*100 AS [11],
	   (1.0*[12]/[1])*100 AS [12],
	   (1.0*[13]/[1])*100 AS [13]
INTO #cohort_pivot_percent
FROM #cohort_pivot
ORDER BY 1


--See our final results.
SELECT * FROM #cohort_pivot ORDER BY 1
SELECT * FROM #cohort_pivot_percent ORDER BY 1


----HOW TO INTERPRET RESULTS----
--The cohort date represents the month that a customer made a first purchase in the company. So for example, in the month of December, 2010, 885 new customers made a purchase. The cohort index represents how many customers made a purchase the second month, third month, fourth month, etc for each cohort period. 
--So for example, of the 885 new customers in December, 2010, 324 of them made a purchase in January. 286 of them made a purchase in February and so on. This analysis can help us show how many customers in each cohort (time they started purchasing from the company) we are able to retain over time. 
--This analysis is not a stand alone analysis that can give direct insights as to why the cohort retention is lower for some groups, but combined with more analyses this gives a very good overvue on the number of customers a company is able to retain over time. 