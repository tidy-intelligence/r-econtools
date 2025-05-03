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
    df,
    id_column = "country",
    date_column = "year"
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

test_that("add_short_names_column adds expected short name column", {
  df <- tibble(code = c("USA", "CAN"))

  result <- add_short_names_column(df, "code")

  expect_true("short_name" %in% names(result))
  expect_equal(result$short_name[match("USA", result$code)], "United States")
  expect_equal(result$short_name[match("CAN", result$code)], "Canada")
})

test_that("add_iso3_codes_column adds expected iso3_code column", {
  df <- tibble(name = c("United States", "Canada"))

  result <- add_iso3_codes_column(df, "name")

  expect_true("iso3_code" %in% names(result))
  expect_equal(result$iso3_code[match("United States", result$name)], "USA")
  expect_equal(result$iso3_code[match("Canada", result$name)], "CAN")
})

test_that("add_short_names_column errors if id_column is 'entity_id'", {
  df <- tibble(entity_id = "USA")

  expect_error(
    add_short_names_column(df, "entity_id"),
    "is not allowed to be named `entity_id`"
  )
})

test_that("add_iso3_codes_column errors if id_column is 'entity_id'", {
  df <- tibble(entity_id = "United States")

  expect_error(
    add_iso3_codes_column(df, "entity_id"),
    "is not allowed to be named `entity_id`"
  )
})

test_that("add_population_column works with regex id_type & name variations", {
  skip_if_offline()
  df <- data.frame(
    id = rep("USA", 5),
    name = c("United States", "United.states", "US", "USA", "United States"),
    year = 2019:2023,
    gdp = c(2.15e13, 2.14e13, 2.37e13, 2.60e13, 2.77e13),
    stringsAsFactors = FALSE
  )

  result <- add_population_column(
    df,
    id_column = "name",
    id_type = "regex"
  )

  expect_true("population" %in% names(result))
  expect_equal(nrow(result), 5)
  expect_false(all(is.na(result$population)))
  expect_type(result$population, "double")
})

test_that("add_population_column errors when id_column is 'entity_id'", {
  df <- data.frame(
    entity_id = rep("usa", 3),
    year = 2020:2022,
    stringsAsFactors = FALSE
  )

  expect_error(
    add_population_column(
      df,
      id_column = "entity_id",
      id_type = "regex"
    ),
    regexp = "is not allowed to be named `entity_id` for regex"
  )
})
