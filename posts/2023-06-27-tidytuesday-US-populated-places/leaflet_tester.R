{r}
# turn the url to HTML anchor tag
historic_4269 <- historic_4269 %>% 
  mutate(tag = paste0("Info: <a href=", External.Link,">", External.Link, "</a>"))


#leaflet_map <- leaflet(historic_4269) #%>% 
#  addProviderTiles(providers$CartoDB.Positron) #%>% 
# addCircleMarkers(popup = ~tag, # note the tilde notation!
#                  opacity = .75,
#                 stroke = NA)
#leaflet_map
