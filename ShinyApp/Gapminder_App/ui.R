shinyUI(fluidPage(
  titlePanel("Gapminder Shiny App"),
  
  sidebarLayout(
    sidebarPanel("User input will be here", 
                 # make a drop down menu
                 selectInput("select_country", 
                             label = "Country", 
                             choices = list("Iraq", "Canada", "Mali")
                    )
      ), 
    mainPanel("My cool graphs go here",
      tableOutput("gapminder_table")
      )
    )
  ))