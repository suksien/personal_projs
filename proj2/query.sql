desc census_district_sst_modified;

# --- year vs total population for entire country
select year, sum(population_total)
from census_district_sst_modified
group by year;


# --- year vs total population per state
select state, year, sum(population_total)
from census_district_sst_modified
group by state, year;

# --- current status of demographics
select state, sum(population_total) as totalPopulation, sum(population_growth) as totalGrowth, sum(ethnicity_bumi), sum(ethnicity_chinese), sum(ethnicity_indian), sum(ethnicity_other), sum(age_0_14), sum(age_15_64), sum(age_65_above), sum(nationality_citizen), sum(nationality_non_citizen)
from census_district_sst_modified
where year=2020
group by state
# order by totalPopulation desc;
order by sum(ethnicity_chinese) desc;

# -- youngest state vs oldest state
select state, sum(population_total), sum(age_0_14)/sum(population_total) as age_group1_density, sum(age_15_64)/sum(population_total) as age_group2_density, sum(age_65_above)/sum(population_total) as age_group3_density
from census_district_sst_modified
where year=2020
group by state
