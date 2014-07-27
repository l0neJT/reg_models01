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
    
    # Create formula text for single factor regression
    formulaS <- reactive({
        paste("mpg ~", input$predictor)
    })
    
    # Create formula text for multi-factor regression including transmission
    formulaM <- reactive({
        paste("mpg ~ (", input$predictor, "+ am)")
    })
    
    # Calculate linear model for mpg ~ predictor
    fitS <- reactive({
        mpg <- dat$mpg
        predictor <- dat[[input$predictor]]
        lm(mpg ~ predictor)
    })
    
    # Calculate linear model for mpg ~ (predictor + am)
    fitM <- reactive({
        mpg <- dat$mpg
        predictor <- dat[[input$predictor]] + dat$am
        lm(mpg ~ predictor)
    })
    
    # Create data.frame fitting separate linear models
    # for mpg ~ predictor (single) and mpg ~ (predictor + am) (multi)
    fitDat <- reactive({
        fitS <- fitS()
        fitM <- fitM()
        data.frame(car = rownames(dat),
                   trans = dat$am,
                   trans.type = factor(dat$am, labels = c("Automatic", "Manual")),
                   mpg = fitS$model[, 1],
                   pre.single = fitS$model[, 2],
                   pre.multi = fitM$model[, 2],
                   res.single = resid(fitS),
                   res.multi = resid(fitM),
                   row.names = NULL)
    })
    
    # Create label for predictor
    predictorLabel <- reactive({
        switch(input$predictor,
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
        names(xVals) <- "predictor"
        xVals
    })
    
    ## Output Functions
    
    # Output formula for single-factor regression as text
    # DUP enables use on multiple tabs
    output$capSingle <- renderText({
        formulaS()
    })
    output$capSingleDup <- renderText({
        formulaS()
    })
    
    # Output formula for multi-factor regression as text
    # DUP enables use on multiple tabs
    output$capMulti <- renderText({
        formulaM()
    })
    output$capMultiDup <- renderText({
        formulaM()
    })
    
    # Output scatter plot for mpg ~ predictor with linear model line
    output$plotDatSingle <- renderPlot({
        # Store user input
        fitS <- fitS()
        fitDat <- fitDat()
        level <- input$level
        xVals <- xVals()
        
        # Create labels
        xlab <- predictorLabel()
        ylab <- "MPG"
        main <- paste("MTCARS Regression MPG ~", xlab)
        
        # Plot mpg ~ predictor
        # Color codes by transmission if input checkbox marked
        plot(mpg ~ pre.single, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        if(!input$color) {
            points(mpg ~ pre.single, fitDat)
        } else {
            # Automatic = Blue
            points(mpg ~ pre.single, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(mpg ~ pre.single, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
        
        # Add linear model regression line
        abline(fitS, lwd = 2)
        
        # Add confidence interval lines (dashed)
        confidence <- predict(fitS, xVals, interval = "confidence", level = level)
        lines(xVals[, 1], confidence[, "lwr"], lty = 2) # lower confidence interval
        lines(xVals[, 1], confidence[, "upr"], lty = 2) # upper confidence interval
        
        # Add prediction interval lines (dotted)
        prediction <- predict(fitS, xVals, interval = "prediction", level = level)
        lines(xVals[, 1], prediction[, "lwr"], lty = 3) # lower prediction interval
        lines(xVals[, 1], prediction[, "upr"], lty = 3) # upper prediction interval
    })
    
    # Output scatter plot for mpg ~ (predictor + am) with linear model line
    output$plotDatMulti <- renderPlot({
        # Store user input
        fitM <- fitM()
        fitDat <- fitDat()
        level <- input$level
        xVals <- xVals()
        
        # Create labels
        xlab <- paste0("(", predictorLabel(), " + Transmission)")
        ylab <- "MPG"
        main <- paste("MTCARS Regression MPG ~", xlab)
        
        # Plot mpg ~ predictor
        # Color codes by transmission if input checkbox marked
        plot(mpg ~ pre.multi, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        if(!input$color) {
            points(mpg ~ pre.multi, fitDat)
        } else {
            # Automatic = Blue
            points(mpg ~ pre.multi, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(mpg ~ pre.multi, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
        
        # Add linear model regression line
        abline(fitM, lwd = 2)
        
        # Add confidence interval lines (dashed)
        confidence <- predict(fitM, xVals, interval = "confidence", level = level)
        lines(xVals[, 1], confidence[, "lwr"], lty = 2) # lower confidence interval
        lines(xVals[, 1], confidence[, "upr"], lty = 2) # upper confidence interval
        
        # Add prediction interval lines (dotted)
        prediction <- predict(fitM, xVals, interval = "prediction", level = level)
        lines(xVals[, 1], prediction[, "lwr"], lty = 3) # lower prediction interval
        lines(xVals[, 1], prediction[, "upr"], lty = 3) # upper prediction interval
    })
    
    # Output scatter plot for residuals ~ predictor
    output$plotResSingle <- renderPlot({
        # Store user input
        fitDat <- fitDat()
        
        # Create labels
        xlab <- predictorLabel()
        ylab <- "Residual (MPG)"
        main <- paste("MTCARS Residuals for", xlab)
        
        # Plot residuals ~ predictor
        # Color codes by transmission if input checkbox marked
        plot(res.single ~ pre.single, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        if(!input$color) {
            points(res.single ~ pre.single, fitDat)
        } else {
            # Automatic = Blue
            points(res.single ~ pre.single, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(res.single ~ pre.single, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
        
        # Add horizontal line
        abline(h = 0)
    })
    
    # Output scatter plot for residuals ~ (predictor + am)
    output$plotResMulti <- renderPlot({
        # Store user input
        fitDat <- fitDat()
        
        # Create labels
        xlab <- paste0("(", predictorLabel(), " + Transmission)")
        ylab <- "Residual (MPG)"
        main <- paste("MTCARS Residuals for", xlab)
        
        # Plot residuals ~ (predictor + am)
        # Color codes by transmission if input checkbox marked
        plot(res.multi ~ pre.multi, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        if(!input$color) {
            points(res.multi ~ pre.multi, fitDat)
        } else {
            # Automatic = Blue
            points(res.multi ~ pre.multi, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(res.multi ~ pre.multi, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
        
        # Add horizontal line
        abline(h = 0)
    })
    
    # Output summary for mpg ~ predictor linear model
    output$sumSingle <- renderPrint({
        summary(fitS())
    })
    
    # Output summary for mpg ~ (predictor + am) linear model
    output$sumMulti <- renderPrint({
        summary(fitM())
    })
    
    # Output table data
    output$table <- renderDataTable({
        # Store user input
        fitS <- fitS()
        fitM <- fitM()
        fitDat <- fitDat()
        level = input$level
        predictorLabel <- predictorLabel()
        
        # Re-label table
        names(fitDat) <- c("Make", "Transmission.Num", "Transmission.Type", 
                           "MPG", predictorLabel,
                           paste0("(", predictorLabel, " + Transmission)"),
                           "Residual.Single", "Residual.Multi")
        
        # Create prediction for mpg ~ predictor
        prediction <- predict(fitS, interval = "prediction", level = level)
        
        # Add prediction, lower, upper columns
        fitDat$Fit.Single <- prediction[, "fit"]
        fitDat$Lower.Single <- prediction[, "lwr"]
        fitDat$Upper.Single <- prediction[, "upr"]
        
        # Create prediction for mpg ~ predictor + am
        prediction <- predict(fitM, interval = "prediction", level = level)
        
        # Add prediction, lower, upper columns
        fitDat$Fit.Multi <- prediction[, "fit"]
        fitDat$Lower.Multi <- prediction[, "lwr"]
        fitDat$Upper.Multi <- prediction[, "upr"]
        
        # Return table
        fitDat
    })
})