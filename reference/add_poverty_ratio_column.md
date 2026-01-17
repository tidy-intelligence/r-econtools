# Add Poverty Ratio Column to Country Data

Add Poverty Ratio Column to Country Data

## Usage

``` r
add_poverty_ratio_column(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "poverty_ratio"
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

  Name of the output column. Defaults to "poverty_ratio".

## Value

A data frame with an additional column containing poverty ratio data.

## Examples

``` r
# \donttest{
# Add poverty ratio using ISO3 codes
df <- data.frame(country = c("USA", "IND", "BRA"))
result <- add_poverty_ratio_column(df, id_column = "country")

# Add poverty ratio with specific dates
df <- data.frame(country = c("USA", "IND"), year = c(2018, 2020))
result <- add_poverty_ratio_column(
  df, id_column = "country", date_column = "year"
)
# }
```
