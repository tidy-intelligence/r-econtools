
<!-- README.md is generated from README.Rmd. Please edit that file -->

# econtools

<!-- badges: start -->

![R CMD
Check](https://github.com/tidy-intelligence/econtools/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/econtools/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/econtools/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/econtools)
<!-- badges: end -->

Provides a consistent set of functions for enriching and analyzing
sovereign-level economic data. Economists, data scientists, and
financial professionals can use the package to add standardized
identifiers, demographic and macroeconomic indicators, and derived
metrics such as gross domestic product per capita or government
expenditure shares.

The package is part of the
[EconDataverse](https://www.econdataverse.org/) family of packages aimed
at helping economists and financial professionals work with
sovereign-level economic data.

## Installation

You can install `econtools` from CRAN via:

``` r
install.packages("imfweo")
```

You can install the development version of `econtools` from
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
  gross_domestic_product = c(2.15e13, 2.14e13, 2.37e13, 2.60e13, 2.77e13)
)

add_population_column(df, id_column = "name", id_type = "regex")
#>    id          name year gross_domestic_product entity_id population
#> 1 USA United States 2019               2.15e+13       USA  340110988
#> 2 USA United.states 2020               2.14e+13       USA  340110988
#> 3 USA            US 2021               2.37e+13       USA  340110988
#> 4 USA           USA 2022               2.60e+13       USA  340110988
#> 5 USA United States 2023               2.77e+13       USA  340110988
```

The simplest way to add additional information is using an ISO 3166-1
alpha-3 code.

Add most recent population number:

``` r
add_population_column(df, id_column = "id")
#>    id          name year gross_domestic_product population
#> 1 USA United States 2019               2.15e+13  340110988
#> 2 USA United.states 2020               2.14e+13  340110988
#> 3 USA            US 2021               2.37e+13  340110988
#> 4 USA           USA 2022               2.60e+13  340110988
#> 5 USA United States 2023               2.77e+13  340110988
```

Add population by year:

``` r
add_population_column(df, id_column = "id", date_column = "year")
#>    id          name year gross_domestic_product population
#> 1 USA United States 2019               2.15e+13  330226227
#> 2 USA United.states 2020               2.14e+13  331577720
#> 3 USA            US 2021               2.37e+13  332099760
#> 4 USA           USA 2022               2.60e+13  334017321
#> 5 USA United States 2023               2.77e+13  336806231
```

Similarly, for poverty ratio:

``` r
add_poverty_ratio_column(df, id_column = "id", date_column = "year")
#>    id          name year gross_domestic_product poverty_ratio
#> 1 USA United States 2019               2.15e+13           1.0
#> 2 USA United.states 2020               2.14e+13           0.5
#> 3 USA            US 2021               2.37e+13           0.5
#> 4 USA           USA 2022               2.60e+13           1.2
#> 5 USA United States 2023               2.77e+13           1.2
```

Create a new column that calculates a value relative to the population,
for instance GDP per capita:

``` r
add_population_share_column(
  df,
  id_column = "id",
  date_column = "year",
  value_column = "gross_domestic_product"
)
#>    id          name year gross_domestic_product population population_share
#> 1 USA United States 2019               2.15e+13  330226227         65106.88
#> 2 USA United.states 2020               2.14e+13  331577720         64539.92
#> 3 USA            US 2021               2.37e+13  332099760         71364.10
#> 4 USA           USA 2022               2.60e+13  334017321         77840.27
#> 5 USA United States 2023               2.77e+13  336806231         82243.13
```

Add income levels via:

``` r
add_income_level_column(df, id_column = "id")
#>    id          name year gross_domestic_product income_level_id
#> 1 USA United States 2019               2.15e+13             HIC
#> 2 USA United.states 2020               2.14e+13             HIC
#> 3 USA            US 2021               2.37e+13             HIC
#> 4 USA           USA 2022               2.60e+13             HIC
#> 5 USA United States 2023               2.77e+13             HIC
#>   income_level_name
#> 1       High income
#> 2       High income
#> 3       High income
#> 4       High income
#> 5       High income
```

If you want to use another column and automatically map identifiers to a
new `entity_id` column using the `econid` package:

``` r
add_population_column(df, id_column = "name", id_type = "regex")
#>    id          name year gross_domestic_product entity_id population
#> 1 USA United States 2019               2.15e+13       USA  340110988
#> 2 USA United.states 2020               2.14e+13       USA  340110988
#> 3 USA            US 2021               2.37e+13       USA  340110988
#> 4 USA           USA 2022               2.60e+13       USA  340110988
#> 5 USA United States 2023               2.77e+13       USA  340110988
```

If you only want to add ISO-3 codes:

``` r
add_iso3_codes_column(df, "name")
#>    id          name year gross_domestic_product iso3_code
#> 1 USA United States 2019               2.15e+13       USA
#> 2 USA United.states 2020               2.14e+13       USA
#> 3 USA            US 2021               2.37e+13       USA
#> 4 USA           USA 2022               2.60e+13       USA
#> 5 USA United States 2023               2.77e+13       USA
```

You can also add a column with standardized names:

``` r
add_short_names_column(df, "name")
#>    id          name year gross_domestic_product    short_name
#> 1 USA United States 2019               2.15e+13 United States
#> 2 USA United.states 2020               2.14e+13 United States
#> 3 USA            US 2021               2.37e+13 United States
#> 4 USA           USA 2022               2.60e+13 United States
#> 5 USA United States 2023               2.77e+13 United States
```

Finally, you can add columns from IMF WEO data such as the GDP in
national currency

``` r
add_gdp_column(df, id_column = "id", date_column = "year", usd = FALSE)
#>    id          name year gross_domestic_product          gdp
#> 1 USA United States 2019               2.15e+13 2.153998e+13
#> 2 USA United.states 2020               2.14e+13 2.135412e+13
#> 3 USA            US 2021               2.37e+13 2.368118e+13
#> 4 USA           USA 2022               2.60e+13 2.600690e+13
#> 5 USA United States 2023               2.77e+13 2.772072e+13
```

Or the government expenditure (only available in national currency):

``` r
add_gov_exp_column(df, id_column = "id", date_column = "year")
#>    id          name year gross_domestic_product      gov_exp
#> 1 USA United States 2019               2.15e+13 7.715392e+12
#> 2 USA United.states 2020               2.14e+13 9.562061e+12
#> 3 USA            US 2021               2.37e+13 1.023444e+13
#> 4 USA           USA 2022               2.60e+13 9.578022e+12
#> 5 USA United States 2023               2.77e+13 1.028794e+13
```

And share of government expenditure to GDP:

``` r
add_gov_exp_share_column(df, id_column = "id", date_column = "year")
#>    id          name year gross_domestic_product gov_exp_share
#> 1 USA United States 2019               2.15e+13       0.35819
#> 2 USA United.states 2020               2.14e+13       0.44779
#> 3 USA            US 2021               2.37e+13       0.43218
#> 4 USA           USA 2022               2.60e+13       0.36829
#> 5 USA United States 2023               2.77e+13       0.37113
```

## Contributing

Contributions to `econtools` are welcome! If you’d like to contribute,
please follow these steps:

1.  **Create an issue**: Before making changes, create an issue
    describing the bug or feature you’re addressing.
2.  **Fork the repository**: After receiving supportive feedback from
    the package authors, fork the repository to your GitHub account.
3.  **Create a branch**: Create a branch for your changes with a
    descriptive name.
4.  **Make your changes**: Implement your bug fix or feature.
5.  **Test your changes**: Run tests to ensure your changes don’t break
    existing functionality.
6.  **Submit a pull request**: Push your changes to your fork and submit
    a pull request to the main repository.
