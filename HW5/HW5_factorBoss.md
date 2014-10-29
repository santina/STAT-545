# HW5: Be the boss of my factors
Santina  
Thursday, October 16, 2014  

# Introduction 
In this assignment, we are going to see how to be in [control of factors](http://stat545-ubc.github.io/block014_factors.html) in a data set, using the provided [Gapminder excerpt](http://www.stat.ubc.ca/~jenny/notOcto/STAT545A/examples/gapminder/data/gapminderDataFiveYear.txt) as an example, and experiment with [reading and writing files](https://github.com/STAT545-UBC/STAT545-UBC.github.io/blob/master/cm011_files-out-in-script.r). 

It will follow roughly (with perhaps some experimentations on the side) the assignment guideline. This is the last assignment of STAT545! I can't wait for the second half of the course, which will be even more exciting! 

As always, let's get the gapminder data. Since it's from an URL, I am going to try to download it by reading it into R and saving it as a text file in my current directory. 

## Notes to myself 
Just some notes to remind me what I can use 
- writing to and reading from files
  * use `write.table()` and `read.delim()` or `read.table()`, make sure to experiment with different arguments 
- writing and reading R objects
  * RDS format: `saveRDS()`, `readRDS()`
  * plain text format (often preferable):`dput()` and `dget()` 

## same old stuff: packages and the gapminder data
load some packages 

```r
library(ggplot2)    # for making plots
library(ggthemes)   # for customizaing ggplot graphs 
library(scales)     # for graphs scale
library(plyr)       # for easy computation with data frames
library(dplyr)      # do this after loading plyr
library(knitr)      # for rendering pretty tables
library(robustbase) # for linear robust regression 
library(pander)
```

Loading our gapminder data 

```r
gpURL <- "http://www.stat.ubc.ca/~jenny/notOcto/STAT545A/examples/gapminder/data/gapminderDataFiveYear.txt"
dataExcerpt <- read.delim(file = gpURL) 
str(dataExcerpt)
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

```r
#saving it as "gapminder_excerpt.txt" in my current homework directory
write.table(dataExcerpt, "gapminder_excerpt.txt") 
```



# Drop Oceania 
Since there are only two countries in this "continent" category, I will remove it and use `droplevels()` to ensure the level is completely clean of Oceania.


```r
# take everything except those whose continent is Oceania 
dataExcerpt2 <- dataExcerpt %>%
  filter(continent != "Oceania") %>%
  droplevels
# check if Oceania is dropped 
dataExcerpt2$continent %>%
  table()
```

```
## dataExcerpt2$continent
##   Africa Americas     Asia   Europe 
##      624      300      396      360
```

```r
# versus 
dataExcerpt$continent %>%
  table()
```

```
## dataExcerpt$continent
##   Africa Americas     Asia   Europe  Oceania 
##      624      300      396      360       24
```

Yes, so Oceania is no longer included in our data set `dataExcerpt2`. The number of rows in dataExcerpt is 1704 versus in the Oceania-dropped dataExcerpt is 1680. 


# life expectancy 

Let's look at the slopes of the life expectancy over years for each country. Using `~country + continent` we basically do this for every single country while retaining their continent identity (let me know if I can describe this better). 


```r
j_coefs <- ddply(dataExcerpt2, ~ country+continent, function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}) #this chunk was copied from the homework outline  

head(j_coefs) %>% kable()
```



|country     |continent | intercept|  slope|
|:-----------|:---------|---------:|------:|
|Afghanistan |Asia      |     29.91| 0.2753|
|Albania     |Europe    |     59.23| 0.3347|
|Algeria     |Africa    |     43.38| 0.5693|
|Angola      |Africa    |     32.13| 0.2093|
|Argentina   |Americas  |     62.69| 0.2317|
|Austria     |Europe    |     66.45| 0.2420|

Upon closer examination (with inline R code which you can't see unless you go to view raw), there are 4 columns, 140 rows. There are 140 unique countries and 4 unique continents.  

# Order of data vs order of factor levels 

Let's examine the differences among `post_arrange`, `post_reorder`, and `post_both`. 

```r
# code chunk below was copied/pasted from the assignment outline 
post_arrange <- j_coefs %>% arrange(slope)
post_reorder <- j_coefs %>%
  mutate(country = reorder(country, slope))
post_both <- j_coefs %>%
  mutate(country = reorder(country, slope)) %>%
  arrange(country)
```

## Use table to check
I am gonna first look at how each one is ordered. First, the original and followed by the three different tables.


```r
#see how j_coefs look 
j_coefs %>% head() %>% kable(format = "pandoc", caption = "The original: j_coefs")
```



Table: The original: j_coefs

country       continent    intercept    slope
------------  ----------  ----------  -------
Afghanistan   Asia             29.91   0.2753
Albania       Europe           59.23   0.3347
Algeria       Africa           43.38   0.5693
Angola        Africa           32.13   0.2093
Argentina     Americas         62.69   0.2317
Austria       Europe           66.45   0.2420

```r
#make a pretty table for post_arrange 
post_arrange %>% head() %>% kable(format = "pandoc", caption = "post_arrange")
```



Table: post_arrange

country            continent    intercept     slope
-----------------  ----------  ----------  --------
Zimbabwe           Africa           55.22   -0.0930
Zambia             Africa           47.66   -0.0604
Rwanda             Africa           42.74   -0.0458
Botswana           Africa           52.93    0.0607
Congo, Dem. Rep.   Africa           41.96    0.0939
Swaziland          Africa           46.39    0.0951

```r
#for other two as well: 
post_reorder %>% head() %>% kable(format = "pandoc", caption = "post_reorder")
```



Table: post_reorder

country       continent    intercept    slope
------------  ----------  ----------  -------
Afghanistan   Asia             29.91   0.2753
Albania       Europe           59.23   0.3347
Algeria       Africa           43.38   0.5693
Angola        Africa           32.13   0.2093
Argentina     Americas         62.69   0.2317
Austria       Europe           66.45   0.2420

```r
post_both %>% head() %>% kable(format = "pandoc", caption = "post_both")
```



Table: post_both

country            continent    intercept     slope
-----------------  ----------  ----------  --------
Zimbabwe           Africa           55.22   -0.0930
Zambia             Africa           47.66   -0.0604
Rwanda             Africa           42.74   -0.0458
Botswana           Africa           52.93    0.0607
Congo, Dem. Rep.   Africa           41.96    0.0939
Swaziland          Africa           46.39    0.0951

It looks like `post_arrange` and `post_both` are the same. Moreover, `post_reorder` looks the same to `j_coefs`, which is already ordered by country. Let's examine the end of the data just in case. 

```r
post_arrange %>% tail() %>% 
  kable(format = "pandoc", caption = "post_arrange: tail")
```



Table: post_arrange: tail

      country        continent    intercept    slope
----  -------------  ----------  ----------  -------
135   Yemen, Rep.    Asia             30.13   0.6055
136   Libya          Africa           42.10   0.6255
137   Indonesia      Asia             36.88   0.6346
138   Saudi Arabia   Asia             40.81   0.6496
139   Vietnam        Asia             39.01   0.6716
140   Oman           Asia             37.21   0.7722

```r
post_both %>% tail() %>% 
  kable(format = "pandoc", caption = "post_both: tail")
```



Table: post_both: tail

      country        continent    intercept    slope
----  -------------  ----------  ----------  -------
135   Yemen, Rep.    Asia             30.13   0.6055
136   Libya          Africa           42.10   0.6255
137   Indonesia      Asia             36.88   0.6346
138   Saudi Arabia   Asia             40.81   0.6496
139   Vietnam        Asia             39.01   0.6716
140   Oman           Asia             37.21   0.7722

##Use graphs to check
They look the same, however, double checking more 


```r
ggplot(post_arrange, aes(x=slope, y=country)) + geom_point(size=3) +
  ggtitle("post_arrange graph")
```

![plot of chunk unnamed-chunk-8](./HW5_factorBoss_files/figure-html/unnamed-chunk-81.png) 

```r
ggplot(post_reorder, aes(x=slope, y=country)) + geom_point(size=3) +
  ggtitle("post_reorder graph")
```

![plot of chunk unnamed-chunk-8](./HW5_factorBoss_files/figure-html/unnamed-chunk-82.png) 

```r
ggplot(post_both, aes(x=slope, y=country)) + geom_point(size=3) +
  ggtitle("post_both graph")
```

![plot of chunk unnamed-chunk-8](./HW5_factorBoss_files/figure-html/unnamed-chunk-83.png) 

Now I finally understand!  For `post_arrange`, the table is simply organized by the values of slope. However, `post_reorder` has the part `country = reorder(country, slope)` which __order the country factor based on the slope__. The categorical variable, country, has its levels reordered based on the values of a second variable, slope. In the case of `post_both` the same factor arrangement is made, and the table is arrange by slope. That's why the tables for `post_both` and `post_arrange` look the same, though the produce different plots because one has its country factor organized to the slope, the other one doesn't. 

##the challenging questions
___If I swap out `arrange(country)` for `arrange(slope)` in `post_both`, what would I get?___ This is basically asking what the result would be if we add `arrange(slope)` to the code for `post_reorder`. I think you won't change the results of the plot nor the table because the levels of country factor are already reorderd based on the slopes. Since the countries are arranged by slopes, they will again be arranged by slopes as well.  


```r
post_both2 <- j_coefs %>%
  mutate(country = reorder(country, slope)) %>%
  arrange(slope)
post_both2 %>% head() %>% 
  kable(format = "pandoc", caption = "post_both2: head")
```



Table: post_both2: head

country            continent    intercept     slope
-----------------  ----------  ----------  --------
Zimbabwe           Africa           55.22   -0.0930
Zambia             Africa           47.66   -0.0604
Rwanda             Africa           42.74   -0.0458
Botswana           Africa           52.93    0.0607
Congo, Dem. Rep.   Africa           41.96    0.0939
Swaziland          Africa           46.39    0.0951
And indeed that's what we see.  

With this in mind, we can see that it'd make more sense to do `arrange()` first if we want to see real effects in the table, and then do `rearrange()` if we want to do certain modeling that requires certain factor levels to be ordered based on numeric variables. 

# Revalue a factor 
Hmmm...so let's add a new factor called "personality" to our data set. I will assign this to a subset of countries. 

```r
# get some of the countries
countries  <- c("Germany", "Canada", "Japan")
adjectives <- c("meticulous", "nice", "hard-working")
dataExcerpt3  <- dataExcerpt2 %>%
  filter(country %in% countries) %>%
  droplevels 
dataExcerpt3$country <- mapvalues(dataExcerpt3$country, countries, adjectives)
```

Now let's check if we have change the country factor levels

```r
#remember dataExcerpt2 is the one with Oceania dropped 
str(dataExcerpt3)
```

```
## 'data.frame':	36 obs. of  6 variables:
##  $ country  : Factor w/ 3 levels "nice","meticulous",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  14785584 17010154 18985849 20819767 22284500 ...
##  $ continent: Factor w/ 3 levels "Americas","Asia",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ lifeExp  : num  68.8 70 71.3 72.1 72.9 ...
##  $ gdpPercap: num  11367 12490 13462 16077 18971 ...
```

```r
levels(dataExcerpt3$country)
```

```
## [1] "nice"         "meticulous"   "hard-working"
```
Awesome! 

# Reorder a factor 
Now I'm gonna reorder `dataExcerpt3` by its factor "continent" by population. 


```r
pop_ordered <- dataExcerpt2 %>%
  mutate(continent = reorder(continent, pop))
levels(pop_ordered$continent)
```

```
## [1] "Africa"   "Europe"   "Americas" "Asia"
```
Now it would be interesting to see which one has the greatest growth in population over the years, based on linear model. 


```r
#function for finding population growth's linear robust fit 
pop_linearRob_coefs <- function(pop_ordered, offset = 1952) {
  line_fit_rob <- lmrob(pop ~ I(year - offset), pop_ordered)
  setNames(coef(line_fit_rob), c("intercept", "slope"))
}
# apply to the data set ordered by continent based on population 
pop_continent  <- ddply(pop_ordered, ~continent, pop_linearRob_coefs)
pop_continent
```

```
##   continent intercept  slope
## 1    Africa   2859730  66156
## 2    Europe   6216866  18267
## 3  Americas   3828268  62207
## 4      Asia   9191603 146242
```

We see that Asia probably has the greatest growth rate per year based on the slope, whereas Europe has the smallest growth rate. 

Now we graph it to see what's up. 


```r
ggplot(pop_ordered, aes(x = year, y = pop, colour = continent)) +
  facet_wrap( ~ continent, ncol = 2) +
  xlab("Year") +
  ylab("Population")+
  ggtitle("Population over time")+
  geom_point(alpha = 0.7)+
  theme_calc()+
  theme(legend.position = "none") 
```

![plot of chunk unnamed-chunk-14](./HW5_factorBoss_files/figure-html/unnamed-chunk-14.png) 
For some reason, even with `theme(legend.position = "none")` I couldn't remove the legend until I put it in the last line. It was right after the facet_wrap and the legend still exist. Something to note down.... 

Now we can see that Asian continent's population growth has been largely contributed by two countries. What are they? 

We can use the same method as before, except applying it only on Asia. 

```r
asia_pop  <- pop_ordered %>% filter(continent == "Asia") %>% droplevels

Asianpop_linearRob_coefs <- function(asia_pop, offset = 1952) {
  line_fit_rob <- lmrob(pop ~ I(year - offset), asia_pop)
  setNames(coef(line_fit_rob), c("intercept", "slope"))
}
# apply to the data set ordered by continent based on population 
AsianPopulation  <- ddply(asia_pop, ~country, Asianpop_linearRob_coefs)
```

```
## Warning: M-step did NOT converge. Returning unconverged SM-estimate
## Warning: M-step did NOT converge. Returning unconverged SM-estimate
```

```r
AsianPopulation %>%
  arrange(desc(slope)) %>%
  head %>%
  kable(format = "pandoc", 
        caption = "Top 5 countries with the greatest population growth")
```



Table: Top 5 countries with the greatest population growth

country        intercept      slope
------------  ----------  ---------
China          555867011   14777049
India          286656432   14731793
Indonesia       72643785    2744751
Pakistan        28617420    2357742
Bangladesh      35390045    1976238
Philippines     17656104    1266666

Aha, we found them. They were China and India 

# Write and read data to file 

In the beginning of the assignment I wrote `dataExcerpt` into `gapminder_excerpt.txt`. Now let's try to see how well we can read from the text file we  created. 

```r
gapExcerpt <-  read.delim(file = "gapminder_excerpt.txt")

str(gapExcerpt)
```

```
## 'data.frame':	1704 obs. of  1 variable:
##  $ country.year.pop.continent.lifeExp.gdpPercap: Factor w/ 1704 levels "1 Afghanistan 1952 8425333 Asia 28.801 779.4453145",..: 1 817 928 1039 1150 1261 1372 1483 1594 2 ...
```

```r
# file read from the file we wrote to 

str(dataExcerpt)
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

```r
#our original data read from URL
```
Hum.... `str(gapExcerpt)` is a little massier than the result of `str(dataExcerpt)`. 


```r
identical(dataExcerpt, gapExcerpt)
```

```
## [1] FALSE
```
So the data is not exactly the same after we save it and read it again. To see how they are organized: 


```r
dataExcerpt %>%
  head %>%
  kable(format = "pandoc", 
        caption = "Data read from URL")
```



Table: Data read from URL

country        year        pop  continent    lifeExp   gdpPercap
------------  -----  ---------  ----------  --------  ----------
Afghanistan    1952    8425333  Asia           28.80       779.4
Afghanistan    1957    9240934  Asia           30.33       820.9
Afghanistan    1962   10267083  Asia           32.00       853.1
Afghanistan    1967   11537966  Asia           34.02       836.2
Afghanistan    1972   13079460  Asia           36.09       740.0
Afghanistan    1977   14880372  Asia           38.44       786.1

```r
gapExcerpt %>%
  head %>%
  kable(format = "pandoc", 
        caption = "Data read from file gapminder_excerpt.txt ")
```



Table: Data read from file gapminder_excerpt.txt 

country.year.pop.continent.lifeExp.gdpPercap        
----------------------------------------------------
1 Afghanistan 1952 8425333 Asia 28.801 779.4453145  
2 Afghanistan 1957 9240934 Asia 30.332 820.8530296  
3 Afghanistan 1962 10267083 Asia 31.997 853.10071   
4 Afghanistan 1967 11537966 Asia 34.02 836.1971382  
5 Afghanistan 1972 13079460 Asia 36.088 739.9811058 
6 Afghanistan 1977 14880372 Asia 38.438 786.11336   

As we can see `gapExcerpt` is not properly delimited. I assume that somewhere in reading the file, the factors were not preserved properly. So one approach would be to add some arguments. 

```r
gapExcerpt_delim <- read.delim(file = "gapminder_excerpt.txt", 
                               header = TRUE, sep = " ") 

gapExcerpt_delim %>%
  head %>%
  kable(format = "pandoc", 
        caption = "Data read from file gapminder_excerpt.txt ")
```



Table: Data read from file gapminder_excerpt.txt 

country        year        pop  continent    lifeExp   gdpPercap
------------  -----  ---------  ----------  --------  ----------
Afghanistan    1952    8425333  Asia           28.80       779.4
Afghanistan    1957    9240934  Asia           30.33       820.9
Afghanistan    1962   10267083  Asia           32.00       853.1
Afghanistan    1967   11537966  Asia           34.02       836.2
Afghanistan    1972   13079460  Asia           36.09       740.0
Afghanistan    1977   14880372  Asia           38.44       786.1

Looks much better! 

# thoughts and progress
I spent a lot of time thinking about `rearrange()` and `arrange()` functions. Those names make me intuitively think that they would do something to the data, which will reflect on how the tables are shown. But no, so that was a bit confusing at first. 

This assignment was a lot less open ended, which allowed me to work on it non-stop (and it felt great!). I had to make several references to my older assignments to remember how to use ggplot2, so it was good that I documented those things well. The workflow/outline of the assignment guideline lead me to learn many new things and use the things we covered in class in practice, such as setting arguments in read.table, droplevels, ordering factors, and mapvalues, etc. 

I also get to experiment with many things, such adding more argument to kable. Overall, I enjoyed the intense mental concentration I experienced during the working of this assignment. 
