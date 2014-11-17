
library(ggplot2) # for making plots
library(ggthemes)# for customizaing ggplot graphs 
library(scales)  # for graphs scale

# here we'll draw a graph using analysis.tsv 
# a line graph that shows totalWords spoken 
# maybe a bar graph at the bakground that shows total words spoken in each film

lor_words <- read.delim("analysis.tsv", header = T, sep = "\t")
# was stuck on this for so long because of weird factor names
# it was caused by some chapter names have "," in it. had to debug using `which()`

# very important how you read in the file
lor_words$TotalWords <- as.numeric(lor_words$TotalWords)

# we need to make it so that the chapters are read as number for graping purpose
totalChapters <- as.vector(table(lor_words$Film))
chapterNumber <- c(c(1:totalChapters[1]), c(1:totalChapters[2]), c(1:totalChapters[3]))
lor_words <- cbind(lor_words, chapterNumber)


graphWords <- ggplot(lor_words, aes(x = chapterNumber , y=cumulatedTotalWords)) + 
  geom_point() + 
  geom_line(aes(color=Film), lwd = 3)+
  ggtitle("Cumulated Words Spoken in Each Chapter") +
  theme_economist()
  

ggsave("CumulatedWordsSpoken.png")
