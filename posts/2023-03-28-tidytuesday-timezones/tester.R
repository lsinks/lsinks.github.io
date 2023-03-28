skim(transitions)
skim(timezones)


num_zones <- timezone_countries %>%
  count(country_code)

skim(timezone_countries$country_code)

library(lutz)

US_tz <- timezone_countries %>% 
  filter(country_code == "US") %>%
  left_join(timezones)
  
wd <- getwd()
filepath= file.path(wd, "posts","2023-03-28-tidytuesday-timezones")

make_filename = function(number){
  # these can be easily turned into parameters
  dir = "/Users/jwolo/Documents/section_images/"
  
  # doing this, putting it all on a single line or using pipe %>%
  # is just matter of style
  filename = paste("tzplot", number, sep="_")
  filename = paste0(filename, ".png")
  filename = file.path(filepath, filename)
  
  filename
}
US_tz <- US_tz %>%
  mutate(image_name = "tbd")

index <- 1
for (index in seq(1, nrow(US_tz))) {
  print(index)
  filename = make_filename(index)
  US_tz[index , "image_name"] <- filename
  # 1. Open jpeg file
  png(filename, width = 350, height = 350, bg = "transparent")
  # 2. Create the plot
  print(tz_plot(US_tz$zone[index]))
  # 3. Close the file
  dev.off()
  index = index + 1
}


# 
# wd <- getwd()
# filename = file.path(wd, "posts","2023-03-28-tidytuesday-timezones",  "name.png")
# # 1. Open jpeg file
# png(filename, width = 350, height = 350, bg = "transparent")
# # 2. Create the plot
# #tz_plot(timezone_countries$zone[1])
# tz_plot(US_tz$zone[1])
# # 3. Close the file
# dev.off()

aspect_ratio <- 1.618

timezones |> 
  ggplot(aes(longitude, latitude)) +
  geom_point()

p <- map_data("world") %>% 
  ggplot(aes(long, lat)) +
  #geom_image(aes(image = filename), size = 0.05, by = "width", asp = aspect_ratio) +
  #geom_path(aes(group = group), color = "gray30", alpha = 0.1) +
  geom_polygon(aes(group = group), fill = "white", color = "gray30", alpha = 0.5) +
  #geom_image(aes(x = -4.033333, y = 5.3166667, image = filename),
  #           size = 0.05, by = "width", asp = aspect_ratio) +
  geom_image(aes(x = longitude, latitude, image = image_name), data = US_tz,
             size = 0.025, by = "width", asp = aspect_ratio) +
 # geom_point(aes(longitude, latitude, color = dst_label),
  #           data = tz_dst_2023) +
  coord_sf() +
  
  labs(title = "The United States has 29 Timezones\nMostly Redunant",
       color = "Time zones using\nDST as of 2023") +
  theme_void() +
  theme( aspect.ratio = 1/aspect_ratio,
    legend.position = "bottom",
    plot.background = element_rect(fill = "white", color = "white")
  )

ggsave("tester2.png", p, width = 5 * aspect_ratio, height = 5)
