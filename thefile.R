library(tidyverse)
path <- "data/raw/2021-2027_Finances_Detailed_Planned_vs_Implemented_(timeseries)_20261022.xls.csv"

raw <- read_csv(path, col_types = cols(.default = col_character()))
raw <- janitor::clean_names(raw)

dim(raw)
names(raw)

count(raw, fund, sort = TRUE)
count(raw, ms, sort = TRUE)
count(raw, tod_cycle, tod_year, tod_reference_version)
count(raw, dimension_type, sort = TRUE)

esf <- raw |>
  filter(fund == "ESF+", is_latest_tod_cycle == "Y")
dim(esf)
count(esf, ms, sort = TRUE)

esf_raw <- esf |> select(
  ms, ms_name, cci, programme_short_title, programme_status, programme_version,
  programme_adoption_date, fund, category_region_name, tod_cycle, tod_year,
  tod_reference_version, priority_code, priority_name, pol_obj_short_name,
  spec_obj_short_name, dimension_type, category_short_title, category_code,
  cofinancing_rate, eu_planned, total_planned, total_decided, total_spending,
  number_of_operations
)

count(raw, is_latest_tod_cycle)                  # what other values exist besides "Y"?
count(esf_raw, tod_cycle, tod_reference_version) # should be one cycle, maybe a few versions
count(esf_raw, dimension_type)                   # probably only "Intervention Field"
janitor::get_dupes(esf_raw, cci, priority_code, category_code)



