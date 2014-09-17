
#Intro

The following consists of some interesting observations obtained from 
[Gapminder](http://www.gapminder.org/) with their data on [statistical records 
on various countries] (http://www.stat.ubc.ca/~jenny/notOcto/STAT545A/examples/gapminder/data/gapminderDataFiveYear.txt)

Information on these five countries include categories such as GDP per capital, life expectancy, etc. 

This little write-up will explore some of the built-in R functions and how they can reveal some interesting information in this dataset. 


#Getting and taking a peek at the data
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

`> continents  <- c(624, 300, 396, 360, 24)`
`> continents  <-  continents/12`
`> continents  `
`[1] 52 25 33 30  2`

not clear ? we can put the names of the continent on top of each number. How do we do that? workflow

1. __continents__ is right now a numeric (type `class(continents)` to check), we need to make it into a matrix 

2. make it into a matrix by giving it dimentions: `dim(continents)  <- c(1,5)` now check its class. 

3. create a vector for the colum names, `cnames  <-  c("Africa", "Americas", "Asia", "Europe", "Oceania")`

4. name the column of __continents__ the cnames we just created: `colnames(continents)  <- cnames`

5. now check `continents` . woah only 2 countries in Oceania?!  

#Life expectancy 
From the summary we can see that life expectancy has a large range... it's very shocking, and it probaly makes you curious to see which country has the highest or the lowest range, and if life expectancy has any correlations to other measurements.... 

Let's make a bar graph (histogram) to quickly look at the life expectancy in general: 
`hist(data$lifeExp)` 
![lifeExp(data)](https://github.com/STAT545-UBC/zz_sheng-ting_lin-coursework/blob/master/images_gapminder/lifeExp_histo.jpeg)
There we can already see that while life expectancy is left-skewed, there are some countries with a very low life expectancy (below 30!). Let's find out more. 

##which countries? lowest and highest life expectancy 

We know from the summary that the lowest is 23.60 and the highest is 82.60
You can quickly find out by subsetting the dataframe using the '$' sign: 

`country[country$lifeExp ==23.6]` 

oops nothing got returned (0 row), so let's try `country[country$lifeExp <=23.6]` ... 

and Rwanda is returned, the life expectancy is 23.599 (You see that the number got rounded up so the first attempt didn't work). Maybe because this country has very poor living standard and/or child mortility is high. 

To see the country with the highest life expectancy, let's try something different : 

`data[data$lifeExp == max(data$lifeExp), ]` 

Here we subsetted the dataframe to specify that we want all the row(s) with the maximum life expectancy. And unsurprisingly, Japan got it. 

##Life expectancy and GDP per capital
Now let's create a simple scatter plot to see if there's a pattern to life expectation and GDP per capital : 

`plot(lifeExp ~ gdpPercap, data)`  

![life expectancy versus GDP Per Capita](https://github.com/STAT545-UBC/zz_sheng-ting_lin-coursework/blob/master/images_gapminder/lifeExp_gdpPercap.jpeg)

The plot pulls the data from __data__ and plots life expectation against GDP per capita. From the graph, you can see that life expectancy doesn't perfectly correlate with GDP per capita. There are a good number of countries with fairly high life expectancy but low GDP per capital. However, it's clear that countries with fairly high GDP per capital (those that scatter to the right side of the plot) have fairly high life expectancy. 

Now just for fun let's plot a few more things: 

`plot(lifeExp ~ pop, data)`

![life expectancy versus population](https://github.com/STAT545-UBC/zz_sheng-ting_lin-coursework/blob/master/images_gapminder/lifeExp_pop.jpeg)

Seems like there's linear correlation of life expectancy versus population for countries with popultaion greater than certain number. 


`plot(pop ~ gdpPercap, data)`

![Population versus GDP per Capita](https://github.com/STAT545-UBC/zz_sheng-ting_lin-coursework/blob/master/images_gapminder/pop_gdpPercap.jpeg)

Very interesting graph.... 


#How do I know all these stuff 
- I listen in [STAT545](http://stat545-ubc.github.io/index.html) ! 
- I learned through [swirl](http://swirlstats.com/students.html), seriously that's the fastest way to pick up R
- Do assignments on [R-programming on Coursera](https://www.coursera.org/course/rprog), check out their data science specialization, too! 
