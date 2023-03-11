
/*
Covid 19 Data Exploration 
SQL Skills Utilized: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

--Script to view all columns in CovidDeaths and CovidVaccinations files
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM [PortfolioProject].[dbo].[CovidVaccinations]
--ORDER BY 3,4

--Select data that we are ging to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2


--Looking at Total Cases vs Total Deaths (Death Percentage) in the United States
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location='United States'
ORDER BY 1,2


--Looking at Total Cases vs Population (infetion rate_ in the United States
SELECT location, date, total_cases, population, (total_cases/population)*100 as infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE location='United States'
ORDER BY 1,2


--Looking at which countries have the highest infection rates compared to population?
 SELECT location, MAX(total_cases) AS highest_infection_count, (MAX(total_cases)/population)*100 AS infection_rate
 FROM PortfolioProject.dbo.CovidDeaths
 GROUP BY location, population
 ORDER BY infection_rate DESC


--Looking at which countries have the highest death count
SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent <> ''
GROUP BY location
ORDER BY total_death_count DESC


--Looking at which continents have the highest death count
 SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
 FROM PortfolioProject.dbo.CovidDeaths
 WHERE continent=''
 GROUP BY location
 ORDER BY total_death_count DESC


 --Global Numbers per day
 

 --Global Numbers overall
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS death_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent <> ''
ORDER BY 1,2


--Join Covid Deaths and Covid Vaccinations together
SELECT *
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date


--Look at Total Population vs. Total Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent <> ''
ORDER BY 2,3


--Rolling sum of total vaccinations by location and date
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccinations_rolling_sum
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date 
WHERE dea.continent <> ''
ORDER BY 2,3


--Use vaccination_rolling_sum and population to find the percent of people vaccinated in each location and date on a rolling basis
--Method 1: Use CTE
WITH  pop_vs_vac (continent,location, date, population, new_vaccinations,vaccinations_rolling_sum_CTE)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccinations_rolling_sum
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date 
WHERE dea.continent <> ''
)
SELECT *, (vaccinations_rolling_sum_CTE/population)*100 AS percent_pop_vaccinated
FROM pop_vs_vac
ORDER BY 2,3


--Method 2: Use Temp Table
DROP TABLE if exists PercentPopVaccinated
CREATE TABLE PercentPopVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinations_rolling_sum_temp numeric
)

INSERT INTO PercentPopVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, CAST(vac.new_vaccinations AS float), 
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccinations_rolling_sum_temp
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date 
WHERE dea.continent <> ''

SELECT *, (vaccinations_rolling_sum_temp/population)*100 AS percent_pop_vaccinated
FROM PercentPopVaccinated
ORDER BY 2,3


--Creating view to store data for later visualizations
USE PortfolioProject
GO
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, CAST(vac.new_vaccinations AS float) AS new_vaccinations, 
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccinations_rolling_sum_temp
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date 
WHERE dea.continent <> ''

