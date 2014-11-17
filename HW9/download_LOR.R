
words <- RCurl::getURL("http://bit.ly/lotr_raw-tsv", followlocation = TRUE, 
                       ssl.verifypeer = FALSE)
cat(words, file='LOR_script_data.tsv')