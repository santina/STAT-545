shinyUI(fluidPage(
  titlePanel("Gapminder Shiny App"),
  
  sidebarLayout(
    sidebarPanel(
                 # make a drop down menu
    						 uiOutput("choose_country"),
                 sliderInput("year_range",
                             label = "Range of years: ",
                             min = 1952, # info we already know about our data
                             max = 2007,
                             value = c(1955,2005), # set the starting value
                             format = "####"         
                )
                # this makes it that no plot is changed/generated until it's hit
                #submitButton(text = "Apply Changes")
    						 
            
    ),
    # the strings in those bracket are acutal name in server.R
    mainPanel(
              textOutput("output_country"), # reference to server.R
              textOutput("info"), 
    					plotOutput("ggplot_gdppc_vs_country"),
    					tableOutput("gapminder_table") # must be the same in server.R
    					
    )
  )
))