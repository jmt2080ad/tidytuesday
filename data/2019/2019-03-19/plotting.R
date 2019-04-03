library(data.table)
library(extrafont)

install.packages("extrafont")
font_import(pattern = "[C/c]omic")

x <- fread("./data/combined_data.csv")

plot(x$arrest_rate,
     col = rainbow(length(unique(as.factor(x$state))))[as.factor(x$state)])
