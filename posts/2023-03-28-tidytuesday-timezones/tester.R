skim(transitions)
skim(timezones)


num_zones <- timezone_countries %>%
  count(country_code)

skim(timezone_countries$country_code)

library(lutz)

tz_plot(us_tz$zone[1])

for (index in 1: 29) {
  print(tz_plot(us_tz$zone[index]))
  index <- index + 1
}