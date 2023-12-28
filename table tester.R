unique_dobs %>% gt() %>%

  tab_options(container.height = px(300),
              container.padding.y = px(24), row_group.default_label = "User Info", row_group.as_column = TRUE)