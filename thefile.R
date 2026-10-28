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
  
  
  ggplot(by_country, aes(x = rate, y = reorder(ms_name, rate))) +
    geom_col() +
    scale_x_continuous(labels = scales::percent) +
    labs(title = "ESF+ spending as a share of planned funding 2021-2027",
         x = "Share of planned funding spent",
         y = NULL,
         caption = "Source: Cohesion Open Data Platform, 22 Oct 2026") +
    theme_minimal()
  ggsave("absorption_by_country.png", width = 8, height = 7, dpi = 300)
  
  by_objective <- esf_clean |>
    group_by(spec_obj_name) |>
    summarise(planned = sum(`Total Planned`),
              spent   = sum(`Total spending`),
              rate    = spent / planned) |>
    arrange(desc(planned))
  by_objective
  
  ggplot(by_objective, aes(x = rate, y = reorder(spec_obj_name, rate))) +
    geom_col() +
    scale_x_continuous(labels = scales::percent) +
    labs(title = "ESF+ spending by specific objective (2021-2027)",
         x = "Share of planned funding spent", y = NULL,
         caption = "Source: Cohesion Open Data Platform, 22 Oct 2026") +
    theme_minimal()
  ggsave("esf_spending_by_specific_objective.png", width = 8, height = 7, dpi = 300)
  