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
  - has to use a data.frame 
  - aesthetic: map variables into perceivable properties : position, color, line type, etc
  - geom: points or line? 
  - scale
  - stat
- in base graphics figure exists as a side effect
- ggplot2 construct the figure as a R object 
  - so you need to print it to see it (doesn't automatically show up)

##tidying the data 
- tidyr::spread 
- reshape2::cast
- Try read the description ?read.table()

##


```{r}
summary(cars)
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
