library(tidyverse) # who doesn't want to be tidy?
library(ggthemes) # more themes for ggplot
library(gt) # For nice tables
library(ggrepel) # to help position labels in ggplot graphs
library(openxlsx) # importing excel files from a URL
library(fuzzyjoin) # for joining on inexact matches
library(sf) # for handling geo data
library(mapview) # quick interactive mapping
library(leaflet) # more mapping
library(here)

blog_folder <- "posts/2023-06-30-leaflet2"
photo_folder = "Photos"
shape_folder <- "Shape"
il_sf <- st_read(here(blog_folder, shape_folder, "Struct_Point.shp"))
il_sf_4326 <- sf::st_transform(il_sf, crs = 4326)
il_sf_4326_cemetery <- il_sf_4326 %>%
  filter(ftype == 820)
mapview(il_sf_4326_cemetery) 


