## Project 8: Cohort Retention Analysis using SQL and Tableau

## Author
Shokhina Badrieva (shokhina.badrieva@gmail.com)

<br>

## Business Problem and Motivation
Cohort retention analysis is useful because it allows companies to measure the long-term value of their customers, as well as identify areas where retention strategies can be improved. By tracking how different groups of customers behave over time, companies can gain insights into their customer base and tailor their marketing and retention efforts accordingly.

In our project, we will conduct a cohort retention analysis for an online sales company to determine the retention rate of customers acquired within specific time periods. This analysis will enable us to identify any trends or patterns in customer behavior over time and help us develop effective retention strategies to increase customer loyalty and revenue.

## Data Source
The data source is an in an excel file in this repository in the file titled "Online Retail". [Link to dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail)


## Methods/Skills Used
The project utilizes the following skills:

* SQL Join
* Temp Tables 
* Subqueries
* T-SQL pivot
* Tableau visualization


## Quick Glance at Results

![Alt text](Cohort_Analysis_Quick_Glance.jpg "Cohort_Retention")

## How to interpret the results and gain insights
The cohort date represents the month that a customer made a first purchase in the company. So for example, in the month of December, 2010, 885 new customers made a purchase. The cohort index represents how many customers made a purchase the second month, third month, fourth month, etc for each cohort period. 

So for example, of the 885 new customers in December, 2010, 324 of them made a purchase in January. 286 of them made a purchase in February and so on. This analysis can help us show how many customers in each cohort (time they started purchasing from the company) we are able to retain over time. 

This analysis is not a stand alone analysis that can give direct insights as to why the cohort retention is lower for some groups, but it is an essential tool in analyzing the retention of each cohort and with other analyses can paint a much better picture of how to retain more customer in a company.

## Tableau Public Link
[Link to visualization](https://public.tableau.com/app/profile/shokhina.badrieva/viz/Cohort_Retention_Analysis/Dashboard1)

## Credit
Done with the guidance of [Angelina Frimpong](https://www.youtube.com/watch?v=LXqpx9mr0Is).
