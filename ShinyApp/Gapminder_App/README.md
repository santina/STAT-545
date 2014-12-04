
# Usage 
This Shiny application, [Gapminder Shiny App](http://santinalin.shinyapps.io/Gapminder_App) reads country data downloaded from Gapminder. For the purpose of this application as an assignment, the data is read from a file in the same directory. 

Click on __show below__ if the code window interferes with the view of the graph.

Users can choose up to 10 countries by typing the names in the search box. The search will try to autocomplete the search. Users also have the options to adjust the parameters for x-axis and y-axis through the slide bar for years and dropdown menu for the variable of interest. 

A data frame following the plot is the table from which the graph is produced. 


# Challenges 
I spent a great deal of time trying to figure out how to change the graph based on the dropdown menu input ("Population", "life Expectacy", "GDP per Capita"). For some reason, the `aes()` part of ggplot2 cannot read something like `input$radio` (if I do radio buttons) or `input$dropdown`. 

If I first wrap `input$dropdown` with another funtion, like `reactive({})` and assign that to a variable, it would not recognize that variable. I wasn't sure what I was missing since it seemed like it should work. Eventually, I worked around it by using `switch` and if/else statements. However, I understand that this solution wouldn't work if we have many variables, unlike in this data set we only have 3 to be concerned with. 

# Others

I really like the search box I made, which was taken from an example on the shiny gallery. It integrates with the server side so nicely. Besides that, I find shiny app harder to debut in general. Unlike other assignments/projects, you can type things into the console, try different code, before putting them in a R markdown or .R file. In Shiny, the variables are stored within the app and no accessible through the console. I think some of the things we are used to, such as `kable`, can't be used in shiny either (at least it throws me some error). At least, turning the background into something dark helps make the table look prettier.

The `DESCRIPTION` file allows me to set show-case to default so that my peer can look at both README and code while looking a shiny without having to make extra clicks on my github page. 

# Credits 

I credit my learning in this assignment to the [in class tutorial](http://stat545-ubc.github.io/shiny03_activity.html) as well as various resources on the Shiny app website. I also use the css style sheet downloaded from [bootswatch's slate theme](http://bootswatch.com/slate/). The styling of the graph itself is done using the package `ggthemes`. 
