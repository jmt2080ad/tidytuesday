library(data.table)

dat <- fread("./per-capita-plastic-waste-vs-gdp-per-capita.csv")
setnames(dat, names(dat), make.names(names(dat)))

year <- dat[order(Year),
            all(is.na(Per.capita.plastic.waste..kilograms.per.person.per.day.)),
            by = "Year"][V1 == FALSE,]$Year

dat <- dat[Year == year,]
