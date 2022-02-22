rm(list = ls())
library(tidyverse)
library(rvest)
library(data.table)

dir <- "C:/Users/samee/Documents/oneoffs/11_pokemon_scrape/"
input <- paste0(dir, "input/")
output <- paste0(dir, "output/")


gen_data <- function(move_type) {
  
  url <- glue::glue("https://www.serebii.net/attackdex-swsh/{move_type}.shtml")
  
  df <- read_html(url) %>%
    html_table() 
  
  df <- df[2] %>%
    data.frame() 
  
  colnames(df) <- df[1,]
  df <- df[-1,]
  
  df <- df %>%
    mutate(move_type = move_type)
  
  return(df)
}


all_moves <- data.frame()

for (j in c("physical", "special", "other")) {
  tmp <- gen_data(j)
  l <- list(all_moves, tmp)
  all_moves <- rbindlist(l)
}


write.csv(all_moves, paste0(output, "01_moves_sw_sh.csv"))


#Example code for getting pokemon level data from a move
tmp_move <- tolower(all_moves[10, "Name"])

url <- glue::glue("https://www.serebii.net/attackdex-swsh/{tmp_move}.shtml")
df <- read_html(url) %>%
  html_table()
keep <- grep("Base Stats", df)
df <- df[keep]

clean_df <- function(df) {
  df <- data.frame(df)
  colnames(df) <- df[2,]
  df <- df[-c(1:2),]
  df <- repair_names(df)

  df <- df %>%
    filter(!is.na(Name)) %>%
    dplyr::select(`No.`, Type) 
  
}


name_pokemon <- data.frame() 

for(i in 1:length(df)) {
  tmp <- clean_df(df[i])
  l <- list(name_pokemon, tmp)
  name_pokemon <- rbindlist(l)
}
name_pokemon <- name_pokemon %>%
  mutate(move = tmp_move)

