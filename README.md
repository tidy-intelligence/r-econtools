
<!-- README.md is generated from README.Rmd. Please edit that file -->

# econtools

<!-- badges: start -->

![R CMD
Check](https://github.com/tidy-intelligence/econtools/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/econtools/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/econtools/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/econtools)
<!-- badges: end -->

The goal of econtools is to provide tools for analyzing economic data
similar to the Python
[bblocks](https://github.com/ONEcampaign/bblocks/tree/main) package.

Roadmap:

- [x] Using [wbwdi](https://github.com/tidy-intelligence/r-wbwdi):
  adding `add_population_column()`, `add_poverty_ratio_column()`,
  `add_population_density_column()`, `add_population_share_column()`,
  `add_income_level_column()`
- \[\] Using [imfweo](https://github.com/Teal-Insights/imfweo): adding
  `add_gdp_column()`, `add_gov_expenditure_column()`,
  `add_gdp_share_column()`, `add_gov_exp_share_column()`
- \[\] Using [econid](https://github.com/Teal-Insights/r-econid):
  introducing `id_type="regex"` to all existing functions and adding
  `add_short_names_column()`, `add_iso3_codes_column()`

## Installation

You can install the development version of econtools from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("tidy-intelligence/econtools")
```

## Usage

This is a basic example which shows you how to solve a common problem:

``` r
library(econtools)
```

``` r
df <- data.frame(
  geography_id = rep("USA", 5),
  year = 2019:2023,
  gdp = c(2.15e13, 2.14e13, 2.37e13, 2.60e13, 2.77e13)
)
```

Add most recent population number:

``` r
add_population_column(df, id_column = "geography_id")
#>   geography_id year      gdp population
#> 1          USA 2019 2.15e+13  334914895
#> 2          USA 2020 2.14e+13  334914895
#> 3          USA 2021 2.37e+13  334914895
#> 4          USA 2022 2.60e+13  334914895
#> 5          USA 2023 2.77e+13  334914895
```

Add population by year:

``` r
add_population_column(df, id_column = "geography_id", date_column = "year")
#>   geography_id year      gdp population
#> 1          USA 2019 2.15e+13  328329953
#> 2          USA 2020 2.14e+13  331526933
#> 3          USA 2021 2.37e+13  332048977
#> 4          USA 2022 2.60e+13  333271411
#> 5          USA 2023 2.77e+13  334914895
```

Similarly, for poverty ratio:

``` r
add_poverty_ratio_column(df, id_column = "geography_id", date_column = "year")
#>   geography_id year      gdp poverty_ratio
#> 1          USA 2019 2.15e+13           1.0
#> 2          USA 2020 2.14e+13           0.2
#> 3          USA 2021 2.37e+13           0.2
#> 4          USA 2022 2.60e+13           1.2
#> 5          USA 2023 2.77e+13            NA
```

Create a new column that calculates a value relative to the population,
for instance gdp per capita:

``` r
add_population_share_column(df, id_column = "geography_id", date_column = "year", value_column = "gdp")
#>   geography_id year      gdp population population_share
#> 1          USA 2019 2.15e+13  328329953         65482.91
#> 2          USA 2020 2.14e+13  331526933         64549.81
#> 3          USA 2021 2.37e+13  332048977         71375.01
#> 4          USA 2022 2.60e+13  333271411         78014.49
#> 5          USA 2023 2.77e+13  334914895         82707.58
```

Add income levels via:

``` r
add_income_level_column(df, id_column = "geography_id")
#>   geography_id year      gdp income_level_id income_level_name
#> 1          USA 2019 2.15e+13             HIC       High income
#> 2          USA 2020 2.14e+13             HIC       High income
#> 3          USA 2021 2.37e+13             HIC       High income
#> 4          USA 2022 2.60e+13             HIC       High income
#> 5          USA 2023 2.77e+13             HIC       High income
```
