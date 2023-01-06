

--select*from guided..CovidVaccination
--order by 3, 4
select Location,date,Total_cases, New_cases,total_deaths, Population
FROM guided..CovidDeaths
order by 1,2

--percentage of population got covid
select Location,date,population,Total_cases,(total_cases/population)*100 as percentpopulation
FROM guided..CovidDeaths
where location='Egypt' and continent is not null
order by 1,2

-- looking at countries with Highest Infection Rate
select Location,population,max(Total_cases)as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
FROM guided..CovidDeaths
--where location='Egypt'
group by location,population 
order by PercentPopulationInfected desc

-- SHOWING COUNTRIES WITH HIGHEST COUNT PER POPULATION 
select location,Max(Cast(Total_deaths as int)) as Totaldeathcount
FROM guided..CovidDeaths
--where location='Egypt'  
where continent is not null
group by location
order by Totaldeathcount desc

-- let's breakdown things by continent
select continent,Max(Cast(Total_deaths as int)) as Totaldeathcount
FROM guided..CovidDeaths
--where location='Egypt'  
where continent is not null
group by continent
order by Totaldeathcount desc

-- showing  the continent with  the highest death count 

-- SHOWING COUNTRIES WITH HIGHEST COUNT PER POPULATION 
select continent,Max(Cast(Total_deaths as int)) as Totaldeathcount
FROM guided..CovidDeaths
--where location='Egypt'  
where continent is not null
group by continent
order by Totaldeathcount desc

--breaking numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from guided..coviddeaths
where continent is not null
--group by date
order by 1,2
-- lookin at total population vs vaccination 
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as BIGINT)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from guided..CovidDeaths as  dea 
 join guided..CovidVaccination  as vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent  is not null
 order by 2,3


 -- USE CTE
 with popvsvac(continent, location, date, population,new_vaccinations, Rollingpeoplevaccinated)
 as (
 select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as BIGINT)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from guided..CovidDeaths as  dea 
 join guided..CovidVaccination  as vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent  is not null
-- order by 2,3
 )
 select *,(Rollingpeoplevaccinated/population)*100 from popvsvac
 drop table if exists  #PercentPopulationVacinated
 create table #PercentPopulationVacinated

 (Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 population numeric,
 new_vaccination numeric,
Rollingpeoplevaccinated numeric
 )
 insert into  #PercentPopulationVacinated
 select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as BIGINT)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from guided..CovidDeaths as  dea 
 join guided..CovidVaccination  as vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent  is not null
 order by 2,3

 select *,(Rollingpeoplevaccinated/population)*100 from #PercentPopulationVacinated

 --creating view to store data later for vis

 create view PercentPopulationVacinated as
  select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as BIGINT)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from guided..CovidDeaths as  dea 
 join guided..CovidVaccination  as vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent  is not null
 --order by 2,3

 select * from PercentPopulationVacinated