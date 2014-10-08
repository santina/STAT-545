## get into the right directory, clean workspace 

## load packages: porbably ggplot2 and dplyr 
library(ggplot2)
library(dplyr)

#load gapminder 
gdURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gdURL) 

#pick some countries 
countries  <- c("Croatia", "Canada", "Iran", "Haiti", "Brazil")
data_sub  <- data %>%
  filter(country %in% countries) %>%
  droplevels

# dorplevels(subset(data, country %in% countries))
data_sub %>%
  dim

table(data_sub$country)

# use write.table() to write this to file, inverse of read.table?
write.table(data_sub, "data_sub.txt")

#' try using some arguments in write.table()
#' by default it's a space for delim 

write.table(data_sub, "data_sub.csv", sep=",", row.names = FALSE, quote = FALSE)



