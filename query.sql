-- Diving into CovidDeaths table
select *
from CovidDeaths
where continent != ""
order by 3,4;

select location
from CovidDeaths
where continent != "";

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1, 2;

select distinct location 
from CovidDeaths
where continent = "Asia";

-- looking at total cases vs. total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location in ("United States");

-- looking at total cases vs population

select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
from CovidDeaths 
where location in ("United States");

-- looking at countries with highest infection rate compared to population
select location, population, MAX(total_cases) as MaxCases, MAX(total_cases/population)*100 as InfectionPercentage
from CovidDeaths
group by location, population
order by InfectionPercentage desc;

-- showing countries with highest death rate compared to population
select location, MAX(CAST(total_deaths as UNSIGNED)) as MaxDeaths
from CovidDeaths
where continent != ""
group by location
order by MaxDeaths desc;

select continent, MAX(CAST(total_deaths as UNSIGNED)) as MaxDeaths
from CovidDeaths
where continent != ""
group by continent
order by MaxDeaths desc;

select location, MAX(CAST(total_deaths as UNSIGNED)) as MaxDeaths
from CovidDeaths
where continent = ""
group by location
order by MaxDeaths desc;

-- global numbers

select sum(new_cases) as TotCases, sum(new_deaths) as TotDeaths, 100*(sum(new_deaths)/sum(new_cases)) as DeathRate
from CovidDeaths
where continent != ""
-- group by date
order by 1,2;

-- Diving into CovidVaxx table
select * 
from CovidDeaths as dea
join CovidVaxx as vax
on dea.location = vax.location and dea.date = vax.date;

-- Looking at total vaxx vs total population
select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, sum(cast(vax.new_vaccinations as unsigned)) OVER (partition by dea.location order by dea.location,dea.date) as roll
from CovidDeaths as dea
join CovidVaxx as vax
on dea.location = vax.location and dea.date = vax.date
where dea.continent != ""
order by 2, 3;

-- use CTE (common table expression)
with PopvsVac (continent, location, date, population, new_vaccinations, roll) 
as(
select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, sum(cast(vax.new_vaccinations as unsigned)) OVER (partition by dea.location order by dea.location,dea.date) as roll
from CovidDeaths as dea
join CovidVaxx as vax
on dea.location = vax.location and dea.date = vax.date
where dea.continent != ""
order by 2, 3
)
select *, (roll/population) * 100
from PopvsVac;


-- use TEMP table (alternative to CTE)
-- Drop table PercentPopulationVaccinated;

Create Temporary Table PercentPopulationVaccinated
(
Continent NVARCHAR(255), 
Location nvarchar(255), 
Date datetime,
Population numeric, 
new_vaccinations numeric, 
roll numeric
);

-- not working
Insert into PercentPopulationVaccinated(Continnent, Location, Date, Population, new_vaccinations, roll)
Values(select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, sum(cast(vax.new_vaccinations as unsigned)) OVER (partition by dea.location order by dea.location,dea.date) as roll
from CovidDeaths as dea
join CovidVaxx as vax
on dea.location = vax.location and dea.date = vax.date
where dea.continent != ""
order by 2, 3)
;

-- not working
select *, (roll/population) * 100
from PercentPopulationVaccinated;

-- creating view to store data for later visualization

Create View PercentPopulationVaccinated AS
select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, sum(cast(vax.new_vaccinations as unsigned)) OVER (partition by dea.location order by dea.location,dea.date) as roll
from CovidDeaths as dea
join CovidVaxx as vax
on dea.location = vax.location and dea.date = vax.date
where dea.continent != "";
-- order by 2, 3

Select * from PercentPopulationVaccinated;

