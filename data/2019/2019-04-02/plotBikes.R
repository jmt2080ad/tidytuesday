library(ggmap)
library(data.table)

bd <- fread("./data/bike_traffic.csv")
bd[,`:=`(date = as.Date(sapply(strsplit(date, " "), "[", 1), format = "%d/%m/%Y"),
         hour = as.numeric(gsub(":.*$", "", sapply(strsplit(date, " "), "[", 2))),
         perd = sapply(strsplit(date, " "), "[", 3)
         )
   ]

bd[,hour := ifelse(perd == "PM", hour + 12, hour)]
bd[,hour := ifelse(perd == "AM" & hour == 12, 0, hour)]

bd[,`:=`(month = as.numeric(format(date, format = "%m")),
         day   = as.numeric(format(date, format = "%d")),
         year  = as.numeric(format(date, format = "%Y"))
         )
   ]

bd[,meanHourBike  := mean(bike_count, na.rm = T), by = c("hour", "crossing", "year")]
bd[,meanDayBike   := mean(bike_count, na.rm = T), by = c("day",  "crossing", "year")]
bd[,meanMonthBike := mean(bike_count, na.rm = T), by = c("year", "crossing", "year")]

bd <- bd[!is.na(year),]

fwrite(bd, "./processing/bd.csv")

## par(mfrow = c(3, 4), mar = c(0, 0, 0, 0))
## for(i in 1:12){
##     plot(bd[month == i & day == 15]$hour, bd[month == i & day == 15]$meanHourBike, type = 'l')
## }

