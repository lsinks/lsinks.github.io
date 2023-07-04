library(rvest)
library(here)

sar <- read_html(here("posts/2023-06-30-leaflet2", "Display Member - 121743 - John Douglas Sinks Ph.D..html"))
extract <- sar %>% html_children()
extract[2] %>% html_children()
extract[1] %>% html_children()
sar_table <-
  sar %>% html_elements("table") %>% html_children()

#https://stackoverflow.com/questions/63093926/retrieve-link-from-html-table-with-rvest
link_nodes <- sar %>% html_nodes(xpath = "//table//a")  
link_text  <- link_nodes %>% html_text()
text_df = as.data.frame(link_text)

index <- 1
for (index in seq(1: nrow(text_df))) {
  text_df$url[index] <- link_nodes[index] %>%  html_attr("href")
}

df.new <- text_df[seq(1, nrow(text_df), 3),]


