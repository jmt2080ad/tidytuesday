library(data.table)
library(grid)

csv <- lapply(list.files("./inst", full.names = T, pattern = "\\.csv"), fread)
cat <- readRDS("./inst/category_names.rds")

dat <- csv[[3]][year == "2016"]
dat <- na.omit(dat)

colPal <- colorRampPalette(c("brown", "salmon", "grey10", "lavender"))(length(unique(dat$major_category)))
dat[, col:=colPal[as.factor(dat$major_category)]]

plotDat <- dat[, .(mal = total_earnings_male / 10000,
                   fem = total_earnings_female / 10000,
                   tot = total_earnings / 10000,
                   col = col)]

LinesFun <- function(mal, fem, tot, col){
    grobs <- list(
        grid.lines(c(mal, fem),
                   c(tot, tot),
                   gp = gpar(col = col),
                   draw = F,
                   default.units = 'native')
    )
    return(grobs)
}

grobs <- mapply(LinesFun,
                plotDat$mal,
                plotDat$fem,
                plotDat$tot,
                plotDat$col)

grobs[[length(grobs) + 1]] <- grid.xaxis(draw = F)
grobs[[length(grobs) + 1]] <- grid.yaxis(draw = F)

grid.newpage()
pushViewport(plotViewport(c(6, 6, 2, 2)))
pushViewport(dataViewport(xData = c(0, max(c(plotDat$fem, plotDat$mal))),
                          yData = c(0, max(plotDat$tot))))
invisible(lapply(grobs, grid.draw))

