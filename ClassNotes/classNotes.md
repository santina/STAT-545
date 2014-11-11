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
    
    
-------
#Wednesday Oct 15 
- [standards](http://stat545-ubc.github.io/block015_graph-dos-donts.html) on making graphs
  * show the data, not just the artificial statistic model (trend line, etc)
  * check out [R catalog] (http://shinyapps.stat.ubc.ca/r-graph-catalog/)
- simplify your graph 
- don't use pie chart (people can't perceive area and angle well)
- use label, not legend, and make their color match 

-------
#Monday Oct 20 

- talked about [colors in R](http://stat545-ubc.github.io/block018_colors.html) 
  * library(RColorBrewer)
  * display.brewer.all()
  * use `par` to set default and restore it back 
  * color palette: HCL 
  * consider what you want to emphasize, the levels of extremes, etc 
- Tidying data 
  * use `gather()`, inside argument `key = ` and `value = ` 
  * library(tidyr), package that is for data reshaping 
  
------ 
# Wednesday Oct 23 
- finished [tidying data](http://stat545-ubc.github.io/bit002_tidying-lotr-data.html)
- free play 

------

# Monday Oct 27 
- [Regular expression](http://stat545-ubc.github.io/block022_regular-expression.html)

------

# Wednesday Oct 29
- finished [Regular Expression](http://stat545-ubc.github.io/block022_regular-expression.html)
  * I need to actually go through this. kind of lost 
- presentation on good data
- [cleaning data](http://www.slideshare.net/jenniferbryan5811/excel-readwritedelimfiles) 
  * gdata:: read.xls()  to access excel file directl from R 
  * save every intermediate files.. .preferably in text.
  
- google " biologists this is why bioinformaticians hate you"

------

# Monday Nov 3 

- Automation
  * R, shell and R script, make 
- pipeline 
  * take a monolithic script into logical components 
  * important : each stage never modify its input 
- some symbols
  * $<  imput file
  * $@ output (target)
  
-------

# Wednesday Nov 5 
- #^ ? 
- article.html: article.Rmd..  so if Rmd gets modified, the following codes gets run.
- use pattern rules, $@, $<
```{r }
all: article.html

%.png: %.gv
    dot -Tpng -o $@ $<

%.md: %.Rmd
    Rscript -e 'knitr::knit("$<", "$@")'

%.html: %.md
    pandoc -s -o $@ $<

article.html: figure.png
```
- if you change figure.png then it will know it has to update article.html
	* the third command shows make how to update any html file 

```
.DELETE_ON_ERROR:
.SECONDARY:

%.png: %.gv
    dot -Tpng -o $@ $<

%.md: %.Rmd
    Rscript -e 'knitr::knit("$<", "$@")'

%.html: %.md
    pandoc -s -o $@ $<

article.html: figure.png

```
	
- .DELETE_ON_ERROR: delete open files if there are errors 
- .SECONDARY : don't delete intermediate files 

----------------

# Monday Nov 10 : Build your first R packages
- old.packages() : this updates packages 
- update.packages()
- update.packages(ask = FALSE)
- http://r-pkgs.had.co.nz/r.html 
