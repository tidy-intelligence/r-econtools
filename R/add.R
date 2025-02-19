# Add functions ----------------------------------------------------------

add_population_column <- function(
  df, id_column, id_type = "regex", date_column = NULL, target_column = "population", update_data = FALSE
) {

  validate_add_column_params(df, id_column, id_type, date_column = NULL)

  population <- get_population(
    most_recent_only = ifelse(is.null(date_column), TRUE, FALSE)
  ) |> 
    dplyr::rename(id = "iso_code", year = "merge_year", "population" = target_column)

  if (is.null(date_column)) {
    population <- population |> 
      dplyr::select(-"merge_year")
    df <- df |> 
      dplyr::left_join(population, by = c(id_column = id))
  } else {
    df <- df |> 
      dplyr::left_join(population, by = c(id_column = "id", date_column = "merge_year"))
  }
  
  df
}

add_poverty_ratio_column <- function(
  df, id_column, id_type = "regex", date_column = NULL, target_column = "poverty_ratio", update_data = FALSE
) {
  validate_add_column_params(df, id_column, id_type, date_column)

}

add_population_density_column <- function(
  df, id_column, id_type = "regex", date_column = NULL, target_column = "population_density", update_data = FALSE
) {

  validate_add_column_params(df, id_column, id_type, date_column)

}

add_gdp_column <- function(
  df, id_column, id_type = "regex", date_column = NULL, target_column = "gdp", update_data = FALSE, usd = TRUE, include_estimates = FALSE
) {

  validate_add_column_params(df, id_column, id_type, date_column)

}

add_gov_expenditure_column <- function(
  df, id_column, id_type = "regex", date_column = NULL, target_column = "gov_exp", update_data = FALSE, usd = TRUE, include_estimates = FALSE
) {

  validate_add_column_params(df, id_column, id_type, date_column)

}

add_gdp_share_column <- function(
  df, id_column, id_type = "regex", date_column = NULL, value_column = "value", target_column = "gdp_share", update_data = FALSE, include_estimates = FALSE, usd = FALSE
) {

  validate_add_column_params(df, id_column, id_type, date_column)

}

add_population_share_column <- function(
  df, id_column, id_type = "regex", date_column = NULL, value_column = "value", target_column = "population_share", update_data = FALSE, include_estimates = FALSE
) {

  validate_add_column_params(df, id_column, id_type, date_column)

}

add_gov_exp_share_column <- function(
  df, id_column, id_type = NULL, date_column = NULL, value_column = "value", target_column = "gov_exp_share", update_data = FALSE, include_estimates = FALSE, usd = FALSE
) {

  validate_add_column_params(df, id_column, id_type, date_column)

}

add_income_level_column <- function(
  df, id_column, id_type = "regex", target_column = "income_level", update_data = FALSE
) {

  validate_add_column_params(df, id_column, id_type)

}

add_short_names_column <- function(
  df, id_column, id_type = NULL, target_column = "name_short"
) {

  validate_add_column_params(df, id_column, id_type)

}

add_iso3_codes_column <- function(
  df, id_column, id_type = NULL, target_column = "iso3_code"
) {

  validate_add_column_params(df, id_column, id_type)

}

# Validators -------------------------------------------------------------

validate_add_column_params <- function(df, id_column, id_type, date_column) {
  validate_id_column(df, id_column)
  validate_id_type(validate_id_type)
  if (!is.null(date_column)) {
    validate_date_column(df, date_column)
  }
  invisible(TRUE)
}

validate_id_column <- function(df, id_column) {
  if (!id_column %in% colnames(df)) {
    cli::cli_abort(
      c("x" = "id_column '{id_column}' not in dataframe columns")
    )
  } else {
    invisible(TRUE)
  }
}

validate_id_type <- function(id_type) {
  if (!id_type %in% c("regex")) {
    cli::cli_abort(
      c("x" = "id_type '{id_type}' not supported")
    )
  } else {
    invisible(TRUE)
  }
}

validate_date_column <- function(df, date_column) {
  if (!is.null(date_column) && !date_column %in% names(df)) {
    cli::cli_abort(
      c("x" = "date_column '{date_column}' not in dataframe columns")
    )
  } else {
    invisible(TRUE)
  }
}

# Backlog ----------------------------------------------------------------

# Maybe drop these functions
# add_median_observation <- function(
#   df, group_by = NULL, value_columns = "value", append = TRUE, group_name = NULL
# ) {
# }

# add_flourish_geometries <- function(
#   df, id_column, id_type = NULL, target_column = "geometry"
# ) {
# }

# add_value_as_share <- function(
#   df, value_col, share_of_value_col, target_col = NULL
# ) { 
# }