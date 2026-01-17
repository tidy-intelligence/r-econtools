# Add Population Density Column to Country Data

Add Population Density Column to Country Data

## Usage

``` r
add_population_density_column(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "population_density"
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

  Name of the output column. Defaults to "population_density".

## Value

A data frame with an additional column containing population density
data.

## Examples

``` r
# \donttest{
# Add population density using ISO3 codes
df <- data.frame(country = c("FRA", "DEU", "ESP"))
result <- add_population_density_column(df, id_column = "country")

# Add population density with year
df <- data.frame(country = c("FRA", "DEU"), year = c(2015, 2020))
result <- add_population_density_column(
  df, id_column = "country", date_column = "year"
)
# }
```
