CREATE VIEW rfm_view
AS
	WITH RFM AS(
		SELECT customer_name, 
			   MAX(order_date) AS most_recent_order, 
			   (SELECT MAX(OrderDate) FROM US_Regional_Sales.dbo.['Sales Orders Sheet$']) AS max_order_date, 
			   DATEDIFF(DD, MAX(order_date), (SELECT MAX(OrderDate) FROM US_Regional_Sales.dbo.['Sales Orders Sheet$'])) AS recency,
			   COUNT(order_number) AS frequency, 
			   SUM(order_quantity*unit_price) AS monetary,
			   NTILE(3) OVER (ORDER BY DATEDIFF(DD, MAX(order_date), (SELECT MAX(OrderDate) FROM US_Regional_Sales.dbo.['Sales Orders Sheet$'])) DESC) AS rfm_recency_score,
			   NTILE(3) OVER (ORDER BY COUNT(order_number)) AS rfm_frequency_score,
			   NTILE(3) OVER (ORDER BY SUM(order_quantity*unit_price)) AS rfm_monetary_score
		FROM
		(
			--Base Query to get all necessary columns
			SELECT ord.OrderNumber AS order_number, 
				   ord.[Sales Channel], 
				   ord.OrderDate AS order_date, 
				   ord._CustomerID, 
				   cus.[Customer Names] AS customer_name,
				   ord._ProductID, prod.[Product Name],
				   ord.[Order Quantity] AS order_quantity, 
				   ord.[Unit Price] AS unit_price, 
				   ord.[Unit Cost] --unit cost can  be used for profit margin calculations
			FROM US_Regional_Sales.dbo.['Sales Orders Sheet$'] ord
			JOIN US_Regional_Sales.dbo.['Customers Sheet$'] cus
				ON (ord._CustomerID=cus._CustomerID)
			JOIN US_Regional_Sales.dbo.['Products Sheet$'] prod
				ON (ord._ProductID=prod._ProductID)
		) t
		GROUP BY customer_name
	),
	RFM_calc AS(
		SELECT *, rfm_recency_score+rfm_frequency_score+rfm_monetary_score AS total_rfm_score, CAST(rfm_frequency_score AS varchar)+CAST(rfm_monetary_score AS varchar)+CAST(rfm_recency_score AS varchar) AS rfm_string
		FROM RFM
	)
	SELECT *, 
		   CASE
			  WHEN  total_rfm_score BETWEEN 1 AND 3 THEN 'Bronze'
			  WHEN  total_rfm_score BETWEEN 4 AND 6 THEN 'Silver'
			  WHEN  total_rfm_score BETWEEN 7 AND 9 THEN 'Gold'
			  WHEN  total_rfm_score BETWEEN 10 AND 12 THEN 'Platinum'
		   END AS category
	FROM RFM_calc

