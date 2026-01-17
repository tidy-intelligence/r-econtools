# Add ISO-3 Codes to Country Data

Add ISO-3 Codes to Country Data

## Usage

``` r
add_iso3_codes_column(df, id_column, target_column = "iso3_code")
```

## Arguments

- df:

  A data frame containing country identifiers.

- id_column:

  Name of the column containing country identifiers.

- target_column:

  Name of the output column. Defaults to "iso3_code".

## Value

A data frame with an additional column containing the ISO-3 code.

## Examples

``` r
# Convert country names to ISO3 codes
df <- data.frame(name = c("United States", "Canada", "Mexico"))
result <- add_iso3_codes_column(df, id_column = "name")
```
