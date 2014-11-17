shinyUI(fluidPage(
  titlePanel("Gapminder Shiny App"),
  
  sidebarLayout(
    sidebarPanel("User input will be here", 
                 # make a drop down menu
                 selectInput("select_country", 
                             label = "Country", 
                             choices = list("Iraq", "Canada", "Mali")
                 ), 
                 sliderInput("year_range",
                             label = "Range of years: ",
                             min = 1952, # info we already know about our data
                             max = 2007,
                             value = c(1955,2005), # set the starting value
                             format = "####"         
                )
            
    ), 
    mainPanel("My cool graphs go here",
              textOutput("output_country"), # reference to server.R
              tableOutput("gapminder_table") # must be the same in server.R
    )
  )
))