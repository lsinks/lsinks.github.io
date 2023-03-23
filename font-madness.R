windowsFonts(font1 = "Segoe UI Symbol")
joined %>%
  ggplot(aes(line_comment_token, n, size = log(number_of_users), 
             color = log(number_of_users), label = title)) +
  # geom_point() +
  scale_y_log10() +
  geom_text_repel(show.legend = FALSE) +
  
  ggtitle('\u00a3') +
  theme(text = element_text(family = "font1")) +
  #theme(text= element_text(family = "Cambria Math")) +
  xlab("Token") +
  ylab("Number of languages using token") 
#theme_classic()