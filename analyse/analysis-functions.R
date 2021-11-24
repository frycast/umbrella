# This script contains all functions to conduct the main analysis


# This function fits all four linear models to the tidy anscombe data
fit_anscombe_models <- function(anscombe_tidy) {
 
  anscombe_tidy %>% 
    tidyr::nest(data = !set) %>%
    dplyr::mutate(
      model = purrr::map(data, ~lm(y~x, data = .)), 
      tidied = purrr::map(model, broom::tidy),
      data = purrr::map(model, broom::augment)) %>% 
    tidyr::unnest(tidied)
  
}

# This function plots the four anscombe datasets
plot_anscombe_data <- function(anscombe_tidy) {

  anscombe_tidy %>% 
    ggplot2::ggplot(aes(x = x, y = y)) +
    ggplot2::geom_point() + 
    ggplot2::facet_wrap(~set) +
    ggplot2::geom_smooth(method = "lm", se = FALSE) +
    ggplot2::theme_minimal()  
  
}
