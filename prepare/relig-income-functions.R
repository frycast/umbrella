# This script contains all functions for preparing the relig_income data

# Pivoting the table to make it tidy
tidy_relig_income <- function(relig_income) {
  tidyr::pivot_longer(
    data=relig_income,
    cols=!religion,
    names_to = "income", 
    values_to = "count"
  )
}