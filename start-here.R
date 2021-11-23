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
# https://github.com/rstudio/cheatsheets/blob/main/data-transformation.pdf
library(dplyr)

# {dbplyr} helps dplyr work with databases
# https://dbplyr.tidyverse.org/
library(dbplyr)

# {tidyr} is for reshaping and tidying data
# https://github.com/rstudio/cheatsheets/blob/main/tidyr.pdf
library(tidyr)

# {stringr} is convenient library for working with strings
# https://github.com/rstudio/cheatsheets/blob/main/strings.pdf
library(stringr)

# {readr} is great for reading and writing csv files
# https://github.com/rstudio/cheatsheets/blob/main/data-import.pdf
library(readr)

# Prepare relig_income data -----------------------------------------------

# Source all functions for preparing relig_income data
source(here("prepare", "relig_income.R"))

relig_income_tidy <- here("data","raw","relig_income_raw.csv") %>% 
  # Load relig_income data
  readr::read_csv() %>% 
  # Tidy the relig_income data
  tidy_relig_income()

# Prepare the anscombe data -----------------------------------------------

# Load all functions for preparing anscombe data
source(here("prepare", "anscombe.R"))

anscombe_tidy <- here("data","raw","anscombe_raw.csv") %>% 
  # Load anscombe data
  readr::read_csv() %>% 
  # Tidy the anscombe data
  tidy_anscombe()

# Create a SQLite database for all processed data --------------------------

# Load the mtcars and iris data
mtcars_raw <- readr::read_csv(here("data","raw","mtcars_raw.csv"))
iris_raw <- readr::read_csv(here("data","raw","iris_raw.csv"))

# Create the SQLite database and establish connection
con <- DBI::dbConnect(
  RSQLite::SQLite(), 
  here("data", "processed", "db1.sqlite")
)

# Write all tables to the SQLite database db1
DBI::dbWriteTable(con, "relig_income", relig_income_tidy)
DBI::dbWriteTable(con, "anscombe", anscombe_tidy)
DBI::dbWriteTable(con, "mtcars", mtcars_raw)
DBI::dbWriteTable(con, "iris", iris_raw)

# Disconnect from the SQLite database db1
DBI::dbDisconnect(con)

# Begin analysis ----------------------------------------------------------

# Load all functions for main analysis
source(here("analyse", "main-analysis.R"))

### Insert analysis code here that uses processed data from SQLite db1

### output figures to the present/figures folder








