#' @keywords internal
#' @noRd
get_population <- function(entities, most_recent_only) {
  wdi_get(
    entities = entities,
    indicators = "SP.POP.TOTL",
    most_recent_only = most_recent_only
  ) |>
    dplyr::select(id = "entity_id", "year", "value")
}

#' @keywords internal
#' @noRd
get_poverty_ratio <- function(entities, most_recent_only) {
  wdi_get(
    entities = entities,
    indicators = "SI.POV.DDAY",
    most_recent_only = most_recent_only
  ) |>
    dplyr::select(id = "entity_id", "year", "value")
}

#' @keywords internal
#' @noRd
get_population_density <- function(entities, most_recent_only) {
  wdi_get(
    entities = entities,
    indicators = "EN.POP.DNST",
    most_recent_only = most_recent_only
  ) |>
    dplyr::select(id = "entity_id", "year", "value")
}

#' @keywords internal
#' @noRd
get_income_levels <- function(entities) {
  wdi_get_entities() |>
    dplyr::select(
      id = "entity_id",
      "income_level_id",
      "income_level_name"
    ) |>
    dplyr::filter(.data$id %in% entities)
}

#' @keywords internal
#' @noRd
safe_weo_get <- function(entities, series, ...) {
  weo_get(
    entities,
    series,
    year = 2025,
    release = "Spring",
    ...
  )
}

#' @keywords internal
#' @noRd
get_gdp <- function(entities, most_recent_only, usd = TRUE) {
  series <- ifelse(usd, "NGDPD", "NGDP")
  result <- safe_weo_get(entities, series) |>
    dplyr::filter(.data$series_id == series) |>
    dplyr::select(id = "entity_id", "year", "value") |>
    dplyr::mutate(value = .data$value * 1e9)
  if (most_recent_only) {
    result <- filter_most_recent_only(result)
  }
  result
}

#' @keywords internal
#' @noRd
get_gov_exp <- function(entities, most_recent_only) {
  result <- safe_weo_get(entities, "GGX") |>
    dplyr::filter(.data$series_id == "GGX") |>
    dplyr::select(id = "entity_id", "year", "value") |>
    dplyr::mutate(value = .data$value * 1e9)
  if (most_recent_only) {
    result <- filter_most_recent_only(result)
  }
  result
}

#' @keywords internal
#' @noRd
get_gov_exp_share <- function(entities, most_recent_only) {
  result <- safe_weo_get(entities, "GGX_NGDP") |>
    dplyr::filter(.data$series_id == "GGX_NGDP") |>
    dplyr::select(id = "entity_id", "year", "value") |>
    dplyr::mutate(value = .data$value / 100)
  if (most_recent_only) {
    result <- filter_most_recent_only(result)
  }
  result
}
