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
    
    # Create label for predictor
    predictorLabel <- reactive({
        switch(input$predictor,
               "cyl" = "Cylinders",
               "disp" = "Displacement (cu.in.)",
               "hp" = "Gross Horsepower",
               "qsec" = "1/4 Mile Time",
               "wt" = "Weight (lb/1000)")
    })
    
    # Output selected formula as text
    output$caption <- renderText({
        formulaTxt()
    })
    
    # Output scatter plot for mpg ~ predictor with linear model line
    output$plot <- renderPlot({
        # Store user input
        formula <- as.formula(formulaTxt())
        fitLM <- fitLM()
        level <- input$level
        xVals <- xVals()
        
        # Create labels
        xlab <- predictorLabel()
        ylab <- "MPG"
        main <- paste("MTCARS Regression", ylab, "~", xlab)
        
        # Plot mpg ~ predictor
        # Color codes by transmission if input checkbox marked
        plot(formula, dat, xlab = xlab, ylab = ylab, main = main, type = "n")
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
        
        # Add confidence interval lines (dashed)
        confLM <- predict(fitLM, xVals, interval = "confidence", level = level)
        lines(xVals[, 1], confLM[, "lwr"], lty = 2) # lower confidence interval
        lines(xVals[, 1], confLM[, "upr"], lty = 2) # upper confidence interval
        
        # Add prediction interval lines (dotted)
        predLM <- predict(fitLM, xVals, interval = "prediction", level = level)
        lines(xVals[, 1], predLM[, "lwr"], lty = 3) # lower prediction interval
        lines(xVals[, 1], predLM[, "upr"], lty = 3) # upper prediction interval
        
        # Add
    })
    
    # Output coefficients for mpg ~ predictor linear model
    output$summaryCoef <- renderPrint({
        summary(fitLM())$coefficients
    })
    
    # Output summary for mpg ~ predictor linear model
    output$summary <- renderPrint({
        summary(fitLM())
    })
    
    # Output table for mpg, predictor, am (transmission), prediction, lower, upper
    output$table <- renderDataTable({
        # Store user input
        fitLM <- fitLM()
        level <- input$level
        predictor <- input$predictor
        predictorLabel <- predictorLabel()
        
        # Create table with mpg, transmission, and predictor
        table <- cbind(rownames(dat), dat[c("am", predictor, "mpg")])
        
        # Convert transmission to factor
        table <- transform(table, am = factor(am, labels = c("Automatic", "Manual")))
        
        # Re-label table
        names(table) <- c("Make", "Transmission", predictorLabel, "MPG")
        
        # Create prediction
        predictTable <- predict(fitLM, interval = "prediction", level = level)
        
        # Add prediction, lower, upper columns
        table$Prediction <- round(predictTable[, "fit"], digits = 1)
        table$Lower <- round(predictTable[, "lwr"], digits = 1)
        table$Upper <- round(predictTable[, "upr"], digits = 1)
        
        # Return table
        table
    })
})