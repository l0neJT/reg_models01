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
                    list("Displacement (cu.in.)" = "disp",
                         "Gross Horsepower" = "hp",
                         "1/4 Mile Time" = "qsec",
                         "Weight (lb/1000)" = "wt")
                    ),
        checkboxInput("color", "Color Code by Transmission"),
        sliderInput("level", "Confidence and Prediction interval:",
                    min = 0.50, max = 0.99, value = 0.95, step = 0.01)
        ),
    
    # Add main panel for plot
    mainPanel(
        h3("Comparison of Single Versus Multi-Factor Regresion"),
        tabsetPanel(
            tabPanel(textOutput("capSingle"),
                     plotOutput("plotDatSingle"),
                     tableOutput("coefSingle")), 
            tabPanel("Residual Comparison",
                     plotOutput("plotResSingle"),
                     plotOutput("plotResMulti")),
            tabPanel("Model Comparison",
                     h4(textOutput("capSingleDup")),
                     verbatimTextOutput("sumSingle"),
                     br(),
                     h4(textOutput("capMultiDup")),
                     verbatimTextOutput("sumMulti")),
            tabPanel("Table", dataTableOutput("table"))
            )
        )
    ))