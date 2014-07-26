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

    ## Helper Functions
    
    # Create formula text for use in caption and plot
    formulaTxt <- reactive({
        paste("mpg ~", input$predictor)
    })
    
    # Calculate linear model for mpg ~ predictor
    fit <- reactive({
        lm(as.formula(formulaTxt()), dat)
    })
    
    # Create data.frame fitting linear model for mpg ~ predictor
    fitDat <- reactive({
        fit <- fit()
        data.frame(car = rownames(dat),
                   trans = dat$am,
                   trans.type = factor(dat$am, labels = c("Automatic", "Manual")),
                   mpg = fit$model[, 1],
                   pre = fit$model[, 2],
                   res = resid(fit),
                   row.names = NULL)
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
    
    # Create x values for confidence and prediction interval lines
    xVals <- reactive({
        x <- dat[input$predictor]
        step = 10^(ceiling(log10(min(x))) - 2) # standardize line appearance
        xVals <- data.frame(seq(min(x), max(x), by = step))
        names(xVals) <- input$predictor
        xVals
    })
    
    ## Output Functions
    
    # Output selected formula as text
    output$caption <- renderText({
        formulaTxt()
    })
    
    # Output scatter plot for mpg ~ predictor with linear model line
    output$plotDat <- renderPlot({
        # Store user input
        fit <- fit()
        fitDat <- fitDat()
        level <- input$level
        xVals <- xVals()
        
        # Create labels
        xlab <- predictorLabel()
        ylab <- "MPG"
        main <- paste("MTCARS Regression", ylab, "~", xlab)
        
        # Plot mpg ~ predictor
        # Color codes by transmission if input checkbox marked
        plot(mpg ~ pre, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        if(!input$color) {
            points(mpg ~ pre, fitDat)
        } else {
            # Automatic = Blue
            points(mpg ~ pre, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(mpg ~ pre, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
        
        # Add linear model regression line
        abline(fit, lwd = 2)
        
        # Add confidence interval lines (dashed)
        confidence <- predict(fit, xVals, interval = "confidence", level = level)
        lines(xVals[, 1], confidence[, "lwr"], lty = 2) # lower confidence interval
        lines(xVals[, 1], confidence[, "upr"], lty = 2) # upper confidence interval
        
        # Add prediction interval lines (dotted)
        prediction <- predict(fit, xVals, interval = "prediction", level = level)
        lines(xVals[, 1], prediction[, "lwr"], lty = 3) # lower prediction interval
        lines(xVals[, 1], prediction[, "upr"], lty = 3) # upper prediction interval
        
    })
    
    # Output scatter plot for residuals ~ predictor
    output$plotRes <- renderPlot({
        # Store user input
        fitDat <- fitDat()
        
        # Create labels
        xlab <- predictorLabel()
        ylab <- "Residual (MPG)"
        main <- paste("MTCARS Residuals for", xlab)
        
        # Plot residuals ~ predictor
        # Color codes by transmission if input checkbox marked
        plot(res ~ pre, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        if(!input$color) {
            points(res ~ pre, fitDat)
        } else {
            # Automatic = Blue
            points(res ~ pre, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(res ~ pre, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
        
        # Add horizontal line
        abline(h = 0)
    })
    
    # Output summary for mpg ~ predictor linear model
    output$summary <- renderPrint({
        summary(fit())
    })
    
    # Output table for mpg, predictor, am (transmission), prediction, lower, upper
    output$table <- renderDataTable({
        # Store user input
        fit <- fit()
        fitDat <- fitDat()
        level = input$level
        predictorLabel <- predictorLabel()
        
        # Re-label table
        names(fitDat) <- c("Make", "Transmission.Num", "Transmission.Type", 
                           "MPG", predictorLabel, "Residual")
        
        # Create confidence
        confidence <- predict(fit, interval = "confidence", level = level)
        
        # Add confidence, lower, upper columns
        fitDat$Fit <- confidence[, "fit"]
        fitDat$Confidence.Lower <- confidence[, "lwr"]
        fitDat$Confidence.Upper <- confidence[, "upr"]
        
        # Create prediction
        prediction <- predict(fit, interval = "prediction", level = level)
        
        # Add prediction, lower, upper columns
        fitDat$Prediction.Lower <- prediction[, "lwr"]
        fitDat$Prediction.Upper <- prediction[, "upr"]
        
        # Return table
        fitDat
    })
})