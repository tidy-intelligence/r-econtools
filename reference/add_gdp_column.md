# Add GDP to Country Data

Add GDP to Country Data

## Usage

``` r
add_gdp_column(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "gdp",
  usd = TRUE
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

  Name of the output column. Defaults to "gdp".

- usd:

  Logical. Indicates whether GDP should be in USD or local currency.
  Defaults to "TRUE".

## Value

A data frame with an additional column containing GDP data.

## Examples

``` r
# \donttest{
# Add most recent GDP values
df <- data.frame(country = c("USA", "CHN", "DEU"))
result <- add_gdp_column(df, id_column = "country")

# Add year-specific GDP values
df <- data.frame(country = c("USA", "CHN"), year = c(2019, 2020))
result <- add_gdp_column(df, id_column = "country", date_column = "year")
# }
```
