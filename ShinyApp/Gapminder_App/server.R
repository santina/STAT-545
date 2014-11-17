gpURL <- "http://tiny.cc/gapminder"
data <- read.delim(file = gpURL) 

shinyServer(function(input, output){
  
  # some functions do render data. 
  # which make interaction possible 
  output$gapminder_table <- renderTable({
    data
  })
  # another render function
  output$output_country <- renderText({
    paste("Country selected", input$select_country)
  })
})