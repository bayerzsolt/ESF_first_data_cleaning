library(tidyverse)

#How much of the ESF money planned for 2021-2027 is actually being implemented,
#and how does that differ by country, fund and policy area?

social <- read_csv("2021-2027_Finances_Detailed_Planned_vs_Implemented__timeseries__20261022_xls.csv")

nrow(social)
problems(social)
social |> count(fund)
social |> count(is_latest_tod_cycle)

#Filter for ESF+ stuff
social_esf <- social |>
  filter(fund == "ESF+",
         is_latest_tod_cycle == "Y")
nrow(social_esf)

social_esf |> distinct() |> nrow() 

social_esf |>
  group_by(cci, priority_code, spec_obj_code, category_code, category_region_name) |>
  filter(n() > 1) |>
  arrange(cci, priority_code, category_code) |>
  select(cci, priority_code, category_code, `Total Planned`, `Total spending`)

esf_clean <- social_esf |> distinct()
  by_country <- esf_clean |>
    group_by(ms_name) |>
    summarise(planned = sum(`Total Planned`),
              spent   = sum(`Total spending`),
              rate    = spent / planned) |>
    arrange(desc(rate))

  by_country |>
    print(n = 27)