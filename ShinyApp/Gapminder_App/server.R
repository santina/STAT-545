gpURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gpURL) 
library(dplyr)
library(ggplot2)

shinyServer(function(input, output){
  output$choose_country <- renderUI({ # get a country list
  	selectInput("country_from_gapminder", "country", 
  							as.list(levels(data$country)))
  })
	
	one_country_data <- reactive({
		
		if(is.null(input$select_country)){
			return(NULL)
		}
  	subset(data, country == input$select_country & 
  				 	year %in% c(input$year_range[1]:input$year_range[2])) # get it from the UI! 
  })
	
	
  # some functions do render data. 
  # which make interaction possible 
  output$gapminder_table <- renderTable({
  	one_country_data()

    
  })
  # another render function
  output$output_country <- renderText({
  	paste("Country selected", input$select_country) 
  })
  output$info <- renderPrint({ #instead of renderText so that it prints out?
  	str(input$year_range)
  })
  # this hold our plot
  output$ggplot_gdppc_vs_country <- renderPlot({
  	if(is.null(one_country_data)){
  		return(NULL)
  	}
  	p <- ggplot(one_country_data(), aes(x = year, y= gdpPercap))
  	p+ geom_point()
  })

  # if you want something to be interactive, 
  # it has to be within one of those render functions
})