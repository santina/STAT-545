library(plyr)
library(dplyr)
library(ggplot2)

gdURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gdURL) 

j_coefs <- ddply(data, ~country + continent, 
                 function(x, offset = 1952){
                   the_fit  <- lm(lifeExp ~ I(year-offset), x)
                   setNames(coef(the_fit), c("intercept", "slope"))
                 })

str(j_coefs)

#try different things to check an object

class(j_coefs$country)
mode(j_coefs$country)
typeof(j_coefs$country)
levels(j_coefs$country)
nlevels(j_coefs$country)
nrow(data)

#make a plot
ggplot(j_coefs, aes(x=slope, y=country)) + geom_point(size=3)


#reorder the plot (reorder your data lebel)
ggplot(j_coefs, aes(x=slope, y=reorder(country, slope))) + geom_point(size=3)

#egypt, haiti, romania, thailand, venezuela 
countries  <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
selected  <- data %>%
  filter(country %in% countries)
str(selected)
#selectedCountries  <- ggplot(j_coefs, aes(x=slope, y=reorder(country %in% countries, slope))) + geom_point(size=3)
#why doesn't this work? 

nlevels(selected$country) #still return 142 
#other factors don't disappear 

selected_dropped  <- droplevels(selected)
nlevels(selected_dropped$country) #5 
nlevels(selected_dropped$continent) #4 


# let's talk about reorder 
#get new data frame with the max lifeExp for each country in selected-dropped

ddply(selected_dropped, ~country, function(x){
  max_le = max(x$lifeExp)})


#or do 
le_max  <- selected_dropped %>%
  group_by(country) %>%
  summarize(max_le = max(lifeExp))
le_max


#draw the graphs 
ggplot (le_max, aes(x=country, y=max_le, group=1)) +
  geom_path() + geom_point(size=3)
#group =1  draws lines connecting the dots 

ggplot(selected_dropped, aes(x=year, y=lifeExp,group=country))+
  geom_line(aes(color=country))

#with or without groups give the same grap


# reorder (your_Factor, your_quant_var, your_summarization_function)

ggplot(selected_dropped, aes(x =year, y= lifeExp, group = country))+ 
  geom_line(aes(color=country))+
  guides(color=guide_legend(reverse= TRUE))


# e^2 : residue. smallest residue - > best fit 