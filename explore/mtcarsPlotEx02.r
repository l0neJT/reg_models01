## Exploratory scatter plot with linear model for 'mtcars' data
## Model mpg versus transmission type
mtcarsPlotEx02 <- function() {
    # Create vectors for 'mpg' and 'am'
    mpg <- mtcars$mpg
    am <- mtcars$am
    
    # Fit linear model for mpg ~ am
    fit <- lm(mpg ~ am)
    fitCoef <- summary(fit)$coefficients
    fitText <- c(paste("Intercept:", round(fitCoef[1, 1], digits = 4)),
                 paste("Intercept P-Value:", signif(fitCoef[1, 4], digits = 4)),
                 paste("Slope:", round(fitCoef[2, 1], digits = 4)),
                 paste("Slope P-Value:", signif(fitCoef[2, 4], digits = 4)))
    
    # Scatter plot mpg ~ am
    # Adds line for 'fit'
    plot(am, mpg, xlab = "Transmission (0 = Auto, 1 = Manual)", ylab = "MPG")
    abline(fit, col = "red", lwd = 2)
    text(x = 0.65, y = seq(from = 32, to = 26, by = -2), adj = c(1, 1), labels = fitText)
    title("MPG Grouped by Transmission Type")
}