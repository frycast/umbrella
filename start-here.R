# This script is the command center of your whole project.

# Everything should ideally be run from here.

# If all data are loaded and passed to functions from this script, 
# then your work will be much more transparent!

# The code in this script should act like a set of instructions for a newcomer
# to use your code for the first time. 

# It should all work seamlessly. 

# It should run when executed in order from top to bottom.

# Your script should be broken into logical segments.

# Load libraries ----------------------------------------------------------

# {here} makes it easy to manage directories
# https://www.tidyverse.org/blog/2017/12/workflow-vs-script/
library(here)

# {dplyr} introduces a grammar of data manipulation (similar to SQL)
# https://dplyr.tidyverse.org/f
library(dplyr)

# {dbplyr} helps dplyr work with databases
# https://dbplyr.tidyverse.org/
library(dbplyr)

# {tidyr} is for reshaping and tidying data
# https://tidyr.tidyverse.org/
library(tidyr)

# {stringr} is convenient library for working with strings
# https://stringr.tidyverse.org/
library(stringr)

# {readr} is great for reading and writing csv files
# https://readr.tidyverse.org/
library(readr)

# {purrr} makes it easy to work functionally with lists
# https://purrr.tidyverse.org/
library(purrr)

# {ggplot2} is provides a grammar of data visualisation
# https://ggplot2.tidyverse.org/
library(ggplot2)

# {broom} helps with summarising model results
# https://broom.tidymodels.org/
library(broom)

# Prepare relig_income data -----------------------------------------------

# Source all functions for preparing relig_income data
source(here("prepare", "relig-income-functions.R"))

relig_income_tidy <- here("data","raw","relig_income_raw.csv") %>% 
  # Load relig_income data
  readr::read_csv() %>% 
  # Tidy the relig_income data
  tidy_relig_income()

# Prepare the anscombe data -----------------------------------------------

# Load all functions for preparing anscombe data
source(here("prepare", "anscombe-functions.R"))

anscombe_tidy <- here("data","raw","anscombe_raw.csv") %>% 
  # Load anscombe data
  readr::read_csv() %>% 
  # Tidy the anscombe data
  tidy_anscombe()

# Create a SQLite database for all processed data --------------------------

# Load the mtcars and iris data
mtcars_raw <- readr::read_csv(here("data","raw","mtcars_raw.csv"))
iris_raw <- readr::read_csv(here("data","raw","iris_raw.csv"))

# Get the SQLite database location
db_location <- here("data", "processed", "db1.sqlite")

# Delete the database if it already exists
unlink(db_location)

# Create the SQLite database and establish connection
con <- DBI::dbConnect(RSQLite::SQLite(), db_location)

# Write all tables to the SQLite database db1
DBI::dbWriteTable(con, "relig_income", relig_income_tidy)
DBI::dbWriteTable(con, "anscombe", anscombe_tidy)
DBI::dbWriteTable(con, "mtcars", mtcars_raw)
DBI::dbWriteTable(con, "iris", iris_raw)

# Disconnect from the SQLite database db1
DBI::dbDisconnect(con)

# Begin analysis ----------------------------------------------------------

# Load all functions for main analysis
source(here("analyse", "analysis-functions.R"))

# Fit linear models
results <- fit_anscombe_models(anscombe_tidy)

# View the results
results

# Produce plots
plot_anscombe_data(anscombe_tidy)

## If you save plots, put them in the folder present/figures