## Shiny Application for Exploring MTCARS Data Through Linear Regression
## John's Hopkins University Developing Data Products on Coursera
## Logan J Travis
## 2014-07-27

# Load libraries
library(shiny)

# Define UI
shinyUI(pageWithSidebar(
    
    # Add header with tile
    headerPanel("Explore MTCARS Data Through Linear Regression"),
    
    # Add sidebar for input
    sidebarPanel(
        selectInput("predictor", "Predictor:",
                    list("Cylinders" = "cyl",
                         "Displacement (cu.in.)" = "disp", 
                         "Weight (lb/1000)" = "wt")
                    ),
        checkboxInput("color", "Color Code by Transmission")
        ),
    
    # Add main panel for plot
    mainPanel(
        h3(textOutput("caption")),
        plotOutput("plot"),
        verbatimTextOutput("summary")
        )
    ))