library(tidyverse) # who doesn't want to be tidy?
library(ggthemes) # more themes for ggplot
library(gt) # For nice tables
library(ggrepel) # to help position labels in ggplot graphs
library(openxlsx) # importing excel files from a URL
library(fuzzyjoin) # for joining on inexact matches
library(sf) # for handling geo data
library(mapview) # quick interactive mapping
library(leaflet) # more mapping


# read in excel sheet
tombstones <-
  read.xlsx(
    'posts/2023-06-30-leaflet2/Tombstone_Data_small.xlsx' ,
    sheet = 1
  )

#converting to decimal latitude
tombstones <- tombstones %>%
  mutate(part1N = str_split_fixed(N, pattern = " ", n = 2) ) %>%
  mutate(N_degree = as.numeric(part1N[,1])) %>%
  mutate(part2N = str_split_fixed(part1N[,2], pattern = '\\.', n = 2)) %>%
  mutate(N_minute = as.numeric(part2N[,1])) %>%
  mutate(N_second = as.numeric(part2N[,2])) %>%
  mutate(lat = N_degree + N_minute/60 + N_second/3600)

#converting to decimal longitude  
tombstones <- tombstones %>%
  mutate(part1W = str_split_fixed(W, pattern = " ", n = 2) ) %>%
  mutate(W_degree = as.numeric(part1W[,1])) %>%
  mutate(part2W = str_split_fixed(part1W[,2], pattern = '\\.', n = 2)) %>%
  mutate(W_minute = as.numeric(part2W[,1])) %>%
  mutate(W_second = as.numeric(part2W[,2])) %>%
  mutate(long = -(W_degree + W_minute/60 + W_second/3600)) 

tombstones <- tombstones %>%
  select(-contains("part"))

tombstones <- tombstones %>%
  mutate(full_name = paste(Surname, First.Name, sep = " "))

photo_names = list.files("posts/2023-06-30-leaflet2/Photos")
df = as.data.frame(photo_names)

tombstones_merged <- fuzzy_right_join(df, tombstones, 
                             by = c("photo_names" = "full_name"),
                             match_fun = str_detect)

# turn photo tag
tombstones_merged <- tombstones_merged %>%
  drop_na(photo_names) %>%
  mutate(tag = paste0("<img src=",
                      paste0("./posts/2023-06-30-leaflet2/Photos/", photo_names),">"))


tombstones_merged <- tombstones_merged %>% drop_na(lat) %>% drop_na(long)


tombstones_geo <- st_as_sf(tombstones_merged, coords = c("long", "lat"), crs = 4326)
tombstones_geo <- st_jitter(tombstones_geo, factor = 0.004)

image_list <- tombstones_geo$photo_names

m<- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(
    data = tombstones_geo,
    label = ~ paste(First.Name, Surname, photo_names, sep = " "),
   # popup = leafpop::popupImage(paste0("posts/2023-06-30-leaflet2/Photos/", image_list)),
    clusterOptions = markerClusterOptions(),
    opacity = 1,
    radius = 5,
    color = "black",
    stroke = NA,
    group = "group1"
  ) %>%
  leafpop::addPopupImages(
    image = paste0("posts/2023-06-30-leaflet2/Photos/", image_list),
    src = local,
    group = "group1", width = 600,
    maxHeight = 300, maxWidth = 600
  )


library(htmlwidgets)

# Save the map as an HTML widget
saveWidget(m, file = "tomstones_map2.html")


# popup = ~tag,

