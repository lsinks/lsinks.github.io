# from https://docs.ropensci.org/magick/reference/animation.html

library(magick)
# Combine images
logo <- image_read("https://jeroen.github.io/images/Rlogo.png")
oldlogo <- image_read("https://jeroen.github.io/images/Rlogo-old.png")

# Create morphing animation
both <- image_scale(c(oldlogo, logo), "400")
image_average(image_crop(both))
image_animate(image_morph(both, 10))

# Create thumbnails from GIF
banana <- image_read("https://jeroen.github.io/images/banana.gif")
length(banana)
image_average(banana)
image_flatten(banana)
image_append(banana)
image_append(banana, stack = TRUE)

# Append images together
wizard <- image_read("wizard:")
image_append(image_scale(c(image_append(banana[c(1,3)], stack = TRUE), wizard)))

image_composite(banana, image_scale(logo, "300"))

# Break down and combine frames
front <- image_scale(banana, "300")
background <- image_background(image_scale(logo, "400"), 'white')
frames <- image_apply(front, function(x){image_composite(background, x, offset = "+70+30")})
image_animate(frames, fps = 10)
# Simple 4x3 montage
input <- rep(logo, 12)
image_montage(input, geometry = 'x100+10+10', tile = '4x3', bg = 'pink', shadow = TRUE)

# With varying frame size
input <- c(wizard, wizard, logo, logo)
image_montage(input, tile = '2x2', bg = 'pink', gravity = 'southwest')

#testing
p1 <-image_read( here(blog_folder, photo_folder, df_temp$photo_names[1]) )
p2 <-image_read( here(blog_folder, photo_folder, df_temp$photo_names[2]) )
p3 <-image_read( here(blog_folder, photo_folder, df_temp$photo_names[3]) )
input <- c(p1 , p2 ,p3)
#image_montage(input, tile = '2x2', bg = 'pink', gravity = 'southwest')
photo_panel <- image_append(input)
image_write(photo_panel, path =  here(blog_folder, photo_folder, paste0(df_temp$full_name[1], "_panel.png")), format = "png")

 file.rename(from = here(blog_folder, photo_folder, df_temp$photo_names[1]),
                         to = here(blog_folder, archive_folder, df_temp$photo_names[1]) )
 file.rename(from = here(blog_folder, photo_folder, df_temp$photo_names[2]),
             to = here(blog_folder, archive_folder, df_temp$photo_names[2]) )
 file.rename(from = here(blog_folder, photo_folder, df_temp$photo_names[3]),
             to = here(blog_folder, archive_folder, df_temp$photo_names[3]) )
 
