shinyUI(fluidPage(theme = "bootstrap.css",
  titlePanel("Gapminder Shiny App"),
  
  sidebarLayout(
    sidebarPanel(
                helpText(h5("Select your filtering criteria")),
    						 uiOutput("choose_country"),
                 sliderInput("year_range",
                             label = h4("Range of years: "),
                             min = 1952, # info we already know about our data
                             max = 2007,
                             value = c(1955,2005), # set the starting value
                             format = "####"         
                ), 
    						 selectInput("dropdown", 
    						             label = h4("Choose a variable"),
    						             choices = c("Population", "GDP per Capita",
    						                         "Life Expectancy"),
    						             selected = "Population")						 
            
    ),
    # the strings in those bracket are acutal name in server.R
    mainPanel(
    					plotOutput("ggplot_gdppc_vs_country"),
    					tableOutput("gapminder_table") # must be the same in server.R
    					
    )
  )
))