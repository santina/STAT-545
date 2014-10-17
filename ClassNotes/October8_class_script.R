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
#you can verify the difference the last line make using levels(data_sub$country)
# or table(data_sub$country)
# with droplevels : levels(data_sub$country) : the five countries in alphabetic order
# without: all the countries still there 


# droplevels(subset(data, country %in% countries))
# same output for both with or without droplevels 
data_sub %>%
  dim

table(data_sub$country)

# use write.table() to write this to file, inverse of read.table?
write.table(data_sub, "data_sub.txt")

#' try using some arguments in write.table()
#' by default it's a space for delim 
#' much prettier to see than txt on github 

write.table(data_sub, "data_sub.csv", sep=",", row.names = FALSE, quote = FALSE)


#inspect the levels of country : 
# order_data  <- factor(data_sub, levels = data_sub$country, ordered = TRUE)

ordered  <- data_sub %>%
  mutate(country=reorder(country, lifeExp, max))
#compare the order of country specific to the lifeExp:  
data.frame(levels(data_sub$country), levels(ordered$country))
# the actual data frame doesn't change, but when you graph something you'll see it 

#' write to file with saveRDS() 
#' it would retain dataframe, factor ordering, can save any R objects
#' not a file you can inspect, but a binary file 
saveRDS(ordered, "ordered_lifeExp.rds")

#' now remove it, and get it back from .rds file! 
#
rm(ordered) # delete from work space 
ordered     # confirm it's deleted 
ordered  <- readRDS("ordered_lifeExp.rds")
str(ordered)
levels(ordered$country) #same as before! 


#' write to file with dput () 
#' plain text representation of the object for R 
dput(ordered, "ordered_dput.txt")

# try delete and get it back 
rm(ordered)
ordered
ordered  <- dget("ordered_dput.txt")
str(ordered) # str(ordered, give.attr = FALSE)
levels(ordered$country) #same as before! 



# the only difference is really just having a viewable txt or binary 
# also if many objects to store, just put them in a list 