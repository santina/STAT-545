#Intro

The following consists of some interesting observations obtained from 
[Gapminder](http://www.gapminder.org/) with their data on [statistical records 
on various countries] (http://www.stat.ubc.ca/~jenny/notOcto/STAT545A/examples/gapminder/data/gapminderDataFiveYear.txt)

Information on these five countries include categories such as GDP per capital, life expectancy, etc. 

This little write-up will explore some of the built-in R functions and how they can reveal some interesting information in this dataset. 


#Getting and taking peek at the data
First, put the text file you just downloaded into your desired working directory. To see your current directory, type `getwd()` in your console, and set it by using `setwd(YourDirectoryPath)`. 

Load the data into the R studio console by typing `data  <- read.delim("gapminderDataFiveYear.txt")`

There are several ways to take a look at how your data frame looks like. What's data frame? That's just the "type" of your data object. 
- `str(data)` tells you number of observations, preview of each column, type of objects each column contains, etc
- `summary(data)` useful if you want to know the min, max, average, and all that for each column. (so fairly useful)
- `head(data)` by default it returns the first six rows of the data, you can change it by specifying `head(data,10)` for example
- `tail(data)` same thing with the head, except it shows the last 6 rows of the data frame. 
- (this is not an exclusive list)

What data frame? Oh, go type in `class(data)`, it will tell you that the type of your "data" is a data.frame. 

Okay enough talk let's do some analysis. 

#Basic graph: Number of countries 
From using `summary(data)` you can see that each entry has "continent" field on it. 
![summary(data)](https://github.com/STAT545-UBC/zz_sheng-ting_lin-coursework/blob/master/images_gapminder/summary.JPG)

As you can see, there are 12 entries for each country, so we can divide the number of countries in each continent by 12 to the actual number of countries there are (at least in this study) in each continent. 

> continents  <- c(624, 300, 396, 360, 24)
> continents  <-  continents/12
> continents  
[1] 52 25 33 30  2

#Life expectancy 

##which countries? lowest and highest life expectancy 

##Life expectancy and GDP per capital


#How do I know all these stuff 
- I listen in class (when the prof talks about thins I don't already know)
- I learned through swirl, seriously that's the fastest way to learn so just 
