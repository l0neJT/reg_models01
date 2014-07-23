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
    
    # Create x values for confidence and prediction interval lines
    xVals <- reactive({
        x <- dat[input$predictor]
        step = 10^(ceiling(log10(min(x))) - 2) # standardize line appearance
        xVals <- data.frame(seq(min(x), max(x), by = step))
        names(xVals) <- input$predictor
        xVals
    })
    
    # Output selected formula as text
    output$caption <- renderText({
        formulaTxt()
    })
    
    # Output scatter plot for mpg ~ predictor with linear model line
    output$plot <- renderPlot({
        # Store formula, fitLM, and xVals to facilitate multiple calls
        formula <- as.formula(formulaTxt())
        fitLM <- fitLM()
        xVals <- xVals()
        
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
        
        # Add linear model regression line
        abline(fitLM, lwd = 2)
        
        # Add confidence interval lines
        confLM <- predict(fitLM, xVals, interval = "confidence")
        lines(xVals[, 1], confLM[, "lwr"]) # lower confidence interval
        lines(xVals[, 1], confLM[, "upr"]) # upper confidence interval
        
        # Add prediction interval lines
        predLM <- predict(fitLM, xVals, interval = "prediction")
        lines(xVals[, 1], predLM[, "lwr"]) # lower prediction interval
        lines(xVals[, 1], predLM[, "upr"]) # upper prediction interval
    })
    
    # Output summary for mpg ~ predictor linear model
    output$summary <- renderPrint({
        summary(fitLM())$coefficients
    })  
})