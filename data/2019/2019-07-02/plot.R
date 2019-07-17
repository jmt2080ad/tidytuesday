library(data.table)

dat <- fread("./media_franchises.csv")
dat <- unique(dat[,.(year_created, revenue = sum(revenue)), by = "franchise"])
dat <- rbind(dat[,.(franchise, year = year_created, revenue = 0)],
             dat[,.(franchise, year = 2018, revenue)])

plot(1920:2019, 0:99, col = "white", xlab = "Year", ylab = "Revenue (Billions)")
dat[ ,{lines(.SD[,.(year, revenue)]); Sys.sleep(100)}, by = "franchise"]
