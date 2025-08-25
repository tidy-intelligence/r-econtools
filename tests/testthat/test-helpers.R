test_that("current_year returns the current calendar year as integer", {
  expect_type(current_year(), "integer")
  expect_equal(
    current_year(),
    as.integer(format(Sys.Date(), "%Y"))
  )
})

test_that(
  paste(
    "filter_most_recent_only keeps most recent per entity & drops future years"
  ),
  {
    y <- current_year()

    df <- data.frame(
      id = c("E1", "E1", "E1", "E2", "E2", "E2"),
      year = c(y - 2, y - 1, y, y - 3, y + 1, y - 1),
      value = c(10, 11, 12, 20, 99, 21),
      stringsAsFactors = FALSE
    )

    res <- filter_most_recent_only(df)

    # Keeps one row per entity with the most recent non-future year
    expect_equal(nrow(res), 2L)
    # E1 keeps year == y
    expect_true(any(res$id == "E1" & res$year == y))
    # E2 had a future (y+1) which is dropped; most recent is y-1
    expect_true(any(res$id == "E2" & res$year == (y - 1)))

    # Result must be ungrouped
    expect_false(dplyr::is_grouped_df(res))
  }
)

test_that(
  paste(
    "filter_most_recent_only returns ties when multiple rows share the max year"
  ),
  {
    y <- current_year()

    df_tie <- data.frame(
      id = c("A", "A", "A", "B"),
      year = c(y - 1, y - 1, y - 2, y - 1),
      value = c(1, 2, 3, 4),
      stringsAsFactors = FALSE
    )

    res_tie <- filter_most_recent_only(df_tie)

    # For A, two rows share the max year (y-1) -> both retained
    expect_equal(
      nrow(subset(res_tie, id == "A")),
      2L
    )
    # For B, single max row retained
    expect_equal(
      nrow(subset(res_tie, id == "B")),
      1L
    )
  }
)

test_that(
  paste(
    "filter_most_recent_only returns empty df when all years are in the future"
  ),
  {
    y <- current_year()

    df_future <- data.frame(
      entity_id = c("X", "Y"),
      year = c(y + 1, y + 5),
      stringsAsFactors = FALSE
    )

    res_future <- filter_most_recent_only(df_future)

    expect_equal(nrow(res_future), 0L)
    # Still ungrouped and has the same columns
    expect_false(dplyr::is_grouped_df(res_future))
    expect_equal(colnames(res_future), colnames(df_future))
  }
)
