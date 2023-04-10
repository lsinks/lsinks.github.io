#https://statisticaloddsandends.wordpress.com/2021/07/08/using-different-fonts-with-ggplot2/

library(ggplot2)
windowsFonts("Cambria Math" = windowsFont("Cambria Math"))
base_fig <- ggplot(data = economics, aes(date, pop)) +
  geom_line() +
  labs(title = "Total US population over time",
       subtitle = "Population in thousands",
       x = "Date",
       y = "Total population (in thousands)")

base_fig


base_fig +
  theme(text = element_text(family = "Cambria Math"))


# base_fig +
#   theme(plot.title    = element_text(family = "mono"),
#         plot.subtitle = element_text(family = "sans"),
#         axis.title.x  = element_text(family = "Comic Sans MS"),
#         axis.title.y  = element_text(family = "AppleGothic"),
#         axis.text.x   = element_text(family = "Optima"),
#         axis.text.y   = element_text(family = "Luminari"))