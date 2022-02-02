SELECT *
FROM PortfolioProject..Covid_Deaths
Where continent is not null
Order by 3,4

--SELECT *
--FROM PortfolioProject..Covid_Vaccinations
--Order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths,population
FROM PortfolioProject..Covid_Deaths
Order by 1,2

--Total Cases Vs Total Deaths  [Death Percentage]

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%ndia'
Order by 1,2

-- Total Cases Vs Population
SELECT Location, date, population, total_cases,(total_cases/population)*100 AS PopulationPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%ndia'
Order by 1,2

--Countries with Highest Infection rate Vs Population

SELECT Location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 AS InfectionPercentage
FROM PortfolioProject..Covid_Deaths
Group by location, population
Order by InfectionPercentage DESC

--Countries with Highest Death Count per population

SELECT Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
Where continent is not null
Group by location
Order by TotalDeathCount DESC

 --Breaking BY CONTINENT
 
SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
Where continent is not null
Group by continent
Order by TotalDeathCount DESC

--CONTINENT with Highest Death Count

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
Where continent is not null
Group by continent
Order by TotalDeathCount DESC

-- GLOABL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast (new_deaths as int)) as total_deaths, SUM(cast (new_deaths as int)) / SUM(new_cases) *100 as DeathPercentage
FROM PortfolioProject..Covid_Deaths
Where continent is not null
Order by 1,2


   --Total Population Vs New_Vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


---USE CTE
With PopvsVac (Continent,Location,Date,population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)







-- TEMP TABLE
 
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric 
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

SELECT *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--CREATING VIEW

Create View PercentPopulationVaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

SELECT *
FROM PercentPopulationVaccinated

