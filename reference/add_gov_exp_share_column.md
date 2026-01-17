# Add Government Expenditure as Share of GDP to Country Data

Add Government Expenditure as Share of GDP to Country Data

## Usage

``` r
add_gov_exp_share_column(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "gov_exp_share"
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

  Name of the output column. Defaults to "gov_exp".

## Value

A data frame with an additional column containing government expenditure
as share of GDP data.

## Examples

``` r
# \donttest{
# Add government expenditure share of GDP
df <- data.frame(country = c("USA", "JPN", "AUS"))
result <- add_gov_exp_share_column(df, id_column = "country")

# With specific years
df <- data.frame(country = c("USA", "JPN"), year = c(2015, 2020))
result <- add_gov_exp_share_column(
  df, id_column = "country", date_column = "year"
)
# }
```
