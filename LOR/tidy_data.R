
# October 20 and 22  Tidying data 
# tutorial on https://github.com/datacarpentry/datacarpentry/blob/master/lessons/tidy-data/02-tidy.md

fr <- read.csv("The_Fellowship_Of_The_Ring.csv")
tw <- read.csv('The_Two_Towers.csv')
rk <- read.csv("The_Return_Of_The_King.csv")

LOR_untidy <- rbind(fr, tw, rk)
# rbind is awesome because they add new factors 

library(tidyr)

LOR_tidy <-
  gather(LOR_untidy, key = 'Gender', value = 'Words', Female, Male)

write.table(LOR_tidy, file = file.path(data_dir, "lotr_tidy.csv"),
            quote = FALSE, sep = ",", row.names = FALSE)


#' look into this bonus tutorial 
#' https://github.com/datacarpentry/datacarpentry/blob/master/lessons/tidy-data/03-tidy-bonus-content.md
#' on what to do with too many files... when you can't use rbind
#' and other options 
#' 


