all: report.html
	echo Build done

clean:
	Rscript 'clean.R'
	echo Cleaned

# download the the lord of ring data from the internet 
LOR_script_data.tsv:
	Rscript 'download_LOR.R'

# processing data 
analysis.tsv: analysis.R LOR_script_data.tsv 
	Rscript $<

# write a graph that summarize amount of speech
CumulatedWordsSpoken.png: figures.R analysis.tsv
	Rscript $< 

# take care of dpenedency in our report 
report.html: report.Rmd CumulatedWordsSpoken.png analysis.tsv LOR_script_data.tsv
	Rscript -e 'rmarkdown::render("$<")'



