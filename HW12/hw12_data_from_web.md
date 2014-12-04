# HW12: Data from the Web
Santina Lin  
Friday, December 05, 2014  

# Goal
From our last week of STAT545, we learned about the amazing packages on ROpenSci through [in-class-demo](http://stat545-ubc.github.io/webdata02_activity.html) and how to [get data from the web](http://stat545-ubc.github.io/webdata03_activity.html) by reading the website. 

This is the [assignment](http://stat545-ubc.github.io/hw12_data-from-web). I will focus on : 
- combining two different datasets together
- comining different packages to make new things
- attempt to scrap data 


First let's load the housekeeping stuff: 

```r
# ==== Packages ====
library(ggplot2)    # for making plots
library(ggthemes)   # for customizaing ggplot graphs 
library(scales)     # for graphs scale
library(plyr)       # for easy computation with data frames
library(dplyr)      # do this after loading plyr
library(knitr)      # for rendering pretty tables
```

# Combine Gapminder and Geonames

First load the essentials for this section 


```r
# ==== Geonmaes package ====
#devtools::install_github("ropensci/geonames") 
options(geonamesUsername = "santina")
library(geonames)

# ==== Gapminder data ====
gdURL <- "http://tiny.cc/gapminder"
gapminder <- read.delim(file = gdURL) 
```

Now time to try answeirng Jenny's question: "What is the relationship between per-capita GDP and the proportion of the population which lives in urban centers?"
To answer this we need to know:
- the cities in each country
- the population in those cities
- how many people live in the cities centers, in each country

## get a list of countries to investigate
To see a trend, we need that information for each country. I suspect that gapminder might have less data. Let's check. 

```r
nlevels(gapminder$country)
```

```
## [1] 142
```

```r
countryInfo <- GNcountryInfo()
summary(countryInfo)
```

```
##   continent           capital           languages        
##  Length:250         Length:250         Length:250        
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##   geonameId            south            isoAlpha3        
##  Length:250         Length:250         Length:250        
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##     north             fipsCode          population       
##  Length:250         Length:250         Length:250        
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##      east            isoNumeric         areaInSqKm       
##  Length:250         Length:250         Length:250        
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##  countryCode            west           countryName       
##  Length:250         Length:250         Length:250        
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##  continentName      currencyCode      
##  Length:250         Length:250        
##  Class :character   Class :character  
##  Mode  :character   Mode  :character
```
Indeed we see that gapminder has less countries. Also all the entry in countryInfo are characters.

Since we need information from both gapminder and the information from `geonames` packages, we'll use the countries with information in both. 


```r
common_countries <- intersect(gapminder$country, countryInfo$countryName)
length(common_countries)
```

```
## [1] 28
```
There are only 28 of them! 


## Find urban population in these countries 



```r
sub <- countryInfo %>%
  filter(countryName == "France")

fgcities <- GNcities(north = sub$north, 
										east = sub$east, 
										south = sub$south, 
										west = sub$west, 
										maxRows = 500)
head(fgcities)
```

```
##                 lng geonameId countrycode         name           fclName
## 1            2.3488   2988507          FR        Paris city, village,...
## 2  4.34878349304199   2800866          BE     Brussels city, village,...
## 3  7.44744300842285   2661552          CH         Bern city, village,...
## 4              6.13   2960316          LU   Luxembourg city, village,...
## 5         7.4166667   2993458          MC       Monaco city, village,...
## 6 -2.10491180419922   3042091          JE Saint Helier city, village,...
##    toponymName                     fcodeName
## 1        Paris capital of a political entity
## 2     Brussels capital of a political entity
## 3         Bern capital of a political entity
## 4   Luxembourg capital of a political entity
## 5       Monaco capital of a political entity
## 6 Saint Helier capital of a political entity
##                                     wikipedia              lat fcl
## 1                 en.wikipedia.org/wiki/Paris         48.85341   P
## 2      en.wikipedia.org/wiki/City_of_Brussels 50.8504450552593   P
## 3                  en.wikipedia.org/wiki/Bern 46.9480943365053   P
## 4 en.wikipedia.org/wiki/Luxembourg_%28city%29       49.6116667   P
## 5                en.wikipedia.org/wiki/Monaco       43.7333333   P
## 6          en.wikipedia.org/wiki/Saint_Helier 49.1880427659223   P
##   population fcode
## 1    2138551  PPLC
## 2    1019022  PPLC
## 3     121631  PPLC
## 4      76684  PPLC
## 5      32965  PPLC
## 6      28000  PPLC
```

We can see that we have a lot of information in `countryInfo`. Where as in gapminder, as a reminder, we have: 

```r
dplyr::glimpse(gapminder)
```

```
## Variables:
## $ country   (fctr) Afghanistan, Afghanistan, Afghanistan, Afghanistan,...
## $ year      (int) 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992...
## $ pop       (dbl) 8425333, 9240934, 10267083, 11537966, 13079460, 1488...
## $ continent (fctr) Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asi...
## $ lifeExp   (dbl) 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.8...
## $ gdpPercap (dbl) 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 78...
```



# Combine Rplos and rebirds 
# Aiming higher: combining rMaps and rWBclimate 
# Leaf in the wind: Grab data from Cystic Fibrosis mutation database 
