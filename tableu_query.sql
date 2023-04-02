-- queries for Tableu Public (cannot link to database)

-- 1. 
select sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned)) as total_deaths, 100*sum(cast(new_deaths as unsigned))/sum(new_cases) as death_rate 
from CovidDeaths
where continent != ""
order by 1, 2; 

-- 2. 
select location, sum(cast(new_deaths as unsigned)) as total_deaths
from CovidDeaths
where continent != ""
and location not in ("World", "European Union", "International")
group by location
order by total_deaths desc;

-- 3. 
select location, population, max(total_cases) as highest_infection_count, max(total_cases/population)*100 as infected_population_percentage
from CovidDeaths
group by location, population
order by infected_population_percentage desc; 

-- 4. 
select location, population, date, max(total_cases) as total_cases, max(total_cases/population)*100 as infected_population_percentage
from CovidDeaths
group by location, population, date
order by infected_population_percentage desc;