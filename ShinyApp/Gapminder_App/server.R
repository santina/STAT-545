gpURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gpURL) 
library(dplyr)
library(ggplot2)

shinyServer(function(input, output){
  output$choose_country <- renderUI({ # get a country list
  	selectizeInput("countries", "Countries:",
  							as.list(levels(data$country)), 
                options = list(maxItems = 10))
  })
  
	
	country_data <- reactive({
		if(is.null(input$countries[1])){
			return(NULL)
		}
  	subset(data, country %in% input$countries & 
  				 	year %in% c(input$year_range[1]:input$year_range[2])) # get it from the UI! 
  })
	

  # some functions do render data. 
  # which make interaction possible 
  output$gapminder_table <- renderTable({
    # str(input$select_country)
  	country_data()    
  })
  
  
  # another render function
  output$output_country <- renderText({
  	paste("Country selected", input$country1)
  })
  
  output$info <- renderPrint({ #instead of renderText so that it prints out?
  	str(input$year_range)
  })
  # this hold our plot
  output$ggplot_gdppc_vs_country <- renderPlot({
  	if(is.null(country_data())){  
      # remember the ()
  		return(NULL)
  	}
  	p <- ggplot(country_data(), aes(x = year, y= gdpPercap,color = country))
  	p+ geom_point()
  })

  # if you want something to be interactive, 
  # it has to be within one of those render functions
})