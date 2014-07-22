## Shiny Application for Exploring MTCARS Data Through Linear Regression
## John's Hopkins University Developing Data Products on Coursera
## Logan J Travis
## 2014-07-27

# Load libraries
library(datasets)
library(shiny)

# Store 'mrcars' data to facilitate multiple calls
dat <- mtcars

# Define server input/output handlers
shinyServer(function(input, output) {
    
    # Create formula text for use in caption and plot
    formulaTxt <- reactive({
        paste("mpg ~", input$predictor)
    })
    
    # Calculate linear model for mpg ~ predictor
    fitLM <- reactive({
        lm(as.formula(formulaTxt()), dat)
    })
    
    # Output selected formula as text
    output$caption <- renderText({
        formulaTxt()
    })
    
    # Output scatter plot for mpg ~ predictor with linear model line
    output$plot <- renderPlot({
        # Store formula to facilitate multiple calls
        formula <- as.formula(formulaTxt())
        
        # Plot mpg ~ predictor
        # Color codes by transmission if input checkbox marked
        plot(formula, dat, type = "n")
        if(!input$color) {
            points(formula, dat)
        } else {
            # Automatic = Blue
            points(formula, subset(dat, am == 0), col = "blue")
            
            # Manual = Red
            points(formula, subset(dat, am == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Auto", "Manual"))
        }
        abline(fitLM(), lwd = 2)
    })
    
    # Output summary for mpg ~ predictor linear model
    output$summary <- renderPrint({
        summary(fitLM())$coefficients
    })  
})