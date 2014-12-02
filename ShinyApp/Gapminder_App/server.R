data <- read.delim(file = "gapminderDataFiveYear.txt") 
library(dplyr)
library(ggplot2)
library(grid) # for unit function
library(ggthemes) # for themes

shinyServer(function(input, output){
  output$choose_country <- renderUI({ # get a country list
  	selectizeInput("countries", h4("Countries:"),
  							as.list(levels(data$country)), 
                options = list(maxItems = 10))
  }) # you can do styling in server.R too! 
  
  output$info <- renderPrint({ 
    yaxis <- switch(input$dropdown, 
                    "Population" = "pop",
                    "GDP per Capita" = "gdpPercap",
                    "Life Expectancy" = "lifeExp")
    
    print(yaxis)
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
  
  # this hold our plot
  output$ggplot_gdppc_vs_country <- renderPlot({
  	if(is.null(country_data())){  
      # remember the ()
  		return(NULL)
  	}
    
  	yaxis <- switch(input$dropdown, 
  	               "Population" = "pop",
  	               "GDP per Capita" = "gdpPercap",
  	               "Life Expectancy" = "lifeExp")
    
    # aes can't recognize variable like that, which is annoying 
    if(yaxis == "pop"){
  	p <- ggplot(country_data(), aes(x = year, y = pop ,color = country))
  	p + geom_point(size = 3) + 
  	  theme_economist() + 
      ggtitle("Population over time")+
  	  theme(plot.title=element_text(face="bold", size=20))
    }
    
    else if(yaxis == "gdpPercap"){
      p <- ggplot(country_data(), aes(x = year, y = gdpPercap ,color = country))
      p + geom_point(size = 3) + 
        theme_economist() + 
        ggtitle("GDP over time")+
        theme(plot.title=element_text(face="bold", size=20))
    }
    else{
      p <- ggplot(country_data(), aes(x = year, y = lifeExp ,color = country))
      p + geom_point(size = 3) + 
        theme_economist() + 
        ggtitle("Life expectancy over time")+
        theme(plot.title=element_text(face="bold", size=20))
    }
    
    
  })

  # if you want something to be interactive, 
  # it has to be within one of those render functions
})