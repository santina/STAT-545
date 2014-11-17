
words <- RCurl::getURL('https://raw.githubusercontent.com/eneko/data-repository/master/data/words.txt',
											 ssl.verifypeer = FALSE)
cat(words, file='dictionary.txt')
