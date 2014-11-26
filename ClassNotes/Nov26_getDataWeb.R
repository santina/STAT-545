
omdb <- function(Title, Year, Plot, Format){
	baseurl <- "http://www.omdbapi.com/?"
	params <- c("t=", "y=", "plot=", "r=")
	values <- c(Title, Year, Plot, Format)
	param_values <- Map(paste0, params, values)
	args <- paste0(param_values, collapse = "&")
	paste0(baseurl, args)
}


# try download from web, xml
omdb("Interstellar", "2014", "short", "xml")


# parse jason: 
library(jsonlite)
request_interstellar <- omdb("Interstellar", "2014", "short", "json")
answer_xml <- RCurl::getURL(request_interstellar)
fromJSON(answer_xml) # converts the output to a list


# try httr package
library(httr)
response <- GET(request_interstellar)
content(response, as = "parsed", type = "application/json") # parsing 
#read more
browseVignettes(package = "httr")


# scrapign from real website 
html("http://en.memory-alpha.org/wiki/Worf") %>%
	html_nodes(".wiki-sidebar") %>%
	html_table(header = FALSE)

