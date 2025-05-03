# Add functions ----------------------------------------------------------
#' Add Population Column to Country Data
#' @param df A data frame containing country identifiers.
#' @param id_column Name of the column containing country identifiers.
#' @param id_type Type of country identifier. Defaults to "iso3_code".
#' @param date_column Optional. Name of the column containing dates for
#'  time-specific data.
#' @param target_column Name of the output column. Defaults to "population".
#' @return A data frame with an additional column containing population data.
#' @examples
#' # Add population data using ISO3 codes
#' df <- data.frame(country = c("USA", "CAN", "MEX"))
#' result <- add_population_column(df, id_column = "country")
#'
#' # Add population data with specific dates
#' df <- data.frame(country = c("USA", "CAN"), year = c(2019, 2020))
#' result <- add_population_column(
#'  df, id_column = "country", date_column = "year"
#' )
#'
#' @export
add_population_column <- function(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "population"
) {
  add_generic_column(
    df,
    id_column,
    id_type,
    date_column,
    target_column,
    get_population
  )
}

#' Add Poverty Ratio Column to Country Data
#' @param df A data frame containing country identifiers.
#' @param id_column Name of the column containing country identifiers.
#' @param id_type Type of country identifier. Defaults to "iso3_code".
#' @param date_column Optional. Name of the column containing dates for
#'  time-specific data.
#' @param target_column Name of the output column. Defaults to "poverty_ratio".
#' @return A data frame with an additional column containing poverty ratio data.
#' @export
add_poverty_ratio_column <- function(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "poverty_ratio"
) {
  add_generic_column(
    df,
    id_column,
    id_type,
    date_column,
    target_column,
    get_poverty_ratio
  )
}

#' Add Population Density Column to Country Data
#' @param df A data frame containing country identifiers.
#' @param id_column Name of the column containing country identifiers.
#' @param id_type Type of country identifier. Defaults to "iso3_code".
#' @param date_column Optional. Name of the column containing dates for
#'  time-specific data.
#' @param target_column Name of the output column. Defaults to
#'  "population_density".
#' @return A data frame with an additional column containing population density
#'  data.
#' @export
add_population_density_column <- function(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  target_column = "population_density"
) {
  add_generic_column(
    df,
    id_column,
    id_type,
    date_column,
    target_column,
    get_population_density
  )
}

#' @keywords internal
#' @noRd
#'
add_generic_column <- function(
  df,
  id_column,
  id_type,
  date_column,
  target_column,
  data_fetcher
) {
  validate_add_column_params(df, id_column, id_type, date_column)

  id_col_sym <- rlang::sym(id_column)

  if (id_type == "regex") {
    if (id_column == "entity_id") {
      cli::cli_abort(
        c(
          "x" = "{.arg id_column} is not allowed to be named `entity_id` for regex."
        )
      )
      return(invisible(NULL))
    }

    id_mapping <- econid::standardize_entity(
      df,
      !!id_col_sym,
      output_cols = "entity_id"
    ) |>
      dplyr::distinct(!!id_col_sym, .data$entity_id)

    df <- dplyr::left_join(
      df,
      id_mapping,
      by = rlang::as_name(id_col_sym)
    )
    join_id <- "entity_id"
  } else {
    join_id <- rlang::as_name(id_col_sym)
  }

  entities <- unique(df[[join_id]])

  data <- data_fetcher(
    entities,
    most_recent_only = is.null(date_column)
  ) |>
    dplyr::rename(!!target_column := "value")

  if (is.null(date_column)) {
    data <- dplyr::select(data, -"year")
    df <- dplyr::left_join(df, data, by = set_names("id", join_id))
  } else {
    date_col_sym <- rlang::sym(date_column)
    df <- dplyr::left_join(
      df,
      data,
      by = set_names(c("id", "year"), c(join_id, rlang::as_name(date_col_sym)))
    )
  }

  df
}

#' Add Population Share Column to Country Data
#' @param df A data frame containing country identifiers.
#' @param id_column Name of the column containing country identifiers.
#' @param id_type Type of country identifier. Defaults to "iso3_code".
#' @param date_column Optional. Name of the column containing dates for
#'  time-specific data.
#' @param value_column Name of the column containing the value to divided by
#'  population.
#' @param target_column Name of the output column. Defaults to
#'  "population_share".
#' @return A data frame with an additional column containing a new column with a
#'  value divided by population.
#' @export
add_population_share_column <- function(
  df,
  id_column,
  id_type = "iso3_code",
  date_column = NULL,
  value_column = "value",
  target_column = "population_share"
) {
  validate_add_column_params(df, id_column, id_type, date_column)

  df <- add_generic_column(
    df,
    id_column,
    id_type,
    date_column,
    "population",
    get_population
  )
  df[target_column] <- df[value_column] / df["population"]
  df
}

#' Add Income Levels to Country Data
#' @param df A data frame containing country identifiers.
#' @param id_column Name of the column containing country identifiers.
#' @param id_type Type of country identifier. Defaults to "iso3_code".
#' @param target_column Name of the output column. Defaults to "income_level".
#' @return A data frame with a additional columns containing the income level ID
#'  and name.
#' @export
add_income_level_column <- function(
  df,
  id_column,
  id_type = "iso3_code",
  target_column = "income_level"
) {
  validate_add_column_params(df, id_column, id_type)

  geographies <- unique(unlist(df[id_column]))
  income_levels <- get_income_levels(geographies)

  id_col_sym <- rlang::sym(id_column)
  df <- df |>
    dplyr::left_join(
      income_levels,
      by = set_names("id", as_name(id_col_sym))
    )
  df
}


#' Add Short Names to Country Data
#' @param df A data frame containing country identifiers.
#' @param id_column Name of the column containing country identifiers.
#' @param target_column Name of the output column. Defaults to "name_short".
#' @return A data frame with an additional column containing the short names.
#' @export
add_short_names_column <- function(
  df,
  id_column,
  target_column = "name_short"
) {
  validate_id_column(df, id_column)

  if (id_column == "entity_id") {
    cli::cli_abort(
      c(
        "x" = "{.arg id_column} is not allowed to be named `entity_id`."
      )
    )
    return(invisible(NULL))
  }

  id_col_sym <- rlang::sym(id_column)

  id_mapping <- econid::standardize_entity(
    df,
    !!id_col_sym,
    output_cols = "entity_name"
  ) |>
    dplyr::distinct(!!id_col_sym, .data$entity_name)

  df <- dplyr::left_join(
    df,
    id_mapping,
    by = rlang::as_name(id_col_sym)
  ) |>
    rename(short_name = "entity_name")

  df
}

#' Add ISO-3 Codes to Country Data
#' @param df A data frame containing country identifiers.
#' @param id_column Name of the column containing country identifiers.
#' @param target_column Name of the output column. Defaults to "iso3_code".
#' @return A data frame with an additional column containing the ISO-3 code.
#' @export
add_iso3_codes_column <- function(
  df,
  id_column,
  target_column = "iso3_code"
) {
  validate_id_column(df, id_column)

  if (id_column == "entity_id") {
    cli::cli_abort(
      c(
        "x" = "{.arg id_column} is not allowed to be named `entity_id`."
      )
    )
    return(invisible(NULL))
  }

  id_col_sym <- rlang::sym(id_column)

  id_mapping <- econid::standardize_entity(
    df,
    !!id_col_sym,
    output_cols = "iso3c"
  ) |>
    dplyr::distinct(!!id_col_sym, .data$iso3c)

  df <- dplyr::left_join(
    df,
    id_mapping,
    by = rlang::as_name(id_col_sym)
  ) |>
    rename(iso3_code = "iso3c")

  df
}

# Backlog ----------------------------------------------------------------
# nolint start
# TODO: wait for imfweo package
# add_gdp_column <- function(
#   df, id_column, id_type = "iso3_code", date_column = NULL,
#   target_column = "gdp", usd = TRUE, include_estimates = FALSE
# ) {
#   validate_add_column_params(df, id_column, id_type, date_column)
# }

# TODO: wait for imfweo package
# add_gov_expenditure_column <- function(
#   df, id_column, id_type = "iso3_code", date_column = NULL,
#   target_column = "gov_exp", usd = TRUE, include_estimates = FALSE
# ) {
#   validate_add_column_params(df, id_column, id_type, date_column)
# }

# TODO: wait for imfweo package
# add_gdp_share_column <- function(
#   df, id_column, id_type = "iso3_code", date_column = NULL,
#   value_column = "value", target_column = "gdp_share",
#   include_estimates = FALSE, usd = FALSE
# ) {
#   validate_add_column_params(df, id_column, id_type, date_column)
# }

# TODO: wait for imfweo package
# add_gov_exp_share_column <- function(
#   df, id_column, id_type = "iso3_code", date_column = NULL,
#   value_column = "value", target_column = "gov_exp_share",
#   include_estimates = FALSE, usd = FALSE
# ) {
#   validate_add_column_params(df, id_column, id_type, date_column)
# }
# nolint end
