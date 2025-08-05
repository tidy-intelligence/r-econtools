#' @keywords internal
#' @noRd
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
get_income_levels <- function(entities) {
  wbwdi::wdi_get_entities() |>
    dplyr::select(
      id = "entity_id",
      "income_level_id",
      "income_level_name"
    ) |>
    dplyr::filter(.data$id %in% entities)
}

#' @keywords internal
#' @noRd
get_gdp <- function(entities, most_recent_only, usd = TRUE) {
  series <- ifelse(usd, "NGDPD", "NGDP")
  result <- imfweo::weo_get(entities, series) |>
    dplyr::filter(series_id == series) |>
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
  result <- imfweo::weo_get(entities, "GGX") |>
    dplyr::filter(series_id == "GGX") |>
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
  result <- imfweo::weo_get(entities, "GGX_NGDP") |>
    dplyr::filter(series_id == "GGX_NGDP") |>
    dplyr::select(id = "entity_id", "year", "value") |>
    dplyr::mutate(value = .data$value / 100)
  if (most_recent_only) {
    result <- filter_most_recent_only(result)
  }
  result
}

#' @keywords internal
#' @noRd
current_year <- function() {
  as.integer(format(Sys.Date(), "%Y"))
}

#' @keywords internal
#' @noRd
filter_most_recent_only <- function(df) {
  df |>
    dplyr::filter(year <= current_year()) |>
    dplyr::group_by(entity_id) |>
    dplyr::filter(year == max(year)) |>
    dplyr::ungroup()
}
