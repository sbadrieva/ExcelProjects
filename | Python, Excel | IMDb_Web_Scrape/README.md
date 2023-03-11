# Excel Project 3: IMDb Web Scraping project for automatic data collection and cleaning 

## Author
Shokhina Badrieva
(shokhina.badrieva@gmail.com)

<br>

## Files
WebScraping.ipynb holds the python sript to web scrape IMDb 2023 movies,
2023Movies.xlsx holds raw data of web scraping project, and
2023Movies_Clean.xlsx holds clean data of web scraping project.

## Business Problem and Motivation
The goal of this project is to automatically collect data on 2023 movies on IMDb by using python library Beautiful Soup and saving the results in a Pandas Dataframe.
The following variables are extracted for every movie: movie_title, movie_rating, metascore, genre, votes and blurb.
After scraping the data, I placed it into a dataframe and converted the table to an excel file. The excel file was then cleaned further to remove any unecessary characters, normalize/validate columns, and make data consistent.

<br>

## Data Source
The data source is an IMDb website detailing all movies from 2023 so far. [Link to website]([https://data.world/datagov-uk/9666e74f-016d-4ecf-990a-b215637479b5](https://www.imdb.com/search/title/?title_type=feature&year=2023-01-01,2023-12-31))

<br>

## Methods/Skills Used
The project utilizes the following skills:
* Python ipynb
* Python pandas
* Python beautifulsoup
* Web Scraping
* Data Cleaning in Excel
* Complex Functions in Excel

<br>

## Quick Glance at Results 
![Alt text](Report_Glance.jpg "Travel Expense Report")


<br>

## Business Insights and Use
A business can automatically scrape and clean the results of the movie information, and have it outpputted into a .csv or .xlsx file. They will be able to collect thousands of rows of information in minutes.

<br>

## Note
The python script may need to change if the website changes. Each individual element may need to be adjusted if tags or class names change.
