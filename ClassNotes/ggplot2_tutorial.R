#ggplot 2 tutorial 
#'star with scatterplot

#'load the package 
library(ggplot2) 

gdURL <- "http://tiny.cc/gapminder"
gDat <- read.delim(file = gdURL) 
#gDat <- read.delim("gapminderDataFiveYear.tsv")
str(gDat)
ggplot(gDat, aes(x = gdpPercap, y = lifeExp))
p <- ggplot(gDat, aes(x = gdpPercap, y = lifeExp))
p + geom_point()
p + geom_point() + scale_x_log10()
p <- p + scale_x_log10() #' set it to log base 10 
p + geom_point(aes(color = continent))

#' so many points, to address overplotting, set transparency 
p + geom_point(alpha = (1/3), size = 3)
#' keep adding things to p, like adding layers 

#' get a smooth fitted line 
p + geom_point() + geom_smooth()

#' or specify how the line looks 
p + geom_point() + geom_smooth(lwd = 3, se = FALSE)

#' or make it straight line fit 
p + geom_point() + geom_smooth(lwd = 3, se = FALSE, method = "lm")




