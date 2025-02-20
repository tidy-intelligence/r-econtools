
#' @keywords internal
#' @noRd
#'
get_population <- function(geographies, most_recent_only) {
  wbwdi::wdi_get(
    geographies = geographies,
    indicators = "SP.POP.TOTL",
    most_recent_only = most_recent_only
  ) |>
    select(id = "geography_id", "year", "value")
}

#' @keywords internal
#' @noRd
#'
get_poverty_ratio <- function(geographies, most_recent_only) {
  wbwdi::wdi_get(
    geographies = geographies,
    indicators = "SI.POV.DDAY",
    most_recent_only = most_recent_only
  )  |>
    select(id = "geography_id", "year", "value")
}

#' @keywords internal
#' @noRd
#'
get_population_density <- function(geographies, most_recent_only) {
  wbwdi::wdi_get(
    geographies = geographies,
    indicators = "EN.POP.DNST",
    most_recent_only = most_recent_only
  ) |>
    select(id = "geography_id", "year", "value")
}

#' @keywords internal
#' @noRd
#'
get_income_levels <- function(geographies) {
  wbwdi::wdi_get_geographies() |>
    select(id = "geography_id", "income_level_id", "income_level_name") |>
    filter(.data$id %in% geographies)
}

# nolint start
# get_gdp <- function(geographies, usd = TRUE) {
  # indicator = ifelse(usd, "NGDPD", "NGDP") 
  # imfweo::weo_get(indicator)
# }

# get_gov_expenditure <- function(geographies, usd = TRUE) {
  # indicator = "GGX_NGDP"
  # imfweo::weo_get(indicator)
# }
# nolint end
