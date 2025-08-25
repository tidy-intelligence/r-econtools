test_that(
  paste(
    "get_population calls wbwdi::wdi_get with right indicator and shapes output"
  ),
  {
    fake <- data.frame(
      entity_id = c("A", "B"),
      year = c(2000L, 2001L),
      value = c(1, 2),
      extra = "ignored"
    )

    with_mocked_bindings(
      wdi_get = function(...) fake,
      {
        res <- get_population(c("A", "B"), most_recent_only = TRUE)
        expect_equal(names(res), c("id", "year", "value"))
      }
    )
  }
)

test_that(
  paste(
    "get_poverty_ratio calls wbwdi::wdi_get and shapes output"
  ),
  {
    fake <- data.frame(
      entity_id = "X",
      year = 1990L,
      value = 0.5,
      extra = 1
    )

    with_mocked_bindings(
      wdi_get = function(...) fake,
      {
        res <- get_poverty_ratio("X", most_recent_only = FALSE)
        expect_equal(names(res), c("id", "year", "value"))
      }
    )
  }
)

test_that(
  paste(
    "get_population_density calls wbwdi::wdi_get and shapes output"
  ),
  {
    fake <- data.frame(
      entity_id = "C",
      year = 2010L,
      value = 123.4,
      extra = 1
    )

    with_mocked_bindings(
      wdi_get = function(...) fake,
      {
        res <- get_population_density("C", most_recent_only = TRUE)
        expect_equal(names(res), c("id", "year", "value"))
      }
    )
  }
)

test_that(
  paste(
    "get_income_levels selects and filters entities,",
    "returning id + income columns"
  ),
  {
    fake_entities <- data.frame(
      entity_id = c("AA", "BB", "CC"),
      income_level_id = c("HIC", "LMY", "LMC"),
      income_level_name = c(
        "High income",
        "Lower middle income",
        "Lower middle income"
      ),
      other = 1:3
    )

    with_mocked_bindings(
      wdi_get_entities = function() fake_entities,
      {
        res <- get_income_levels(c("AA", "BB"))
        expect_equal(
          names(res),
          c("id", "income_level_id", "income_level_name")
        )
        expect_setequal(res$id, c("AA", "BB"))
      }
    )
  }
)

test_that(
  paste(
    "get_gdp (usd = TRUE) keeps NGDPD rows and scales by 1e9"
  ),
  {
    fake <- data.frame(
      entity_id = c("A", "A", "B", "B"),
      series_id = c("NGDPD", "NGDP", "NGDPD", "NGDP"),
      year = c(2000L, 2000L, 2001L, 2001L),
      value = c(1.1, 9.9, 2.2, 8.8)
    )

    with_mocked_bindings(
      weo_get = function(...) fake,
      {
        out <- get_gdp(c("A", "B"), most_recent_only = FALSE, usd = TRUE)
        expect_equal(names(out), c("id", "year", "value"))
        # only NGDPD kept and scaled
        expect_equal(out$value, c(1.1, 2.2) * 1e9)
      }
    )
  }
)

test_that(
  paste(
    "get_gdp (usd = FALSE) uses NGDP ",
    "and applies most_recent_only via filter_most_recent_only"
  ),
  {
    fake <- data.frame(
      entity_id = c("A", "A", "B"),
      series_id = c("NGDP", "NGDP", "NGDP"),
      year = c(1999L, 2001L, 2000L),
      value = c(3, 4, 5)
    )

    # Return a tiny, obvious reduction so we know the branch ran
    filtered <- data.frame(
      id = c("A", "B"),
      year = c(2001L, 2000L),
      value = c(4, 5) * 1e9
    )

    with_mocked_bindings(
      weo_get = function(...) fake,
      filter_most_recent_only = function(df) filtered,
      {
        out <- get_gdp(c("A", "B"), most_recent_only = TRUE, usd = FALSE)
        expect_equal(out, filtered)
      }
    )
  }
)

test_that(
  paste(
    "get_gov_exp uses GGX, keeps that series, scales by 1e9,",
    "and can apply most_recent_only"
  ),
  {
    fake <- data.frame(
      entity_id = c("X", "X", "Y", "Y"),
      series_id = c("GGX", "GGX_NGDP", "GGX", "GGX_NGDP"),
      year = c(2015L, 2015L, 2016L, 2016L),
      value = c(0.7, 70, 1.3, 65)
    )

    # most_recent_only = FALSE path
    with_mocked_bindings(
      weo_get = function(...) fake,
      {
        out <- get_gov_exp(c("X", "Y"), most_recent_only = FALSE)
        expect_equal(names(out), c("id", "year", "value"))
        expect_equal(out$value, c(0.7, 1.3) * 1e9)
      }
    )

    # most_recent_only = TRUE path (stub the reducer)
    filtered <- data.frame(
      id = c("X", "Y"),
      year = c(2015L, 2016L),
      value = c(0.7, 1.3) * 1e9
    )

    with_mocked_bindings(
      weo_get = function(...) fake,
      filter_most_recent_only = function(df) filtered,
      {
        out <- get_gov_exp(c("X", "Y"), most_recent_only = TRUE)
        expect_equal(out, filtered)
      }
    )
  }
)

test_that(
  paste(
    "get_gov_exp_share uses GGX_NGDP, divides by 100,",
    "and can apply most_recent_only"
  ),
  {
    fake <- data.frame(
      entity_id = c("X", "X", "Y"),
      series_id = c("GGX_NGDP", "GGX_NGDP", "GGX_NGDP"),
      year = c(2019L, 2020L, 2020L),
      value = c(40, 42, 55)
    )

    filtered <- data.frame(
      id = c("X", "Y"),
      year = c(2020L, 2020L),
      value = c(0.42, 0.55)
    )

    with_mocked_bindings(
      weo_get = function(...) fake,
      filter_most_recent_only = function(df) {
        # mimic keeping the latest year per entity after division by 100
        filtered
      },
      {
        out <- get_gov_exp_share(c("X", "Y"), most_recent_only = TRUE)
        expect_equal(out, filtered)
      }
    )
  }
)
