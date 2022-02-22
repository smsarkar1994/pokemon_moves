rm(list = ls())
library(tidyverse)
library(rvest)
library(data.table)

dir <- #insert directory here
input <- paste0(dir, "input/")
output <- paste0(dir, "output/")

gen_data <- function(move_type, gen) {
  
  url <- glue::glue("https://pokemondb.net/move/generation/{gen}#cat={move_type}")
  
  df <- read_html(url) %>%
    html_table() %>%
    data.frame() %>%
    mutate(move_type = move_type,
           gen_introduced = gen)
  
  return(df)
}

test <- gen_data("physical", 1)

all_moves <- data.frame()

for (i in 1:8) {
  for (j in c("physical", "special", "status")) {
    tmp <- gen_data(j, i)
    l <- list(all_moves, tmp)
    all_moves <- rbindlist(l)
  }
}

all_moves <- all_moves %>%
  dplyr::select(-`Cat.`)

write.csv(all_moves, paste0(output, "01_moves_gen_8.csv"))
