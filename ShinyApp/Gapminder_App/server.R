gpURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gpURL) 
library(dplyr)

shinyServer(function(input, output){
  
  # some functions do render data. 
  # which make interaction possible 
  output$gapminder_table <- renderTable({
    years <- input$year_range
    data %>% filter(country == input$select_country, year %in% c(years[1]:years[2]))  # get it from the UI! 
    
  })
  # another render function
  output$output_country <- renderText({
    paste("Country selected", input$select_country) 
  })

  # if you want something to be interactive, 
  # it has to be within one of those render functions
})