#' @keywords internal
#' @noRd
#'
get_population <- function(entities, most_recent_only) {
  wbwdi::wdi_get(
    entities = entities,
    indicators = "SP.POP.TOTL",
    most_recent_only = most_recent_only
  ) |>
    dplyr::select(id = "entity_id", "year", "value")
}

#' @keywords internal
#' @noRd
#'
get_poverty_ratio <- function(entities, most_recent_only) {
  wbwdi::wdi_get(
    entities = entities,
    indicators = "SI.POV.DDAY",
    most_recent_only = most_recent_only
  ) |>
    dplyr::select(id = "entity_id", "year", "value")
}

#' @keywords internal
#' @noRd
#'
get_population_density <- function(entities, most_recent_only) {
  wbwdi::wdi_get(
    entities = entities,
    indicators = "EN.POP.DNST",
    most_recent_only = most_recent_only
  ) |>
    dplyr::select(id = "entity_id", "year", "value")
}

#' @keywords internal
#' @noRd
#'
get_income_levels <- function(entities) {
  wbwdi::wdi_get_entities() |>
    dplyr::select(
      id = "entity_id",
      "income_level_id",
      "income_level_name"
    ) |>
    dplyr::filter(.data$id %in% entities)
}

# nolint start
# get_gdp <- function(entities, usd = TRUE) {
# indicator = ifelse(usd, "NGDPD", "NGDP")
# imfweo::weo_get(indicator)
# }

# get_gov_expenditure <- function(entities, usd = TRUE) {
# indicator = "GGX_NGDP"
# imfweo::weo_get(indicator)
# }
# nolint end
