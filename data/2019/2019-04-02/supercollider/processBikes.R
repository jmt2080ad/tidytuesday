library(data.table)

bd <- fread("../data/bike_traffic.csv")

## add fields
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

bd[is.na(bike_count), bike_count:=0]

## subset data
bd <- bd[!is.na(year),]
bd <- bd[crossing != "MTS Trail",]
bd <- bd[order(crossing, date, hour, direction),]

bd[,cid:=as.numeric(as.factor(crossing))]
bd[,direction:=tolower(substring(direction, 1, 1))]

## export data
exportFun <- function(nm, dir){
    invisible({
        dat <- bd[cid == nm & direction == dir,]$bike_count
        con <- file(paste0("./data/c", nm, "_", dir, ".sc"), open = "w")
        writeLines(paste0("~c", nm, dir, "=[", paste(dat, collapse = ","), "].asCollection;"), con)
        close(con)
    })
}

expTab <- unique(bd[,.(cid, direction)])
invisible({mapply(exportFun, expTab[[1]], expTab[[2]])})
