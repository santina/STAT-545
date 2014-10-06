# HW4: plyr, deplyr, gapminder
Santina  
Monday, October 5, 2014  

#Exploration with plyr 

##Brief info 
This homework will reply on the stuff I learned about (links to tutorials) 
- [R functions](http://stat545-ubc.github.io/block011_write-your-own-function-01.html)
- [dply](http://stat545-ubc.github.io/block010_dplyr-end-single-table.html) and [plyr](http://stat545-ubc.github.io/block013_plyr-ddply.html), the ways to  
- [linear regression](http://stat545-ubc.github.io/block012_function-regress-lifeexp-on-year.html) 
- [ggplot2] (https://github.com/jennybc/ggplot2-tutorial), of course. 

Also, I have taken a lot of [notes on R](https://github.com/santina/programmerNotes) for not just those tutorials, but also all the topics covered so far as well as those in swirl. 

The objectives will be based on the [outline](http://stat545-ubc.github.io/hw04_write-function-use-plyr.html) on the stats545 website.

**The mission is to further explore the gapminder data with the new techniques (plyr, R functions)** 

##Load the libraries and data 

First load the needed libraries

```r
library(ggplot2) # for making plots
library(ggthemes)# for customizaing ggplot graphs 
library(scales)  # for graphs scale
library(plyr)    # for easy computation with data frames
library(dplyr) 
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:plyr':
## 
##     arrange, desc, failwith, id, mutate, summarise, summarize
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
suppressPackageStartupMessages(library(dplyr))
library(knitr)   # for rendering pretty tables
library(tidyr)
```

And then the data :  "data"

```r
#load gapminder data 
gdURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gdURL) 
str(data)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
```

#Asking hard questions 

Here I will attempt to challenge myself with some hard questions and use plyr, dplyr and some basic R techniques to solve the questions. Like many people, I like to ask about what's the most/least and what's the trend of something over time.  

With the variables in the gapminder data in mind, I'd like to find out **Which of the top 10 countries with the highest lifeExp in 2007 experience the greatest growth in GDP per capital?** 

First we need to find out what are those 10 countries 

```r
topTen  <- 
  data %>%
  select(country, lifeExp, year) %>%
  arrange(desc(lifeExp)) %>%
  filter(year==2007) %>%
  filter(min_rank(desc(lifeExp)) < 11)

kable(topTen)
```



|country          | lifeExp| year|
|:----------------|-------:|----:|
|Japan            |   82.60| 2007|
|Hong Kong, China |   82.21| 2007|
|Iceland          |   81.76| 2007|
|Switzerland      |   81.70| 2007|
|Australia        |   81.23| 2007|
|Spain            |   80.94| 2007|
|Sweden           |   80.88| 2007|
|Israel           |   80.75| 2007|
|France           |   80.66| 2007|
|Canada           |   80.65| 2007|
Originally I  had `select(country, lifeExp, year==2007)` and `filter(min_rank(lifeExp) < 11)`. These codes won't work because we cannot specify the value inside `select` and the filter function needs to have `desc(lifeExp)` in order to pick out the highest life expetancies instead of the lowest ones. Moreover, without `arrange(desc(lifeExp))` the output would be the right answer but in random order. learned so many things (including how to do sanity check) with just one task haha. 

Can filter take more than one crition of filtering? 

Now we have those ten countries, we want to find which one has the sharpest increase in GDP per capita. We can try doing this by graph and see which trend has the steepest slope. 


```r
#filter data, with the countries in the top contry list 
d_sub <-  filter(data, country %in% topTen$country)
#construct the graph, color each trend by country
graphTop <- ggplot(d_sub, aes(x = year, y=gdpPercap)) + 
  geom_point() + 
  geom_line(aes(color=country)) 
#graph 
graphTop
```

![plot of chunk unnamed-chunk-4](./HW4_gapminder_plyr_files/figure-html/unnamed-chunk-4.png) 
Looks like it's hard to see which country has its gdpPercap increase at the greatest speed. We will try using linear regression to obtain exact slope for each trend. 

First we need a function that will return coefficients (slope and intercept)


```r
gdp_linear_coefs <- function(data, offset = 1952) {
  line_fit <- lm(gdpPercap ~ I(year - offset), data)
  setNames(coef(line_fit), c("intercept", "slope"))
}
```

Then use `dplyr` to obtain coefficients of all fits for all the top ten countries. 

```r
gdp_coefs <- ddply(d_sub, ~country, gdp_linear_coefs) 
gdp_coefs %>%
  arrange(desc(slope)) %>%
  kable()
```



|country          | intercept| slope|
|:----------------|---------:|-----:|
|Hong Kong, China |     -1843| 657.2|
|Japan            |      2414| 557.7|
|Iceland          |      6389| 514.3|
|Canada           |      9996| 451.5|
|Spain            |      1921| 440.3|
|France           |      6797| 437.7|
|Australia        |      8242| 426.9|
|Sweden           |      8284| 424.0|
|Israel           |      3692| 380.7|
|Switzerland      |     16752| 375.4|

I kept trying to use `~(country == topTen$country)`, `~topTen$country` or various variations, but I need to use `%in%` for such selection to work!

#Data trend and the real stories 

##Kuwait: its boom and decline 

##Ghana: Civial war 


#Plyr versus dplyr 


