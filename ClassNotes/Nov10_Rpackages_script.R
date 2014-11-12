old.packages() # get all the packges? 
update.packages() #udpate packages, ask you one by one 
update.packages(ask = FALSE)


# Nov 10 Monday. Make your R packages 

library(foo)
.libPaths() # search paths for packages 
lapply(.libPaths(), dir) # print out all the packages? 


library("devtools") # for making r packages 

create("~/gameplay") # this will tell it where to create the folder 

install.packages("Rtools") # doesnt' work? 
find_rtools() # true 

#' look at your files 
#' DESCRIPTION: describe what your package do
#' 
#' Version: major.minor.patch? 
#' [aut, cre] : authors, creator(more important, the maintainer)

library(devtools) # run this before document()