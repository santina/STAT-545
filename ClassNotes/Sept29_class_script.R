

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
