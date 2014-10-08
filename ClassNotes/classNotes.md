---
title: "ClassNotes"
author: "Santina"
class : "STATS545"
output: html_document
---
#Wednesday, Sept 17 


##ggplot2/lattice are pretty 

- facetting 
- facet grid (`facet_grid(~continent*year)`)
- multi-panel conditioning 
- aesthetic plotting (?) 
- to maeka  plot
  * has to use a data.frame 
  * aesthetic: map variables into perceivable properties : position, color, line type, etc
  * geom: points or line? 
  * scale
  * stat
- in base graphics figure exists as a side effect
- ggplot2 construct the figure as a R object 
  * so you need to print it to see it (doesn't automatically show up)

##tidying the data 
- tidyr::spread 
- reshape2::cast
- Try read the description ?read.table()

##R markdown
- went through R markdown

##assignmet time
- was given time to wokr on 

-----
#Monday Sept 22 

##ggplot2 tutorial 
- use this [tutorial link](https://github.com/jennybc/ggplot2-tutorial)
- you can convert R-> Rmd  -> md -> html 
  * in R, write comment as #'  
  * "compled as notebook" (little white button)
- we did the scatter plot demo 

##Some useful books: 
- Dynamic Documents with R and knitr (the R series) by Yihui Xie 
  - seem very interesting to learn a wide varieties of languages and markdown 

-------

#Wednesday Sept 24 
- Went through two tutorials 
  * [intro to dplyr](http://stat545-ubc.github.io/block009_dplyr-intro.html)
  * [dplyr functions](http://stat545-ubc.github.io/block010_dplyr-end-single-table.html)

- look up knitr and get better at it 
  * play around with knitr::kable() to make a table prettier
  
  
-------

#Monday Sept 29
- Went through functions in R 
  * see "Sept29_class_script.R"

- critical things i didn't know before which I learned from friends today..
  * need to create issue when submitting homework
    - include your commit link 
  * view peer reviews from other by clicking on "issue" next to each homework folder 

-------
#Monday Oct 6 
- ordering your factors  (though class notes not posted on website yet)
- linear regression (see October6_class_script) on gapminder 


-------

#Wednesday Oct 8
- went through outline for today
  * for homework 4, find an interesting dataset to work with and analyze it 
- read in data (read.table, read.delim?) make sure you have the right arguments 
- read and write data and R objects
  * see October8_class_script, 
    - read.delim() and write.table()
    - saveRDS() and readRDS() 
    - dput() and dget() 