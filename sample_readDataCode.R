getwd()
list.files()
data  <- read.delim("gapminderDataFiveYear.txt")
str(data)
ncol(data)
nrow(data)
summary(data)
plot(lifeExp ~ year, data) #lifeExp as y and year as x-axis