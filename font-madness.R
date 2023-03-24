
loadfonts()

joined %>%
  ggplot(aes(line_comment_token, n, size = log(number_of_users), 
             color = log(number_of_users), label = title)) +
  # geom_point() +
  scale_y_log10() +
  geom_text_repel(show.legend = FALSE) +
  
  ggtitle('\u00a3') +
  #theme(text = element_text(family = "font1")) +
  theme(text = element_text( family = "CM Symbol")) +
  xlab("Token") +
  ylab("Number of languages using token") 
#theme_classic()

p <- qplot(c(1,5), c(1,5)) +
  xlab("Made with CM fonts") + ylab("Made with CM fonts") +
  ggtitle("Made with CM fonts")

# Equation
eq <- "italic(sum(frac(1, n*'!'), n==0, infinity) ==
       lim(bgroup('(', 1 + frac(1, n), ')')^n, n %->% infinity))"

# Without the new fonts
p + annotate("text", x=3, y=3, parse=TRUE, label=eq)

# With the new fonts
p + annotate("text", x=3, y=3, parse=TRUE, family="CM Roman", label=eq) +
  theme(text         = element_text(size=16, family="CM Roman"),
        axis.title.x = element_text(face="italic"),
        axis.title.y = element_text(face="bold"))
