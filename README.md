
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

The package is part of the
[econdataverse](https://www.econdataverse.org/) family of packages aimed
at helping economists and financial professionals work with
sovereign-level economic data.

Roadmap:

- [x] Using [wbwdi](https://github.com/tidy-intelligence/r-wbwdi):
  adding `add_population_column()`, `add_poverty_ratio_column()`,
  `add_population_density_column()`, `add_population_share_column()`,
  `add_income_level_column()`
- [x] Using [econid](https://github.com/Teal-Insights/r-econid):
  introducing `id_type="regex"` to all existing functions and adding
  `add_short_names_column()`, `add_iso3_codes_column()`
- [ ] Using [imfweo](https://github.com/Teal-Insights/imfweo): adding
  `add_gdp_column()`, `add_gov_expenditure_column()`,
  `add_gdp_share_column()`, `add_gov_exp_share_column()`

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
  id = rep("USA", 5),
  name = c("United States", "United.states", "US", "USA", "United States"),
  year = 2019:2023,
  gdp = c(2.15e13, 2.14e13, 2.37e13, 2.60e13, 2.77e13)
)

add_population_column(df, id_column = "name", id_type = "regex")
#>    id          name year      gdp entity_id population
#> 1 USA United States 2019 2.15e+13       USA  340110988
#> 2 USA United.states 2020 2.14e+13       USA  340110988
#> 3 USA            US 2021 2.37e+13       USA  340110988
#> 4 USA           USA 2022 2.60e+13       USA  340110988
#> 5 USA United States 2023 2.77e+13       USA  340110988
```

The simplest way to add additional information is using an ISO 3166-1
alpha-3 code.

Add most recent population number:

``` r
add_population_column(df, id_column = "id")
#>    id          name year      gdp population
#> 1 USA United States 2019 2.15e+13  340110988
#> 2 USA United.states 2020 2.14e+13  340110988
#> 3 USA            US 2021 2.37e+13  340110988
#> 4 USA           USA 2022 2.60e+13  340110988
#> 5 USA United States 2023 2.77e+13  340110988
```

Add population by year:

``` r
add_population_column(df, id_column = "id", date_column = "year")
#>    id          name year      gdp population
#> 1 USA United States 2019 2.15e+13  330226227
#> 2 USA United.states 2020 2.14e+13  331577720
#> 3 USA            US 2021 2.37e+13  332099760
#> 4 USA           USA 2022 2.60e+13  334017321
#> 5 USA United States 2023 2.77e+13  336806231
```

Similarly, for poverty ratio:

``` r
add_poverty_ratio_column(df, id_column = "id", date_column = "year")
#>    id          name year      gdp poverty_ratio
#> 1 USA United States 2019 2.15e+13           1.0
#> 2 USA United.states 2020 2.14e+13           0.5
#> 3 USA            US 2021 2.37e+13           0.5
#> 4 USA           USA 2022 2.60e+13           1.2
#> 5 USA United States 2023 2.77e+13           1.2
```

Create a new column that calculates a value relative to the population,
for instance GDP per capita:

``` r
add_population_share_column(
  df,
  id_column = "id",
  date_column = "year",
  value_column = "gdp"
)
#>    id          name year      gdp population population_share
#> 1 USA United States 2019 2.15e+13  330226227         65106.88
#> 2 USA United.states 2020 2.14e+13  331577720         64539.92
#> 3 USA            US 2021 2.37e+13  332099760         71364.10
#> 4 USA           USA 2022 2.60e+13  334017321         77840.27
#> 5 USA United States 2023 2.77e+13  336806231         82243.13
```

Add income levels via:

``` r
add_income_level_column(df, id_column = "id")
#>    id          name year      gdp income_level_id income_level_name
#> 1 USA United States 2019 2.15e+13             HIC       High income
#> 2 USA United.states 2020 2.14e+13             HIC       High income
#> 3 USA            US 2021 2.37e+13             HIC       High income
#> 4 USA           USA 2022 2.60e+13             HIC       High income
#> 5 USA United States 2023 2.77e+13             HIC       High income
```

If you want to use another column and automatically map identifiers to a
new `entity_id` column using the `econid` package:

``` r
add_population_column(df, id_column = "name", id_type = "regex")
#>    id          name year      gdp entity_id population
#> 1 USA United States 2019 2.15e+13       USA  340110988
#> 2 USA United.states 2020 2.14e+13       USA  340110988
#> 3 USA            US 2021 2.37e+13       USA  340110988
#> 4 USA           USA 2022 2.60e+13       USA  340110988
#> 5 USA United States 2023 2.77e+13       USA  340110988
```

If you only want to add ISO-3 codes:

``` r
add_iso3_codes_column(df, "name")
#>    id          name year      gdp iso3_code
#> 1 USA United States 2019 2.15e+13       USA
#> 2 USA United.states 2020 2.14e+13       USA
#> 3 USA            US 2021 2.37e+13       USA
#> 4 USA           USA 2022 2.60e+13       USA
#> 5 USA United States 2023 2.77e+13       USA
```

You can also add a column with standardized names:

``` r
add_short_names_column(df, "name")
#>    id          name year      gdp    short_name
#> 1 USA United States 2019 2.15e+13 United States
#> 2 USA United.states 2020 2.14e+13 United States
#> 3 USA            US 2021 2.37e+13 United States
#> 4 USA           USA 2022 2.60e+13 United States
#> 5 USA United States 2023 2.77e+13 United States
```
