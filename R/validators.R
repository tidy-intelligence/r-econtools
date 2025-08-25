#' @keywords internal
#' @noRd
validate_add_column_params <- function(
  df,
  id_column,
  id_type,
  date_column = NULL
) {
  validate_id_column(df, id_column)
  validate_id_type(id_type)
  if (!is.null(date_column)) {
    validate_date_column(df, date_column)
  }
  invisible(TRUE)
}

#' @keywords internal
#' @noRd
validate_id_column <- function(df, id_column) {
  if (!id_column %in% colnames(df)) {
    cli::cli_abort(
      c("x" = "id_column '{id_column}' not in dataframe columns")
    )
  } else {
    if (anyNA(df[id_column])) {
      cli::cli_warn(
        c("i" = "id_column '{id_column}' contains missing values")
      )
    }
    invisible(TRUE)
  }
}

#' @keywords internal
#' @noRd
#'
validate_id_type <- function(id_type) {
  if (!id_type %in% c("iso3_code", "regex")) {
    cli::cli_abort(
      c("x" = "id_type '{id_type}' not supported")
    )
  } else {
    invisible(TRUE)
  }
}

#' @keywords internal
#' @noRd
#'
validate_date_column <- function(df, date_column) {
  if (!is.null(date_column) && !date_column %in% names(df)) {
    cli::cli_abort(
      c("x" = "date_column '{date_column}' not in dataframe columns")
    )
  } else {
    if (any(df[date_column] < 0)) {
      cli::cli_warn(
        c("i" = "date_column '{date_column}' contains negative values")
      )
    }
    invisible(TRUE)
  }
}
