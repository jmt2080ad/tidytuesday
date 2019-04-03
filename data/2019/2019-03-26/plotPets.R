library(rgdal)
library(pycno)
library(data.table)
library(raster)

zips <- readOGR("./data/zipcode.shp")
shor <- readOGR("./data/zipcode_shore.shp")

pets <- fread("./data/seattle_pets.csv")
seaz <- fread("./data/seaZips.csv")  

pets[,zip_code := sapply(strsplit(zip_code, "-"), "[", 1)]
names(zips@data)[2] <- "zip_code"
names(shor@data)[2] <- "zip_code"
zips <- zips[zips$zip_code %in% seaz$sea_zips,]
shor <- shor[shor$zip_code %in% seaz$sea_zips,]

dogs <- merge(zips, pets[species == "Dog", .N, by = "zip_code"], all.x = T)
cats <- merge(zips, pets[species == "Cat", .N, by = "zip_code"], all.x = T)

dogsPyc <- pycno(dogs, ifelse(is.na(dogs$N), 0, dogs$N), 1000)
catsPyc <- pycno(cats, ifelse(is.na(cats$N), 0, cats$N), 1000)

par(mfrow = c(1,2))
plot(raster(dogsPyc), main = "Dogs")
plot(shor, add = T)
plot(raster(catsPyc), main = "Cats")
plot(shor, add = T)
