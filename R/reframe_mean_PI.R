reframe_mean_PI <- function(d, .by = NULL, ..., width = 0.89) {
  assertthat::assert_that(
    !assertthat::has_name(d, "name"),
    msg = "Data frame cannot contain a variable called `name`."
  )
  assertthat::assert_that(
    assertthat::has_name(d, "value"),
    msg = "Data frame must contain a variable called `value`."
  )
  d |> 
    reframe(
      tibble(
        name = c("mean", "lower", "upper"), 
        value = c(mean(value), PI(value, prob = width))
      ),
      .by = {{ .by }}
    )
}
