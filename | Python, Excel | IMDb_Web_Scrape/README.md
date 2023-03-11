# IMDbMovies2023
Data Collection through Web Scraping and Data Cleaning of IMDb movies in 2023.

# Files
WebScraping.ipynb holds the python sript to web scrape IMDb 2023 movies,
2023Movies.xlsx holds raw data of web scraping project, and
2023Movies_Clean.xlsx holds clean data of web scraping project.

# Details
The goal of this project is to automatically collect data on 2023 movies on IMDb by using python library Beautiful Soup and saving the results in a Pandas Dataframe.
The following variables are extracted for every movie: movie_title, movie_rating, metascore, genre, votes and blurb.
After scraping the data, I placed it into a dataframe and converted the table to an excel file. The excel file was then cleaned further to remove any unecessary characters, normalize/validate columns, and make data consistent.

# Skills
Python (ipynb, BeautifulSoup, Pandas), Excel (Data Cleaning, Excel Functions)

# Note
The python script may need to change if the website changes. Each individual element may need to be adjusted if tags or class names change.

