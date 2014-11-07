# HW8: Cleaning data
Santina  
Thursday, November 6 2014  

In this assignment, we are going to attemp to clean up the gapminder data that has been purposely messed up for the purpose of this assignment. We would use some techniques that have to do with manipulating data/table and regular expressions. 

First get some useful packages loaded first 


```r
library(stringr) # for regular expression
library(plyr)       # for easy computation with data frames
library(dplyr)      # do this after loading plyr
library(knitr)      # for rendering pretty tables
library(grid)
library(gridExtra)  # arranging graph
```

# load the dirty gapminder data 

```r
# read our dirty gapminder file 
dirty_file <- read.delim("gapminderDataFiveYear_dirty.txt")
kable(head(dirty_file))
```



| year|      pop| lifeExp| gdpPercap|region           |
|----:|--------:|-------:|---------:|:----------------|
| 1952|  8425333|   28.80|     779.4|Asia_Afghanistan |
| 1957|  9240934|   30.33|     820.9|Asia_Afghanistan |
| 1962| 10267083|   32.00|     853.1|Asia_Afghanistan |
| 1967| 11537966|   34.02|     836.2|Asia_Afghanistan |
| 1972| 13079460|   36.09|     740.0|Asia_Afghanistan |
| 1977| 14880372|   38.44|     786.1|Asia_Afghanistan |

```r
str(dirty_file)
```

'data.frame':	1704 obs. of  5 variables:
 $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
 $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
 $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
 $ gdpPercap: num  779 821 853 836 740 ...
 $ region   : Factor w/ 151 levels "    Asia_Jordan",..: 86 86 86 86 86 86 86 86 86 86 ...

We can see that there are 151 different regions, each is the country name and continent combined together. 

## strip.white argument 

Let's examine what strip.white argument does to a data.frame in reading a file. 


```r
dirty_file2 <- read.delim("gapminderDataFiveYear_dirty.txt", strip.white = TRUE)
kable(head(dirty_file2))
```



| year|      pop| lifeExp| gdpPercap|region           |
|----:|--------:|-------:|---------:|:----------------|
| 1952|  8425333|   28.80|     779.4|Asia_Afghanistan |
| 1957|  9240934|   30.33|     820.9|Asia_Afghanistan |
| 1962| 10267083|   32.00|     853.1|Asia_Afghanistan |
| 1967| 11537966|   34.02|     836.2|Asia_Afghanistan |
| 1972| 13079460|   36.09|     740.0|Asia_Afghanistan |
| 1977| 14880372|   38.44|     786.1|Asia_Afghanistan |

```r
str(dirty_file2)
```

'data.frame':	1704 obs. of  5 variables:
 $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
 $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
 $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
 $ gdpPercap: num  779 821 853 836 740 ...
 $ region   : Factor w/ 148 levels "_Canada","Africa_Algeria",..: 83 83 83 83 83 83 83 83 83 83 ...

I don't see much difference, exacept that the number of region factor levels has changed. With `strip.white = FALSE` by default , it's 151, and now it's 148. Let's examine it closer: 


