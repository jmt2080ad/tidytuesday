library(ggmap)
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

## subset data
bd <- bd[!is.na(year),]
bd <- bd[crossing != "MTS Trail",]
bd <- bd[order(crossing, date, hour, direction),]

bd[,cid:=paste0("c", as.numeric(as.factor(crossing)))]
bd[,did:=paste0("d", as.numeric(as.factor(direction)) %% 2 + 1)]

bd <- dcast(bd,
            cid+date+year+month+day+hour~did,
            value.var="bike_count",
            fun.aggregate=sum)

## export data
bd[,fwrite(.SD, paste0("./data/bd", unique(.SD[,.(cid)]), ".csv")), by = cid]

