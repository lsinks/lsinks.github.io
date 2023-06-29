
# turn the url to HTML anchor tag
historic_4269 <- historic_4269 %>% 
  mutate(tag = paste0("Info: <a href=", External.Link,">", External.Link, "</a>"))

historic_4269_2 <- sf::st_transform(historic_4269, crs = 4326)
arlington_polygons_sf_2 <- sf::st_transform(arlington_polygons_sf, crs = 4326) 

leaflet_map <- leaflet() %>% 
  addPolygons(data = arlington_polygons_sf_2, weight = 1, label = ~ CIVIC) %>%
  addProviderTiles(providers$CartoDB.Positron) %>% 
 addCircleMarkers(data = historic_4269_2, popup = ~tag, # note the tilde notation!
                  opacity = .75,
                 stroke = NA)
leaflet_map
