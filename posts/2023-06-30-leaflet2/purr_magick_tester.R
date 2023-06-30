library(magick)


#testing
index <- 1

for (index in seq(1:nrow(multiples))) {
  df_temp <- tombstones_merged %>%
    filter(full_name == multiples$full_name[index])
  df_temp
  these <-
    as.list(here(blog_folder, photo_folder, df_temp$photo_names))
  photo_panel <-
    image_append(do.call("c", lapply(these, image_read)))
  image_write(
    photo_panel,
    path =  here(
      blog_folder,
      photo_folder,
      paste0(df_temp$full_name[1], "_panel.png")
    ),
    format = "png"
  )
  index2 <- 1
  for (index2 in seq(1:nrow(df_temp))) {
    file.rename(
      from = here(blog_folder, photo_folder, df_temp$photo_names[index2]),
      to = here(blog_folder, archive_folder, df_temp$photo_names[index2])
    )
  }
}    
  