# This script contains all functions for preparing the anscombe data

# Pivoting the table to make it tidy
tidy_anscombe <- function(anscombe) {
  tidyr::pivot_longer(
    data = anscombe,
    cols = tidyr::everything(),
    names_to = c(".value", "set"),
    names_pattern = "(.)(.)"
  )
}
