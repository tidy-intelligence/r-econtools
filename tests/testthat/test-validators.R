test_that("validate_id_column: errors if missing; warns on NA; ok otherwise", {
  df <- data.frame(id = c("a", "b", NA_character_), x = 1:3)

  # missing column -> error
  expect_error(
    validate_id_column(df, "nope"),
    "id_column 'nope' not in dataframe columns"
  )

  # present but has NA -> warning + invisible TRUE
  expect_warning(
    expect_invisible(validate_id_column(df, "id")),
    "id_column 'id' contains missing values"
  )

  # clean column -> silent + invisible TRUE
  df2 <- data.frame(key = c("a", "b", "c"))
  expect_silent(expect_invisible(validate_id_column(df2, "key")))
})

test_that("validate_id_type: supports iso3_code and regex; errors otherwise", {
  expect_silent(expect_invisible(validate_id_type("iso3_code")))
  expect_silent(expect_invisible(validate_id_type("regex")))
  expect_error(
    validate_id_type("uuid"),
    "id_type 'uuid' not supported"
  )
})

test_that("validate_date_column: errors if column absent", {
  df <- data.frame(date = 1:3)
  expect_error(
    validate_date_column(df, "not_here"),
    "date_column 'not_here' not in dataframe columns"
  )
})

test_that(
  paste(
    "validate_date_column: warns on negatives; ok otherwise (vector input)"
  ),
  {
    # NOTE: Using a *named numeric vector* here so that df[date_column]
    # returns an atomic vector (comparison with < works), which exercises
    # the warning path in the current implementation.
    df_neg <- c(my_date = -5, other = 10)
    expect_warning(
      expect_invisible(validate_date_column(df_neg, "my_date")),
      "date_column 'my_date' contains negative values"
    )

    df_ok <- c(my_date = 5, other = 10)
    expect_silent(expect_invisible(validate_date_column(df_ok, "my_date")))
  }
)

test_that(
  paste(
    "validate_add_column_params: runs without date;",
    "calls date validator when provided"
  ),
  {
    df <- data.frame(id = c("a", "b"), y = 1:2)

    # With NULL date_column -> succeeds (covers the invisible(TRUE) line)
    expect_silent(
      expect_invisible(
        validate_add_column_params(
          df,
          id_column = "id",
          id_type = "regex",
          date_column = NULL
        )
      )
    )

    # With a provided (but missing) date column -> error path exercised
    expect_error(
      validate_add_column_params(
        df,
        id_column = "id",
        id_type = "iso3_code",
        date_column = "not_here"
      ),
      "date_column 'not_here' not in dataframe columns"
    )
  }
)
