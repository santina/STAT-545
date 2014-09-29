

# Monday (sept 29) - writing R function 

gdURL <- "http://tiny.cc/gapminder"
gDat <- read.delim(file = gdURL) 

#task: input a variable and output min and max 
#pracitce input be gDat#lifeExp 
#max, min, range 

min(gDat$lifeExp)
max(gDat$lifeExp)
range(gDat$lifeExp)
diff(range(gDat$lifeExp))

#turn that into a proper function
max_minus_min  <- function(x) max(x)-min(x)
max_minus_min 

#test it on some data 
max_minus_min(gDat$lifeExp)

#test it on other inputs 
max_minus_min(rnorm(1000))
max_minus_min(1:20)

#try to break the function 
max_minus_min("santina")


#check validity 
mmm <- function(x){
  #stopifnot(is.numeric(x))  #stop if things aren't right
  ##or you can do: 
  if(!is.numeric(x))
    stop("NOOOOO")
  
  #pass validity check.. then will get this following line
  max(x) - min(x)
}

#another option, but people need to install a packaage
install.packages(assertthat)
library(assertthat)

mm3  <- function(x){
  assert_that(is.numeric(x))
  max(x) - min(x)
}

##ensurer is another package 
#esp important for genome study 
