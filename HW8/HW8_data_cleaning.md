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


```r
head(levels(dirty_file$region))
```

```
## [1] "    Asia_Jordan"           "    Asia_Korea, Dem. Rep."
## [3] "_Canada"                   "Africa_Algeria"           
## [5] "Africa_Angola"             "Africa_Benin"
```

```r
head(levels(dirty_file2$region))
```

```
## [1] "_Canada"             "Africa_Algeria"      "Africa_Angola"      
## [4] "Africa_Benin"        "Africa_Botswana"     "Africa_Burkina Faso"
```
We can see that the first two have disappeared in `dirty_file2` ! And they have white spaces. So it looks like those are eliminated or stripped of their white space (likely the latter but why not just check). 

Let's look at the factor levels with white space: 

```r
grep("^\\s.", dirty_file$region, value = TRUE) #spaces at the beginning
```

```
## [1] "    Asia_Jordan"           "    Asia_Korea, Dem. Rep."
## [3] "    Asia_Korea, Dem. Rep."
```

We can see that there are three of them, and that accounts for the difference between the number of factors in region between the two files! 


```r
head(levels(dirty_file$region))
```

```
## [1] "    Asia_Jordan"           "    Asia_Korea, Dem. Rep."
## [3] "_Canada"                   "Africa_Algeria"           
## [5] "Africa_Angola"             "Africa_Benin"
```

```r
head(levels(dirty_file2$region))
```

```
## [1] "_Canada"             "Africa_Algeria"      "Africa_Angola"      
## [4] "Africa_Benin"        "Africa_Botswana"     "Africa_Burkina Faso"
```

And indeed, once the white space are stripped out, they become identical to the other factors, thus reducing the factor levels. This is important because sometimes people put spaces when they input some values. Stripping off the space ensure that we are not counting those inputs as unique inputs. 

Knowing this we will know work with `dirty_file2`

# Splitting and merging 
We know that the column region contains both country name and continent name. So maybe we should split that into two columns. 

```r
# first split the value of region into two conceptual names, do this for each row
continent_country  <- adply(as.character(dirty_file2$region), .margin = 1, function(data){
  unlist(strsplit(data, "_"))
})

head(continent_country)
```

```
##   X1   V1          V2
## 1  1 Asia Afghanistan
## 2  2 Asia Afghanistan
## 3  3 Asia Afghanistan
## 4  4 Asia Afghanistan
## 5  5 Asia Afghanistan
## 6  6 Asia Afghanistan
```

We have successfully separated the two pieces of information, now we need to glue it the original dataframe `dirty_file2`. 


```r
# put the country in: 
dirty_file2 <- mutate(dirty_file2, country = continent_country$V2)
# put the continent in 
dirty_file2 <- mutate(dirty_file2, continent = continent_country$V1)
dirty_file2 %>% head() %>% kable()
```



| year|      pop| lifeExp| gdpPercap|region           |country     |continent |
|----:|--------:|-------:|---------:|:----------------|:-----------|:---------|
| 1952|  8425333|   28.80|     779.4|Asia_Afghanistan |Afghanistan |Asia      |
| 1957|  9240934|   30.33|     820.9|Asia_Afghanistan |Afghanistan |Asia      |
| 1962| 10267083|   32.00|     853.1|Asia_Afghanistan |Afghanistan |Asia      |
| 1967| 11537966|   34.02|     836.2|Asia_Afghanistan |Afghanistan |Asia      |
| 1972| 13079460|   36.09|     740.0|Asia_Afghanistan |Afghanistan |Asia      |
| 1977| 14880372|   38.44|     786.1|Asia_Afghanistan |Afghanistan |Asia      |

We successfully put those two columns in! Now we drop the region column because it's no longer necessary. 


```r
keeps  <- colnames(dirty_file)
dirty_file2  <- dirty_file2[, !colnames(dirty_file2) == "region"]
head(dirty_file2) %>%
  kable()
```



| year|      pop| lifeExp| gdpPercap|country     |continent |
|----:|--------:|-------:|---------:|:-----------|:---------|
| 1952|  8425333|   28.80|     779.4|Afghanistan |Asia      |
| 1957|  9240934|   30.33|     820.9|Afghanistan |Asia      |
| 1962| 10267083|   32.00|     853.1|Afghanistan |Asia      |
| 1967| 11537966|   34.02|     836.2|Afghanistan |Asia      |
| 1972| 13079460|   36.09|     740.0|Afghanistan |Asia      |
| 1977| 14880372|   38.44|     786.1|Afghanistan |Asia      |

# Missing values 

Now we're going to check if there are any `NA` values inside our most up-to-date data frame. 


```r
dirty_file[!complete.cases(dirty_file), ]
```

```
## [1] year      pop       lifeExp   gdpPercap region   
## <0 rows> (or 0-length row.names)
```
Hum... nothing shows up! Apparently all rows are complete. But from previous examination of our region column, I remember there was some with only "_Canada", which means their continent value was missing. Let's check

```r
canada  <- dirty_file2[dirty_file2$country == "Canada", ]
head(canada)
```

```
##     year      pop lifeExp gdpPercap country continent
## 241 1952 14785584   68.75     11367  Canada          
## 242 1957 17010154   69.96     12490  Canada          
## 243 1962 18985849   71.30     13462  Canada          
## 244 1967 20819767   72.13     16077  Canada  Americas
## 245 1972 22284500   72.88     18971  Canada  Americas
## 246 1977 23796400   74.21     22091  Canada  Americas
```

```r
canada[!complete.cases(canada), ]
```

```
## [1] year      pop       lifeExp   gdpPercap country   continent
## <0 rows> (or 0-length row.names)
```
We can see that continent information are missing for some rows in `canada`, but they're still regarded as complete. 


```r
unique(canada$continent)
```

```
## [1] ""         "Americas"
```
And indeed, the empty string are not treated as `NA` value, so we need another way to search for them. 


```r
dirty_file2[dirty_file2$continent == "", ]
```

```
##     year      pop lifeExp gdpPercap country continent
## 241 1952 14785584   68.75     11367  Canada          
## 242 1957 17010154   69.96     12490  Canada          
## 243 1962 18985849   71.30     13462  Canada
```

Only those three entries are missing. We'll manually fill them now. 

```r
dirty_file2[241:243, ]$continent = "America"
dirty_file2[241:243, ]
```

```
##     year      pop lifeExp gdpPercap country continent
## 241 1952 14785584   68.75     11367  Canada   America
## 242 1957 17010154   69.96     12490  Canada   America
## 243 1962 18985849   71.30     13462  Canada   America
```
Now we've done it! 

# Capitalization 
According to the [assignment instruction](stat545-ubc.github.io/hw08_data-cleaning.html), there are some entries with inconsistent capitalization and lower cases, which probably have make the number of unique factors more than it should. So we'll check that, first the country: 


```r
#country names should be capitalized, so let's search for lower case (first letter)
grep("^\\b[a-z]", dirty_file2$country, value = TRUE)
```

```
## [1] "china" "china" "china" "china"
```

```r
# ^: beginning of the string 
```

Hey, there are four country entries that are lower case `china`. We need to find where they are and replace them with `China`. 


```r
indices  <- grep("^\\b[a-z]", dirty_file2$country)
dirty_file2[indices, ]
```

```
##     year       pop lifeExp gdpPercap country continent
## 294 1977 9.435e+08   63.97     741.2   china      Asia
## 295 1982 1.000e+09   65.53     962.4   china      Asia
## 296 1987 1.084e+09   67.27    1378.9   china      Asia
## 297 1992 1.165e+09   68.69    1655.8   china      Asia
```

```r
dirty_file2[indices, ]$country = "China"
dirty_file2[indices, ] # now it's good 
```

```
##     year       pop lifeExp gdpPercap country continent
## 294 1977 9.435e+08   63.97     741.2   China      Asia
## 295 1982 1.000e+09   65.53     962.4   China      Asia
## 296 1987 1.084e+09   67.27    1378.9   China      Asia
## 297 1992 1.165e+09   68.69    1655.8   China      Asia
```

Now that capitalize those words, we will now look for other inconsistency, like spelling. 
I think one way to look for where to start looking is to look at any inconsistency in the number of unique levels. 

```r
unique(dirty_file2$continent)
```

```
## [1] "Asia"     "Europe"   "Africa"   "Americas" "Oceania"  "America"
```
Aha, we have `America` and `Americas`, a inconsistent spelling. So let's find the Americas rows and rename their continent names.


```r
head(dirty_file2[dirty_file2$continent == "Americas", ])
```

```
##    year      pop lifeExp gdpPercap   country continent
## 49 1952 17876956   62.48      5911 Argentina  Americas
## 50 1957 19610538   64.40      6857 Argentina  Americas
## 51 1962 21283783   65.14      7133 Argentina  Americas
## 52 1967 22934225   65.63      8053 Argentina  Americas
## 53 1972 24779799   67.06      9443 Argentina  Americas
## 54 1977 26983828   68.48     10079 Argentina  Americas
```

```r
nrow(dirty_file2[dirty_file2$continent == "Americas", ])
```

```
## [1] 297
```

```r
dirty_file2[dirty_file2$continent == "Americas", ]$continent = "America"

nrow(dirty_file2[dirty_file2$continent == "Americas", ])
```

```
## [1] 0
```

```r
unique(dirty_file2$continent)
```

```
## [1] "Asia"    "Europe"  "Africa"  "America" "Oceania"
```
There might be other problems, but let's look at what we have so far and how it compares to the actual gapminder. 


# (Final) check

We will now check with the actual clean gapminder data. 


```r
# first load it 
gapminder <- read.delim("gapminderDataFiveYear.txt")
str(gapminder)
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
str(dirty_file2)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
##  $ country  : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
##  $ continent: chr  "Asia" "Asia" "Asia" "Asia" ...
```
We see that some differences still exist. First, the columns are not ordered in the same way. Moreover, the country and continent fields are not read as factors. Fixing one problem at a time....

Reorder columns by column index: 

```r
# get the colnames and their indices 
rbind(colnames(gapminder), colnames(dirty_file2) )
```

```
##      [,1]      [,2]   [,3]      [,4]        [,5]      [,6]       
## [1,] "country" "year" "pop"     "continent" "lifeExp" "gdpPercap"
## [2,] "year"    "pop"  "lifeExp" "gdpPercap" "country" "continent"
```

```r
# reorder dirty_file2 columns 
dirty_file2 <- dirty_file2[c(5, 1, 2, 6, 3, 4)]
str(dirty_file2) #check 
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ country  : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ continent: chr  "Asia" "Asia" "Asia" "Asia" ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
```

Turn characters into factors: 

```r
dirty_file2$continent  <-  as.factor(dirty_file2$continent)
dirty_file2$country   <-  as.factor(dirty_file2$country)
str(dirty_file2)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ country  : Factor w/ 146 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ continent: Factor w/ 5 levels "Africa","America",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
```

```r
str(gapminder)
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

Now that we have turned both country and continent to factors, we can see that in our data set we have more countries than we should and this is probably due to inconsistent input of countries, making R telling us there are more countries than there should be. I know I'm kind of cheating a little bit here because I already know what the clean data is supposed to look like (and thus I know how to check for differences)... but we'll try to solve that one anyway! 

First get the occurence of each "country" factor in a table. 

```r
country_table <- table(dirty_file2$country)
head(country_table)
```


Afghanistan     Albania     Algeria      Angola   Argentina   Australia 
         12          12          12          12          12          12 

We can either fully examine through this table with human eyes and look for the odd balls, or do something like: 


```r
list_num  <- as.vector(table(dirty_file2$country))
list_num[list_num != 12]
```

```
## [1]  4  8 10  1 11  1  1
```

Looks like we have more than just a few country names that are inconsistent. To find them, we'll get the indices and refer back to the table. 


```r
indices_12 <- which(list_num != 12)
country_table[indices_12]
```

```
## 
##         Central african republic         Central African Republic 
##                                4                                8 
##                 Congo, Dem. Rep.       Congo, Democratic Republic 
##                               10                                1 
##                    Cote d'Ivoire                     Cote d'Ivore 
##                               11                                1 
## Democratic Republic of the Congo 
##                                1
```
Bingo. We now go ahead and fix these countries one by one. I already checked with the actual gapminder data to see what each of the country names should be. Or one can also just assume that the mispelled one is the one with the less count. 


```r
# fix Congo, Dem. Rep. 
dirty_file2[dirty_file2$country == "Congo, Democratic Republic",]$country = 
  "Congo, Dem. Rep." 

dirty_file2[dirty_file2$country=="Democratic Republic of the Congo",]$country =
  "Congo, Dem. Rep."
# fix for Cote d'Ivoire
dirty_file2[dirty_file2$country=="Cote d'Ivore",]$country =
  "Cote d'Ivoire"

# fix Central African Republic
dirty_file2[dirty_file2$country=="Central african republic",]$country =
  "Central African Republic"

dirty_files2 <- droplevels(dirty_file2) # make sure you do this!!!!! 
```


Now we check the data frames again. 

```r
str(gapminder)
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
str(dirty_file2)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ country  : Factor w/ 146 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ continent: Factor w/ 5 levels "Africa","America",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
```

```r
summary(gapminder)
```

```
##         country          year           pop              continent  
##  Afghanistan:  12   Min.   :1952   Min.   :6.00e+04   Africa  :624  
##  Albania    :  12   1st Qu.:1966   1st Qu.:2.79e+06   Americas:300  
##  Algeria    :  12   Median :1980   Median :7.02e+06   Asia    :396  
##  Angola     :  12   Mean   :1980   Mean   :2.96e+07   Europe  :360  
##  Argentina  :  12   3rd Qu.:1993   3rd Qu.:1.96e+07   Oceania : 24  
##  Australia  :  12   Max.   :2007   Max.   :1.32e+09                 
##  (Other)    :1632                                                   
##     lifeExp       gdpPercap     
##  Min.   :23.6   Min.   :   241  
##  1st Qu.:48.2   1st Qu.:  1202  
##  Median :60.7   Median :  3532  
##  Mean   :59.5   Mean   :  7215  
##  3rd Qu.:70.8   3rd Qu.:  9325  
##  Max.   :82.6   Max.   :113523  
## 
```

```r
summary(dirty_file2)
```

```
##         country          year           pop             continent  
##  Afghanistan:  12   Min.   :1952   Min.   :6.00e+04   Africa :624  
##  Albania    :  12   1st Qu.:1966   1st Qu.:2.79e+06   America:300  
##  Algeria    :  12   Median :1980   Median :7.02e+06   Asia   :396  
##  Angola     :  12   Mean   :1980   Mean   :2.96e+07   Europe :360  
##  Argentina  :  12   3rd Qu.:1993   3rd Qu.:1.96e+07   Oceania: 24  
##  Australia  :  12   Max.   :2007   Max.   :1.32e+09                
##  (Other)    :1632                                                  
##     lifeExp       gdpPercap     
##  Min.   :23.6   Min.   :   241  
##  1st Qu.:48.2   1st Qu.:  1202  
##  Median :60.7   Median :  3532  
##  Mean   :59.5   Mean   :  7215  
##  3rd Qu.:70.8   3rd Qu.:  9325  
##  Max.   :82.6   Max.   :113523  
## 
```

Looks the same! 

# Grand final check 


```r
identical(gapminder, dirty_file2)
```

```
## [1] FALSE
```

WHAAA, I honestly don't know why. Sorry for the anti-climax, but I really don't understand. 
