library(data.table)

data <- fread("./student_teacher_ratio.csv")
asia <- fread("./africa.csv")[,cont:="Africa"]
euro <- fread("./europe.csv")[,cont:="Euro"]

cont <- rbind(asia, euro)
data <- merge(data, cont, by.x = "country_code", by.y = "c3")

data[,student_ratio_cont:=mean(student_ratio),
     by = list(cont, year, indicator)]
