all: histogram.html
	echo Build done

clean:
	Rscript 'clean.R'
	echo Cleaned

# download the dictionary from the internet 
dictionary.txt:
	Rscript 'download_words.R'

# write tsv using the command. $< means run histogram.r (first dependnecy)
histogram.tsv: histogram.r dictionary.txt
	Rscript $<

# make a png using the table we wrote into .tsv 
histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'


# more dependnecy for html 
histogram.md: histogram.Rmd histogram.tsv histogram.png
	Rscript -e 'rmarkdown::render("$<")'

# generate a report 
histogram.html: histogram.md
	Rscript -e 'rmarkdown::render("$<")'
