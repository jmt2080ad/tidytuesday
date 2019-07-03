## geofacet

library(data.table)
library(geojsonio)
library(sp)

dat <- fread("./ufo_sightings.csv")
usa <- dat[country == "us",]
spd <- geojson_read("us_states_hexgrid.geojson",  what = "sp")

usa_state <- usa[, .N, by = "state"][,state:=toupper(state)]

usa_poly <- merge(spd, usa_state, by.x = "iso3166_2", by.y = "state", rainbow(max(usa_state$N)))

plot(usa_poly, col = rainbow(max(usa_state$N))[usa_state$N])

# Now I can plot this shape easily as described before:


















