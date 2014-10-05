#Day 2 on learning R functions 

library(assertthat)

data  <- read.delim("http://tiny.cc/gapminder")

qdiff4 <- function(x, probs = c(0,1)){
  assert_that(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  names(the_quantiles)  <- NULL
  return(max(the_quantiles)-min(the_quantiles))
}
qdiff4(data$lifeExp)

## NAS 
## remove them using remove.na = TRUE in argument 


#'the ... argument 
# let people specify function argument 

# install.packages("plyr")  #better than dplyr 
#' load library in this order :
#' library(plyr)
library(dplyr)

# (can't install... need to update to 3.1.1 ? )


#' coding challenge: a function 
#' input: data.frame with at least two variables: year, lifeExp 
#' output : numeric vecotr = est. intercept and slope from lm(lifeExp ~ year, data)


est  <- function(data){
  graph  <- lm(lifeExp ~ year, data)
  coefficients  <- graph["coefficients"]
  coefficientsData  <- coefficients %>% as.data.frame()
  yIntercept  <- coefficientsData[1,1]
  
}

# j_fit  <- lm(lifeExp ~ I(year - 1952), j_dat) #?? 
# use summary() or objects() to see what you can extract from a R object 






