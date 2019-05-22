library(data.table)

fnams <- list.files("./data", full.names = TRUE) 

files <- lapply(fnams, fread)

setnames(files[[4]], "is_prize_winning_paper", "prizePaper")

fwrite(files[[4]][!is.na(pub_year) & !is.na(prize_year) & prizePaper == "YES",], "./data/prizePapers.csv")
