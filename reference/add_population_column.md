# Add Population Column to Country Data

Add Population Column to Country Data

## Usage

``` r
add_population_column(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "population"
)
```

## Arguments

- df:

  A data frame containing country identifiers.

- id_column:

  Name of the column containing country identifiers.

- id_type:

  Type of country identifier. Defaults to "iso3_code".

- date_column:

  Optional. Name of the column containing dates for time-specific data.

- target_column:

  Name of the output column. Defaults to "population".

## Value

A data frame with an additional column containing population data.

## Examples

``` r
# \donttest{
# Add population data using ISO3 codes
df <- data.frame(country = c("USA", "CAN", "MEX"))
result <- add_population_column(df, id_column = "country")

# Add population data with specific dates
df <- data.frame(country = c("USA", "CAN"), year = c(2019, 2020))
result <- add_population_column(
 df, id_column = "country", date_column = "year"
)
# }
```
