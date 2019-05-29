library(data.table)
dat <- fread("winemag-data-130k-v2.csv")

subTab <- dat[,.N, by = variety]
setorder(subTab, N)
subTab <- subTab[(nrow(subTab)-10):nrow(subTab)]

dat <- merge(dat, subTab, on = variety)

plot(dat$points, dat$price, col = "white")
dat[,color:=as.numeric(factor(dat$taster_name))]
dat[, .SD[points(points, price, col = rainbow(20)[color])], .SDcols = "taster_name"]
