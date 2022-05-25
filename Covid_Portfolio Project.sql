
select location,date,total_cases,population from 
Project_protfolio..CovidDeaths coviddeath
order by 1,2  
--where iso_code='MWI'

--select Total cases and Tatal deaths with persentage
select location,date,total_cases,total_deaths,
population ,(total_deaths/total_cases)*100 as
death_persentages from Project_protfolio..CovidDeaths
where location like '%State%'
order by 1,2

--show how many peaople got covid
select location,date,total_cases,total_deaths,
population ,(total_cases/population)*100 as
covid_persentages from Project_protfolio..CovidDeaths
where location like '%State%'
order by 1,2

--looking at country with infection rate compare to popi=ulation
select location,population,date,max(total_cases) as HighestInfectionCounter,
max((total_cases/population)*100)as PercentPopulationInfected from Project_protfolio..CovidDeaths
where location like '%State%'
group by location,population,date
order by 1,2


select location,max(total_deaths) as HighestDeathsCount
from Project_protfolio..CovidDeaths
--where location like '%State%'
group by location
order by HighestDeathsCount desc


--showing death count per continent
select continent,max(total_deaths) as HighestDeathsCount
from Project_protfolio..CovidDeaths
group by continent
order by HighestDeathsCount desc

--showing continetns with the highest  death count
 select continent, max(total_deaths) as death_countt 
 from Project_protfolio..CovidDeaths
 group by continent
 order by death_countt  desc

 --global number
 select Sum(new_cases) as total_casess,Sum(cast(new_deaths as int))
 as total_deathss,(Sum(cast(new_deaths as int)))/Sum(new_Cases)*100 as DeathPersentages
 from Project_protfolio..CovidDeaths
 --where new_cases is not null
 --group by date
order by 1,2


--using join
select dea.continent, dea.location, dea.date,dea.population,
vacsin.new_vaccinations ,
sum(convert(int, vacsin.new_vaccinations  ))
Over (Partition by dea.location order by
dea.location,dea.date)
from
Project_protfolio..CovidDeaths dea
join Project_protfolio..CovidVaccinations vacsin
on dea.date=vacsin.date and vacsin.location=dea.location
where dea.continent is not null
order by 1,2



Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
select * from PercentPopulationVaccinated

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vacsin.new_vaccinations,
SUM(CONVERT(int,vacsin.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
From Project_protfolio..CovidDeaths dea
Join  Project_protfolio..CovidVaccinations vacsin
	On dea.location = vacsin.location
	and dea.date = vacsin.date



-- Creating View to store data for later visualizations
select * from PercentPopulationVaccinated1

Create View PercentPopulationVaccinated1 as
Select dea.continent, dea.location, dea.date, dea.population, vacsin.new_vaccinations
, SUM(CONVERT(int,vacsin.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Project_protfolio..CovidDeaths dea
Join  Project_protfolio..CovidVaccinations vacsin
	On dea.location = vacsin.location
	and dea.date = vacsin.date
where dea.continent is not null 




































