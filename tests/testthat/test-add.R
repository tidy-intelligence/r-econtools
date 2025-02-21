library(testthat)

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

test_that("add_population_column works with basic input", {
  skip_if_offline()
  df <- data.frame(country = c("USA", "CAN", "MEX"))
  result <- add_population_column(df, id_column = "country")
  expect_true("population" %in% names(result))
})

test_that("add_population_column works with time series", {
  skip_if_offline()
  df <- data.frame(
    country = rep(c("USA", "CAN"), each = 2),
    year = rep(2022:2023, 2)
  )
  result <- add_population_column(
    df, id_column = "country", date_column = "year"
  )
  expect_true("population" %in% names(result))
})

test_that("add_poverty_ratio_column works with basic input", {
  skip_if_offline()
  df <- data.frame(country = c("USA", "CAN", "MEX"))
  result <- add_poverty_ratio_column(df, id_column = "country")
  expect_true("poverty_ratio" %in% names(result))
})

test_that("add_population_density_column works with basic input", {
  skip_if_offline()
  df <- data.frame(country = c("USA", "CAN", "MEX"))
  result <- add_population_density_column(df, id_column = "country")
  expect_true("population_density" %in% names(result))
})

test_that("add_population_share_column works correctly", {
  skip_if_offline()
  df <- data.frame(
    country = c("USA", "CAN", "MEX"),
    value = c(1000, 2000, 3000)
  )
  result <- add_population_share_column(
    df,
    id_column = "country",
    value_column = "value"
  )
  expect_true("population_share" %in% names(result))
})

test_that("add_income_level_column works correctly", {
  skip_if_offline()
  df <- data.frame(country = c("USA", "CAN", "MEX"))
  result <- add_income_level_column(df, id_column = "country")
  expect_true("income_level_id" %in% names(result))
  expect_true("income_level_name" %in% names(result))
})


test_that("functions handle missing data appropriately", {
  skip_if_offline()
  df <- data.frame(country = c("USA", NA, "MEX"))
  expect_warning(add_population_column(df, id_column = "country"))
})

test_that("functions handle invalid dates appropriately", {
  skip_if_offline()
  df <- data.frame(
    country = c("USA", "CAN"),
    year = c(2022, -1)
  )
  expect_warning(
    add_population_column(df, id_column = "country", date_column = "year")
  )
})

test_that("functions respect custom column names", {
  skip_if_offline()
  df <- data.frame(country = c("USA", "CAN", "MEX"))
  result <- add_population_column(
    df,
    id_column = "country",
    target_column = "custom_pop"
  )
  expect_true("custom_pop" %in% names(result))
})
