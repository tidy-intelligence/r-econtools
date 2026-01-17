# Add Income Levels to Country Data

Add Income Levels to Country Data

## Usage

``` r
add_income_level_column(
  df,
  id_column,
  id_type = "iso3_code",
  target_column = "income_level"
)
```

## Arguments

- df:

  A data frame containing country identifiers.

- id_column:

  Name of the column containing country identifiers.

- id_type:

  Type of country identifier. Defaults to "iso3_code".

- target_column:

  Name of the output column. Defaults to "income_level".

## Value

A data frame with a additional columns containing the income level ID
and name.

## Examples

``` r
# \donttest{
# Add income levels using ISO3 codes
df <- data.frame(country = c("USA", "NGA", "IND"))
result <- add_income_level_column(df, id_column = "country")
# }
```
