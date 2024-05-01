-- 1. Quels sont les détails de localisation, de date, de cas totaux et de population dans la base de données CovidDeaths, triés par localisation puis par date ?
SELECT location, date, total_cases, population 
FROM CovidDeaths 
ORDER BY location, date;

-- 2. Quels sont les détails de cas totaux et de décès totaux, avec le pourcentage de décès, pour l'Algérie ?
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%algeria%'
ORDER BY DeathPercentage;

-- 3. Quel est le pourcentage de la population infectée par Covid pour chaque localisation et chaque date ?
SELECT location, date, total_cases, population, (total_cases/population)*100 as PerPopulationInfected
FROM CovidDeaths
ORDER BY location, date;

-- 4. Quels pays ont le taux d'infection le plus élevé, en tenant compte de la population ?
SELECT location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population)*100 as HighestInfectionPercentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY HighestInfectionPercentage DESC;

-- 5. Quels pays ont le plus grand nombre de décès par rapport à leur population ?
SELECT location, MAX(CAST(total_deaths AS int)) as TotalDeathsCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathsCount DESC;

-- 6. Quels sont les totaux mondiaux des nouveaux cas et des nouveaux décès, agrégés par date ?
SELECT date, SUM(max_new_cases) AS total_new_cases, SUM(CAST(new_deaths AS int)) AS total_new_deaths
FROM (
    SELECT date, MAX(new_cases) AS max_new_cases, new_deaths
    FROM CovidDeaths
    WHERE continent IS NOT NULL AND new_cases IS NOT NULL
    GROUP BY date, new_deaths
) AS subquery
GROUP BY date
ORDER BY date;
