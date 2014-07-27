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
        paste("mpg ~", input$predictor, "+ am")
    })
    
    # Calculate linear model for mpg ~ predictor
    fitS <- reactive({
        lm(as.formula(formulaS()), dat)
    })
    
    # Calculate linear model for mpg ~ predictor + am
    fitM <- reactive({
        lm(as.formula(formulaM()), dat)
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
                   pre = fitS$model[, 2],
                   fit.single = fitted(fitS),
                   res.single = resid(fitS),
                   fit.multi = fitted(fitM),
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
        names(xVals) <- input$predictor
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
        plot(mpg ~ pre, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        
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
        
        # Color code points by transmission if input checkbox marked
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
    })
    
    # Output coefficients for mpg ~ predictor
    output$coefSingle <- renderTable ({
        t(coef(fitS()))
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
        plot(res.single ~ pre, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        
        # Add horizontal line
        abline(h = 0, lwd = 2)
        
        # Add dotted max/min lines
        maxRes <- max(fitDat$res.single)
        miners <- min(fitDat$res.single)
        abline(h = maxRes, lty = 3)
        abline(h = miners, lty = 3)
        
        # Color code points by transmission if input checkbox marked
        if(!input$color) {
            points(res.single ~ pre, fitDat)
        } else {
            # Automatic = Blue
            points(res.single ~ pre, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(res.single ~ pre, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
    })
    
    # Output scatter plot for residuals ~ predictor + am
    output$plotResMulti <- renderPlot({
        # Store user input
        fitDat <- fitDat()
        
        # Create labels
        xlab <- predictorLabel()
        ylab <- "Residual (MPG)"
        main <- paste("MTCARS Residuals for", xlab, "+ Transmission")
        
        # Plot residuals ~ predictor
        plot(res.multi ~ pre, fitDat, xlab = xlab, ylab = ylab, main = main, type = "n")
        
        # Add horizontal line
        abline(h = 0, lwd = 2)
        
        # Add dotted max/min lines
        maxRes <- max(fitDat$res.multi)
        miners <- min(fitDat$res.multi)
        abline(h = maxRes, lty = 3)
        abline(h = miners, lty = 3)
        
        # Color code points by transmission if input checkbox marked
        if(!input$color) {
            points(res.multi ~ pre, fitDat)
        } else {
            # Automatic = Blue
            points(res.multi ~ pre, subset(fitDat, trans == 0), col = "blue")
            
            # Manual = Red
            points(res.multi ~ pre, subset(fitDat, trans == 1), col = "red")
            
            # Add legend
            legend("topright", pch = 1, col = c("blue", "red"),
                   legend = c("Automatic", "Manual"))
        }
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
        fitDat <- fitDat()
        
        # Re-label table
        names(fitDat) <- c("Make", "Transmission.Num", "Transmission.Type", 
                           "MPG", predictorLabel(),
                           "Fit.Single", "Residual.Single",
                           "Fit.Multi", "Residual.Multi")
        
        # Return table
        fitDat
    })
})