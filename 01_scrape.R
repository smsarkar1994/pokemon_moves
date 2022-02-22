rm(list = ls())
library(tidyverse)
library(rvest)

dir <- "C:/Users/samee/Documents/oneoffs/11_pokemon_scrape/"
input <- paste0(dir, "input/")
output <- paste0(dir, "output/")



url <- glue::glue("https://pokemondb.net/move/generation/8")



df <- read_html(url) %>%
  html_table() %>%
  data.frame() 


write.csv(df, paste0(output, "01_moves_gen_8.csv"))