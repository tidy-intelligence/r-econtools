test_that("validate_id_column works correctly", {
  df <- data.frame(iso3 = c("USA", "CAN"), value = 1:2)
  expect_true(validate_id_column(df, "iso3"))
  expect_error(
    validate_id_column(df, "nonexistent"),
    "id_column 'nonexistent' not in dataframe columns"
  )
})

test_that("validate_id_type works correctly", {
  expect_true(validate_id_type("iso3_code"))
  expect_error(
    validate_id_type("invalid_type"),
    "id_type 'invalid_type' not supported"
  )
})

test_that("validate_date_column works correctly", {
  df <- data.frame(iso3 = c("USA", "CAN"), year = c(2022, 2023))
  expect_true(validate_date_column(df, "year"))
  expect_error(
    validate_date_column(df, "nonexistent"),
    "date_column 'nonexistent' not in dataframe columns"
  )
})
