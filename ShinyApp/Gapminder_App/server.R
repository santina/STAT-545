gpURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gpURL) 
library(dplyr)
library(ggplot2)

shinyServer(function(input, output){
  output$choose_country <- renderUI({ # get a country list
  	selectInput("country1", "Country 1", 
  							as.list(levels(data$country)))
  })
  
  output$choose_country2 <- renderUI({ # get a country list
    selectInput("country2", "Country 2", 
                as.list(levels(data$country)))
  })
	
	one_country_data <- reactive({
		if(is.null(input$country1)){
			return(NULL)
		}
  	subset(data, country == input$country1 & 
  				 	year %in% c(input$year_range[1]:input$year_range[2])) # get it from the UI! 
  })
	

  # some functions do render data. 
  # which make interaction possible 
  output$gapminder_table <- renderTable({
    # str(input$select_country)
  	one_country_data()    
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
  	if(is.null(one_country_data())){  
      # remember the ()
  		return(NULL)
  	}
  	p <- ggplot(one_country_data(), aes(x = year, y= gdpPercap))
  	p+ geom_point()
  })

  # if you want something to be interactive, 
  # it has to be within one of those render functions
})