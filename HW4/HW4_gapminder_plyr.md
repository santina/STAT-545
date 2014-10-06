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
suppressPackageStartupMessages(library(dplyr))
library(plyr)    # for easy computation with data frames
```

```
## -------------------------------------------------------------------------
## You have loaded plyr after dplyr - this is likely to cause problems.
## If you need functions from both plyr and dplyr, please load plyr first, then dplyr:
## library(plyr); library(dplyr)
## -------------------------------------------------------------------------
## 
## Attaching package: 'plyr'
## 
## The following objects are masked from 'package:dplyr':
## 
##     arrange, desc, failwith, id, mutate, summarise, summarize
```

```r
library(dplyr) 
library(knitr)   # for rendering pretty tables
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

With the variables in the gapminder data in mind, I'd like to find out **Which of the top 10 countries with the highest lifeExp in 2007 experience the greatest growth in GDP per capital in the last 20 years?** 

First we need to find out what are those 10 countries 

```r
topTen  <- 
  data %>%
  select(country, lifeExp, year) %>%
  arrange(desc(lifeExp)) %>%
  filter(year==2007) %>%
  filter(min_rank(desc(lifeExp)) < 12)
kable(topTen)
```

```
## 
## 
## |country          | lifeExp| year|
## |:----------------|-------:|----:|
## |Japan            |   82.60| 2007|
## |Hong Kong, China |   82.21| 2007|
## |Iceland          |   81.76| 2007|
## |Switzerland      |   81.70| 2007|
## |Australia        |   81.23| 2007|
## |Spain            |   80.94| 2007|
## |Sweden           |   80.88| 2007|
## |Israel           |   80.75| 2007|
## |France           |   80.66| 2007|
## |Canada           |   80.65| 2007|
## |Italy            |   80.55| 2007|
```
Originally I  had `select(country, lifeExp, year==2007)` and `filter(min_rank(lifeExp) < 11)`. These codes won't work because we cannot specify the value inside `select` and the filter function needs to have `desc(lifeExp)` in order to pick out the highest life expetancies instead of the lowest ones. Moreover, without `arrange(desc(lifeExp))` the output would be the right answer but in random order. Lastly, filter cannot take in more than one argument (can't filter two different things at once).... learned so many things (including how to do sanity check) with just one task haha. 



  data %>%
  select(country, lifeExp, year==2007) %>%
  filter(min_rank(desc(lifeExp)) < 11)
You can also embed plots, for example:



#Data trend and the real stories 

##Kuwait: its boom and decline 

##Ghana: Civial war 


#Plyr versus dplyr 


