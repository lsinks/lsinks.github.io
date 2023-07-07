library(tidyr)

data <- data.frame(
  text = c("  A", "   B", "C"),
  stringsAsFactors = FALSE
)

data %>% separate(text, into = c("prefix", "letter"), sep = "\s+[A-Z]")

