# this script will analyze the LOR data and store its analysis result in a .tsv file
#' for the sake of simplicity, I'm gonna generate a new data frame 
#' that summarize number of words spoken in total in each chapter 
#' I'll do more interesting analysis in report.Rmd

library(dplyr)

lor <- read.delim("LOR_script_data.tsv")

# number of words spoken, in total, in each chapter. convert to data.frame
chapter_words <- tapply(lor$Words, lor$Chapter, sum)
# return an array, to turn it into a dataframe 
chapter_words_df <- as.data.frame(cbind(names(chapter_words), as.vector(chapter_words)))
colnames(chapter_words_df) <- c("Chapter", "TotalWords")

# we lose the information about the film, which is not included in the table chapter_words
# do get it back, we'll do merge
# I can't figure out a smart way to use joint to achieve directly, 
# so I'll drop repeating columns

lor_selected <- select(lor, Film, Chapter)

film_chapter_words <- unique(left_join(lor_selected, chapter_words_df))
# right now everything is factor, including the spoken words...
film_chapter_words$TotalWords <- as.numeric(film_chapter_words$TotalWords)

# now we calculate cumulated Sum of the spoken words.
# To do this, we need to split up the data frame by film, and then use cumsum

cumulatedWords <- tapply(film_chapter_words$TotalWords, film_chapter_words$Film, 
                         cumsum) #returns a list 
book1 <- as.vector(cumulatedWords[[1]]) # never forgets your double quote
book2 <- as.vector(cumulatedWords[[2]])
book3 <- as.vector(cumulatedWords[[3]])

cumulatedTotalWords <- c(book1, book2, book3)
film_chapter_words <- cbind(film_chapter_words, cumulatedTotalWords)

write.table(film_chapter_words, file = "analysis.tsv", quote = FALSE, 
            col.names = T, row.names = F, sep ="\t")
# very important how you write file
# use tab as deliminator instead of , because some chapter names has ,  (rage)


