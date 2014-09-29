getwd()
list.files()
data  <- read.delim("gapminderDataFiveYear.txt")
str(data)
ncol(data)
nrow(data)
summary(data)plot(lifeExp ~ gdpPercap, data)
hist(data$lifeExp)
summary(data$lifeExp)
#let's talk about vector
class(data$continent)
#they're necessary, used for categorical information
levels(data$continent)
#see how many levels...the categories ("Africa", "Americas",.... )
table(data$continent)
#outputs a table of how many are in each category
barplot(table(data$continent))
#put the thing into a bar graph

plot(lifeExp ~ year, data) #lifeExp as y and year as x-axis