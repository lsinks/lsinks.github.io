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


#now matching against the tombstone data.
# first clean up the names
rev_war <- df.new %>%
  separate(link_text, sep = " \\(", into = c("name_unclean", "id_unclean") ) 


#clean up the id number
rev_war <- rev_war %>%
  #transmute(name_unclean, url, SAR_ID = str_replace(id_unclean, "\\)", ""))
  mutate(SAR_ID = str_replace(id_unclean, "\\)", ""))


rev_war <- rev_war %>%
  mutate(name =
    str_replace(name_unclean, "Mrs", "")
  )

# there appear to be leading and tailing strings on the name
rev_war <- rev_war %>%
  mutate(name =
           str_trim(name, side = c("both"))
  )

#there also seems to be two or three spaces between the first name and the rest
#it is wildly variable. usually two or three but sometimes only one for long names
# so I can't use that to separate names.

#deal with JR and senior first
rev_war <- rev_war %>%
  mutate(suffix =
           case_when(
             str_detect(name, "Jr") == TRUE ~ "Jr",
             str_detect(name, "Sr") == TRUE ~ "Sr",
             TRUE ~ ""
           )
  )

#now remove the Jr and sr from the name
rev_war <- rev_war %>%
  mutate(name =
           str_replace(name, "Jr", "")
  ) %>%
  mutate(name =
           str_replace(name, "Sr", "")
  )

#double check the white space issue
rev_war <- rev_war %>%
  mutate(name =
           str_trim(name, side = c("both"))
  )

#now generate the last names, here the separator is the opposit, lowercase followed
#by one or more spaces. We've lost name though. So we need to separate out the last name first
#use the remove = FALSE Tag

rev_war <- rev_war %>%
  separate(name, into = c("trash2", "Last_name"), remove = FALSE, sep = "[a-z]{2,}\\s+") 




#so now I separate out the last name per. My pattern is a space followed by a 
#capital letter. But this isn't a separator- I'll lose the first letter if it is.
#that will actually get me the first name.


#bard gave me the regex!
rev_war <- rev_war %>%
  separate(name, into = c("first_name", "trash"), remove = FALSE, sep = "\\s+[A-Z]{2,}") 
  
#delete the two trash columns
rev_war <- rev_war %>%
  select(-trash, -trash2)

rev_war <- rev_war %>%
  mutate(Last_name_2 = ifelse(length(Last_name) == 1, str_extract(name, "[A-Z]{2,}.+"), Last_name))

rev_war <- rev_war %>%
  mutate(Last_name_3 = str_extract(name, "[A-Z]{2,}.+"))



#Now we need to split the names with /
rev_war_test <- rev_war %>%
  separate_wider_delim(
    Last_name_3,
    names = c(
      "V1",
      "V2",
      "V3"), delim = "/",too_few = c("debug"), too_many = c("debug"), cols_remove = FALSE )

rev_war_test <- rev_war_test %>%
  select(name_unclean, first_name, V1, V2, V3, suffix, url, SAR_ID)

rev_war_test <- rev_war_test %>%
  mutate(V2 = ifelse(is.na(V2), "", V2),
         V3 = ifelse(is.na(V3), "", V3),
         V1 = str_to_title(V1),
         V2 = str_to_title(V2),
         V3 = str_to_title(V3)
         )

#first round matching
rev_war_test <- rev_war_test %>%
  mutate(match_1 = paste0(V1, " ", first_name))

matched_records <- rev_war_test %>% inner_join(tombstones, by = c("match_1" = "full_name"))

# We could try to clean up by date of birth or death, though that information isn't
# available for all matches. The SAR records don't have the middle names in the title
# probably easier just to ask.
