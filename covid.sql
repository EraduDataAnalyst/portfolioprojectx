select *
from coviddeaths
where continent is not null
order by 3,4;

select *
from  CovidVaccinations
order by 3,4

select count(*)
from covidvaccinations

select continent, count(continent)
from coviddeaths
group by continent

select count(*)
from coviddeaths

select *
from covidvaccinations
order by 3,4





select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2;

--looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
order by 1,2;

-- looking at total cases vs total deaths in country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2;

-- what perecentage of population has covid
select location, date, total_cases, (total_cases/population)*100 as CovidPercentage
from CovidDeaths
where location like '%states%'
order by 1,2;

-- look at countries with highest infection rate compared by population
select location, population, MAX(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PerecentPopulationInfected
from CovidDeaths
group by location, population
order by PerecentPopulationInfected desc;


-- showing countries by highest death count per population--- revisit36:00
select location, MAX(CONVERT(int, total_deaths)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc;

-- break things down by continent---
 select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

--  global numbers
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
order by 1,2;

-- join both tables
select *
from coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date = vac.date

-- looking for total populations vs vaccinations --
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date = vac.date
order by 1,2,3;

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY DEA.LOCATION)
from coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
from coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- TEMP TABLE
drop if it
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar (255),
dare datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
from coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- create view to store data for visualization later
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
from coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


select *
from PercentPopulationVaccinated



