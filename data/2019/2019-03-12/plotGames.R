library(data.table)
library(grid)

gam <- fread("./data/board_games.csv");
gam <- gam[,.(average_rating, playing_time, min_age)]

gam <- sample(gam, 1000)
gam <- gam[playing_time != 0 &
           min_age > 0 &
           min_age <= 18 &
           playing_time <= 1200,]

colPal <- colorRampPalette(c("grey20", "salmon"))(length(unique(gam$playing_time)))
gam[, col:=colPal[as.factor(gam$playing_time)]]

boxesFun <- function(ma, ar, pt, col){
    x <- ma
    y <- ar
    s <- pt
    fc <- sqrt(s) * 0.01
    if(fc == 0) return(NA)
    x <- c(x - fc, x + fc, x + fc, x - fc)
    y <- c(y + fc, y + fc, y - fc, y - fc)
    grobs <- list(
        grid.polygon(x,
                     y,
                     gp = gpar(fill = col),
                     draw = F,
                     default.units = 'native')
    )
    return(grobs)
}

grobs <- mapply(boxesFun,
                gam$min_age,
                gam$average_rating,
                gam$playing_time,
                gam$col)

grobs[[length(grobs) + 1]] <- grid.xaxis(draw = F)
grobs[[length(grobs) + 1]] <- grid.yaxis(draw = F)

grid.newpage()
pushViewport(plotViewport(c(6, 6, 2, 2)))
pushViewport(dataViewport(xData = c(min(gam$min_age), max(gam$min_age)),
                          yData = c(min(gam$average_rating), max(gam$average_rating))))
invisible(lapply(grobs, grid.draw))
