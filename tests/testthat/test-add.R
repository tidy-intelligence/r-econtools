test_that(
  paste(
    "add_population_column joins by id only when date_column is NULL",
    "and renames to population"
  ),
  {
    fake_pop <- data.frame(
      id = c("USA", "CAN"),
      year = 2000L,
      value = c(10, 20)
    )
    df <- data.frame(country = c("USA", "CAN"))

    with_mocked_bindings(
      get_population = function(entities, most_recent_only, ...) {
        expect_true(most_recent_only) # NULL date -> TRUE
        fake_pop
      },
      {
        out <- add_population_column(df, id_column = "country")
        expect_equal(names(out), c("country", "population"))
        expect_equal(out$population, c(10, 20))
      }
    )
  }
)

test_that(
  paste(
    "add_population_column joins by id + year when date_column provided"
  ),
  {
    fake_pop <- data.frame(
      id = c("USA", "CAN"),
      year = c(2019L, 2020L),
      value = c(30, 40)
    )
    df <- data.frame(country = c("USA", "CAN"), year = c(2019L, 2020L))

    with_mocked_bindings(
      get_population = function(entities, most_recent_only, ...) {
        expect_false(most_recent_only) # date provided -> FALSE
        fake_pop
      },
      {
        out <- add_population_column(
          df,
          id_column = "country",
          date_column = "year"
        )
        expect_equal(names(out), c("country", "year", "population"))
        expect_equal(out$population, c(30, 40))
      }
    )
  }
)

test_that(
  paste(
    "add_poverty_ratio_column and add_population_density_column",
    "set the right target names"
  ),
  {
    fake <- data.frame(id = "USA", year = 2000L, value = 0.1)

    with_mocked_bindings(
      get_poverty_ratio = function(...) fake,
      {
        out1 <- add_poverty_ratio_column(
          data.frame(cc = "USA"),
          id_column = "cc"
        )
        expect_equal(names(out1), c("cc", "poverty_ratio"))
      }
    )

    with_mocked_bindings(
      get_population_density = function(...) fake,
      {
        out2 <- add_population_density_column(
          data.frame(cc = "USA"),
          id_column = "cc"
        )
        expect_equal(names(out2), c("cc", "population_density"))
      }
    )
  }
)

test_that(
  paste(
    "add_gdp_column passes through extra args (usd = FALSE)",
    "and respects date_column"
  ),
  {
    fake <- data.frame(
      id = c("USA", "USA"),
      year = c(2018L, 2019L),
      value = c(1, 2)
    )
    df <- data.frame(cc = "USA", year = 2019L)

    with_mocked_bindings(
      get_gdp = function(entities, most_recent_only, usd) {
        expect_false(usd)
        expect_false(most_recent_only) # date provided
        fake
      },
      {
        out <- add_gdp_column(
          df,
          id_column = "cc",
          date_column = "year",
          usd = FALSE
        )
        expect_equal(names(out), c("cc", "year", "gdp"))
        expect_equal(out$gdp, 2)
      }
    )
  }
)

test_that(
  paste(
    "add_gov_exp_column and add_gov_exp_share_column",
    "produce correctly named outputs"
  ),
  {
    fake <- data.frame(id = "CAN", year = 2005L, value = 123)

    with_mocked_bindings(
      get_gov_exp = function(...) fake,
      {
        out1 <- add_gov_exp_column(data.frame(cc = "CAN"), id_column = "cc")
        expect_equal(names(out1), c("cc", "gov_exp"))
      }
    )

    with_mocked_bindings(
      get_gov_exp_share = function(...) fake,
      {
        out2 <- add_gov_exp_share_column(
          data.frame(cc = "CAN"),
          id_column = "cc"
        )
        expect_equal(names(out2), c("cc", "gov_exp_share"))
      }
    )
  }
)

test_that(
  paste(
    "add_population_share_column divides value_column by population"
  ),
  {
    # no date column
    fake_pop <- data.frame(id = "USA", year = 2000L, value = 10)
    df <- data.frame(cc = "USA", value = 5)

    with_mocked_bindings(
      get_population = function(...) fake_pop,
      {
        out <- add_population_share_column(
          df,
          id_column = "cc",
          value_column = "value"
        )
        expect_equal(
          names(out),
          c("cc", "value", "population", "population_share")
        )
        expect_equal(out$population_share, 0.5)
      }
    )

    # with date column
    fake_pop2 <- data.frame(id = "USA", year = 2019L, value = 20)
    df2 <- data.frame(cc = "USA", year = 2019L, myval = 10)

    with_mocked_bindings(
      get_population = function(...) fake_pop2,
      {
        out2 <- add_population_share_column(
          df2,
          id_column = "cc",
          date_column = "year",
          value_column = "myval"
        )
        expect_equal(
          names(out2),
          c("cc", "year", "myval", "population", "population_share")
        )
        expect_equal(out2$population_share, 0.5)
      }
    )
  }
)

test_that(
  paste(
    "add_income_level_column left-joins income levels by id",
    "and keeps expected columns"
  ),
  {
    df <- data.frame(code = c("USA", "MEX"))
    fake_levels <- data.frame(
      id = c("USA", "MEX"),
      income_level_id = c("HIC", "UMC"),
      income_level_name = c("High income", "Upper middle income")
    )

    with_mocked_bindings(
      get_income_levels = function(entities) {
        expect_setequal(entities, c("USA", "MEX"))
        fake_levels
      },
      {
        out <- add_income_level_column(df, id_column = "code")
        expect_equal(
          names(out),
          c("code", "income_level_id", "income_level_name")
        )
      }
    )
  }
)

test_that(
  paste(
    "add_generic_column with id_type = 'regex' maps to entity_id then joins;",
    "error when id_column == entity_id"
  ),
  {
    # successful regex path
    df <- data.frame(name = c("United States", "Canada"))
    fake_map <- data.frame(
      name = c("United States", "Canada"),
      entity_id = c("USA", "CAN"),
      stringsAsFactors = FALSE
    )
    fake_fetch <- data.frame(
      id = c("USA", "CAN"),
      year = 2000L,
      value = c(10, 20)
    )

    with_mocked_bindings(
      standardize_entity = function(df, ..., output_cols) {
        expect_identical(output_cols, "entity_id")
        fake_map
      },
      get_population = function(entities, most_recent_only, ...) {
        expect_setequal(entities, c("USA", "CAN"))
        expect_true(most_recent_only) # no date
        fake_fetch
      },
      {
        out <- add_population_column(df, id_column = "name", id_type = "regex")
        expect_equal(names(out), c("name", "entity_id", "population"))
        expect_equal(out$population, c(10, 20))
      }
    )

    # error when id_column == "entity_id" and id_type == "regex"
    expect_error(
      add_population_column(
        data.frame(entity_id = "X"),
        id_column = "entity_id",
        id_type = "regex"
      ),
      "is not allowed to be named `entity_id` for regex\\."
    )
  }
)

test_that(
  paste(
    "add_short_names_column validates id_column",
    "and errors when id_column == 'entity_id'; otherwise renames to short_name"
  ),
  {
    # error branch
    expect_error(
      add_short_names_column(
        data.frame(entity_id = "X"),
        id_column = "entity_id"
      ),
      "is not allowed to be named `entity_id`\\."
    )

    # success branch with mapping to entity_name -> short_name
    df <- data.frame(code = c("USA", "CAN"))
    fake_map <- data.frame(
      code = c("USA", "CAN"),
      entity_name = c("United States", "Canada")
    )

    with_mocked_bindings(
      standardize_entity = function(df, ..., output_cols) {
        expect_identical(output_cols, "entity_name")
        fake_map
      },
      {
        out <- add_short_names_column(df, id_column = "code")
        expect_true("short_name" %in% names(out))
        expect_equal(out$short_name, c("United States", "Canada"))
      }
    )
  }
)

test_that(
  paste(
    "add_iso3_codes_column validates id_column",
    "and errors when id_column == 'entity_id'; otherwise renames to iso3_code"
  ),
  {
    # error branch
    expect_error(
      add_iso3_codes_column(
        data.frame(entity_id = "X"),
        id_column = "entity_id"
      ),
      "is not allowed to be named `entity_id`\\."
    )

    # success branch with mapping to iso3c -> iso3_code
    df <- data.frame(name = c("United States", "Canada"))
    fake_map <- data.frame(
      name = c("United States", "Canada"),
      iso3c = c("USA", "CAN")
    )

    with_mocked_bindings(
      standardize_entity = function(df, ..., output_cols) {
        expect_identical(output_cols, "iso3c")
        fake_map
      },
      {
        out <- add_iso3_codes_column(df, id_column = "name")
        expect_true("iso3_code" %in% names(out))
        expect_equal(out$iso3_code, c("USA", "CAN"))
      }
    )
  }
)
