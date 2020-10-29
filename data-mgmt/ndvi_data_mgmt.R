# Alfredo Rojas
# 10/28/2020
# description: converts ndvi output from GEE from wide to long format
# then stacks observations
# filename: ndvi_data_mgmt.R

library(tidyverse)
library(foreign)
library(haven)

# set up directory and files
path_name <- file.path("Dropbox", "Articles", "HAZ_paper", "NDVI_data")
setwd(path_name) # specify path name above
files <- list.files(path = ".", pattern = "\\.csv$", recursive = TRUE)

# create list for data.frames for efficiency
list_dfs <- list()
for(i in 1:NROW(files)) {

  # change data from wide to long for DHS data
  data <- read_csv(files[i]) %>%
    pivot_longer(
      cols = ends_with("ndvi"),
      names_to = "time",
      values_to = "ndvi",
      values_drop_na = FALSE
    )
  
  list_dfs[[i]] <- data
}

# stack data
complete_df <- list_dfs %>%
  do.call(rbind, .) %>%
  as_tibble() %>%
  rename(
    system_index = `system:index` 
  )

# export as DTA if needed
write_dta(complete_df, "ndvi_bf.dta")



