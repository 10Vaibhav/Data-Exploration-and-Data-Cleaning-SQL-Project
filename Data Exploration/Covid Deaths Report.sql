select * 
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4;

--select * 
--From PortfolioProject ..
--CovidVaccinations
--where continent is not null
--order by 3,4;

-- Select Data that we are going to be using 

Select location, date, total_cases, new_cases, total_deaths,population
From PortfolioProject .. CovidDeaths
where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- shows likelihood of dying if you contact covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject .. CovidDeaths
where location like 'india'
and continent is not null
order by 1,2


-- Looking at Total Cases vs Population 
-- Shows what percentage of population got covid

Select location, date, total_cases, population, (total_cases/population)*100 as infectedPercentage
From PortfolioProject .. CovidDeaths
where location like 'india'
and continent is not null
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population,Max(total_cases)as HighestInfectionCount,Max((total_cases/population)*100) as PercentPopulationInfected
From PortfolioProject .. CovidDeaths
--where location like 'india'
where continent is not null
Group by location, population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population

select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject .. CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


-- Let's break things down by continent
-- showing continents with the highest death counts

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject .. CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- Global Numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
From PortfolioProject ..CovidDeaths as dea
join PortfolioProject ..CovidVaccinations as vac
on	dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

With PopVsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject ..CovidDeaths as dea
join PortfolioProject ..CovidVaccinations as vac
on	dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population) * 100 
from PopVsVac


-- TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into  #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject ..CovidDeaths as dea
join PortfolioProject ..CovidVaccinations as vac
on	dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population) * 100 
from #PercentPopulationVaccinated


-- creating view to store data for later visualizations

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
From PortfolioProject ..CovidDeaths as dea
join PortfolioProject ..CovidVaccinations as vac
on	dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
