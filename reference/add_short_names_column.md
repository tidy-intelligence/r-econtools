# Add Short Names to Country Data

Add Short Names to Country Data

## Usage

``` r
add_short_names_column(df, id_column, target_column = "name_short")
```

## Arguments

- df:

  A data frame containing country identifiers.

- id_column:

  Name of the column containing country identifiers.

- target_column:

  Name of the output column. Defaults to "name_short".

## Value

A data frame with an additional column containing the short names.

## Examples

``` r
# Add short names using ISO3 codes
df <- data.frame(country = c("USA", "FRA", "JPN"))
result <- add_short_names_column(df, id_column = "country")
```
