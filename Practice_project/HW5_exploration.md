# HW5: exploring health of people 
Santina  
Monday, October 13, 2014  

There has been a lot of exploration on the gapminder data, especially with life expectancies. We all know that the general trends for most countries, except a few countries that have went through genocides or other significant events, are upward increase of life expectancies. However, we also heard of anedotes such as Americans are eating less healthy and eating less healthy, or that cancer has become one major killer of people in the west. 

So in this assignment, I'm interested to see the "overall health" of the people, as measured by some randomly chosen factors (by me), including BMI, blood pressure, cholesterol levels, in countries where life expectancies are high. In other words, I want to see if those risk factors are going down and thus perhaps contributing to the increasing life expectancies or that they are going up. 

First load the needed packages  

```r
library(ggplot2)  # for making plots
library(ggthemes) # for customizaing ggplot graphs
library(scales)   # for graphs scale
library(plyr)     # for easy computation with data frames
library(dplyr)    # do this after loading plyr
library(knitr)    # for rendering pretty tables
library(gdata)    # for reading excel files
library(robustbase)#for lmrob function, robust linear regression
```

And then the needed datatsets 


```r
#our old friend gapminder data, for life expectancy 
gdURL <- "http://tiny.cc/gapminder"
data  <- read.delim(file = gdURL) 

#Risk factor data (source: http://www.gapminder.org/data/)
#read excel sheets with XLConnect 
require(XLConnect) #for reading excel files 

# BMI: 
BMIf = loadWorkbook("./Databank/BMI_female.xlsx")
BMI_female = readWorksheet(BMIf, sheet = "data", header = TRUE)

BMIm = loadWorkbook("./Databank/BMI_male.xlsx")
BMI_male = readWorksheet(BMIm, sheet = "data", header = TRUE)

# Cholesterol (fat) in blood, women, male, mmol/L
TC_f = loadWorkbook("./Databank/TC_female.xlsx")
TC_female = readWorksheet(TC_f, sheet = "data", header = TRUE)

TC_m = loadWorkbook("./Databank/TC_male.xlsx")
TC_male = readWorksheet(TC_m, sheet = "data", header = TRUE)

# SBP (systolic blood pressure)
SBP_f = loadWorkbook("./Databank/SBP_female.xlsx")
SBP_female = readWorksheet(SBP_f, sheet = "data", header = TRUE)

SBP_m = loadWorkbook("./Databank/SBP_male.xlsx")
SBP_male = readWorksheet(SBP_m, sheet = "data", header = TRUE)
```

Now, I will find the countries with the highest life expectancies.  


```r
life <- data %>%
  filter(year == 2007) %>%
  select(country, lifeExp) %>%
  arrange(desc(lifeExp)) #from greater to smaller
kable(life[1:5,], format = "pandoc", caption = "Top 5 countries with greatest life expectancies in 2007")
```



Table: Top 5 countries with greatest life expectancies in 2007

country             lifeExp
-----------------  --------
Japan                 82.60
Hong Kong, China      82.21
Iceland               81.76
Switzerland           81.70
Australia             81.23


Now we can start looking at the risk factors. But first, let's take a peak at one of the datasets 


```r
kable(head(BMI_female, 3))
```



|Country     |  Col2|  Col3|  Col4|  Col5|  Col6|  Col7|  Col8|  Col9| Col10| Col11| Col12| Col13| Col14| Col15| Col16| Col17| Col18| Col19| Col20| Col21| Col22| Col23| Col24| Col25| Col26| Col27| Col28| Col29| Col30|
|:-----------|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|
|Afghanistan | 20.44| 20.48| 20.52| 20.56| 20.61| 20.65| 20.69| 20.71| 20.72| 20.71| 20.70| 20.70| 20.68| 20.64| 20.59| 20.57| 20.56| 20.57| 20.59| 20.62| 20.62| 20.61| 20.65| 20.71| 20.77| 20.84| 20.91| 20.99| 21.07|
|Albania     | 25.17| 25.19| 25.20| 25.22| 25.22| 25.21| 25.21| 25.19| 25.17| 25.15| 25.14| 25.05| 24.97| 24.94| 24.94| 24.94| 24.97| 24.97| 25.00| 25.06| 25.13| 25.20| 25.27| 25.33| 25.40| 25.47| 25.53| 25.59| 25.66|
|Algeria     | 23.68| 23.81| 23.93| 24.04| 24.14| 24.24| 24.34| 24.43| 24.51| 24.59| 24.68| 24.75| 24.84| 24.93| 25.00| 25.07| 25.15| 25.23| 25.31| 25.40| 25.49| 25.59| 25.70| 25.81| 25.93| 26.04| 26.15| 26.26| 26.37|

Looks like the column names has been changed from years to "col#", so we'll change it back for easy access. 


```r
colnames(BMI_female) <- c("country", 1980:2008) 
colnames(BMI_male)   <- c("country", 1980:2008)

colnames(TC_female)  <- c("country", 1980:2008)
colnames(TC_male)    <- c("country", 1980:2008)

colnames(SBP_female) <- c("country", 1980:2008)
colnames(SBP_male)   <- c("country", 1980:2008)
```

Yes, the data sets for each risk factor are separately collected for male and female. I want to use a facet-wrap to show each country in a separate graph, and each graph with female and male. To do that, I'd have to merge the selected subsets from each data set together somehow. 


```r
#extract the top five countries names
countries  <- life[1:5,]$country 
#make a list of data sets
datalist <- list(BMI_female,BMI_male,TC_female,TC_male,SBP_female,SBP_male)
#check if countries exist in all thse data sets using the fact
# that sum of booleans is the number of TRUE (so all should equal to 5)
exist  <- lapply(datalist, function(x){sum(countries[1:5] %in% x$country)})
exist 
```

```
## [[1]]
## [1] 5
## 
## [[2]]
## [1] 5
## 
## [[3]]
## [1] 5
## 
## [[4]]
## [1] 5
## 
## [[5]]
## [1] 5
## 
## [[6]]
## [1] 5
```





