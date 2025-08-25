#' @keywords internal
#' @noRd
current_year <- function() {
  as.integer(format(Sys.Date(), "%Y"))
}

#' @keywords internal
#' @noRd
filter_most_recent_only <- function(df) {
  df <- dplyr::filter(df, .data$year <= current_year())
  if (nrow(df) == 0) {
    return(df)
  }
  df |>
    dplyr::group_by(.data$id) |>
    dplyr::filter(.data$year == max(.data$year)) |>
    dplyr::ungroup()
}
