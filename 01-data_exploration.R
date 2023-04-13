library(tidyverse)

dat <- readr::read_tsv(file = "data/Alaska_salmon/salmon_cluster_2021.txt")
dat

names(dat)
skimr::skim(dat)

# the idea is to make a PCA for fishing decisions (actions), and another for
# non-fishing data: people / households level data that does not vary over time.
# First extract the repetitive columns and convert into an id.

households <- dat |>
  select(permitno:zip_perbach) |>
  unique() |>
  mutate(id = row_number())

## You will need to summarize the whole season for all the fishing variables, and
## merge with the households dataset for a PCA on households.

decisions <- dat |>
  select(where(is.numeric)) |>
  select(-year, -c(permitno:zip_perbach)) #|>princomp()

# To-do:
# scale and center: pre-compute to speed up?
# remove constant variables
# check for correlations

## If you want to predict something, what would that be? Fishing catch?
## Experimenting with tidy models
library(tidymodels)
set.seed(2024)

dat_split <- initial_split(dat, prop = 3/4)
dat_train <- training(dat_split)
dat_test <- testing(dat_split)

set.seed(9999)
dat_val <- validation_split(dat_train, prop = 4/5)



