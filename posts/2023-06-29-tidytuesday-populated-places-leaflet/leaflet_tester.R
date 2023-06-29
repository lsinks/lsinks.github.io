

historic_4269 <- st_read("posts/2023-06-28-tidytuesday-populated-places-leaflet/points.shp")
arlington_polygons_sf <- st_read("posts/2023-06-28-tidytuesday-populated-places-leaflet/polygons.shp")

# turn the url to HTML anchor tag
historic_4269 <- historic_4269 %>% 
  mutate(tag = paste0("More Info: <a href=", Extrn_L,">", Extrn_L, "</a>"))

historic_4269_2 <- sf::st_transform(historic_4269, crs = 4326)
arlington_polygons_sf_2 <- sf::st_transform(arlington_polygons_sf, crs = 4326) 

pal <- colorFactor(palette = "viridis", domain = arlington_polygons_sf_2$CIVIC)

leaflet_map <- leaflet() %>% 
  addPolygons(data = arlington_polygons_sf_2, weight = 1, label = ~ CIVIC, color = ~pal(CIVIC)) %>%
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addCircleMarkers(data = historic_4269_2, popup = ~paste0("<b>", Prprt_N,"</b>", "<br>", tag), # note the tilde notation!
                  opacity = 1, radius = 7, color = "black",
                 stroke = NA) 
leaflet_map
