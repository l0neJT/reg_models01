## Exploratory scatter plot with linear model for 'mtcars' data
## Compares model by weight to model by weight and transmission type
mtcarsPlotEx03 <- function() {
    # Load libraries
    library(datasets)
    
    # Create data frame from 'mpg', 'wt', and 'am'
    dat <- with(mtcars, data.frame(MPG = mpg, Weight = wt, Transmission.Num = am))
    
    # Set global plot variables for multi-panel
    # par(mfrow = c(2, 1))
    
    # Fit linear model for MPG ~ Weight
    fitWT <- lm(MPG ~ Weight, dat)
    fitWTCoef <- summary(fitWT)$coefficients
    fitWTText <- c(paste("Intercept:", round(fitWTCoef[1, 1], digits = 4)),
                   paste("Intercept P-Value:", signif(fitWTCoef[1, 4], digits = 4)),
                   paste("Slope:", round(fitWTCoef[2, 1], digits = 4)),
                   paste("Slope P-Value:", signif(fitWTCoef[2, 4], digits = 4)))
    
    # Scatter plot MPG ~ Weight
    # Points colord for blue = 'Auto' and red = 'Manual'
    # Adds line for 'fit'
    with(dat, plot(Weight, MPG, xlab = "Weight (1,000lbs)", ylab = "MPG", type = "n"))
    with(subset(dat, Transmission.Num == 0), points(Weight, MPG, col = "blue"))
    with(subset(dat, Transmission.Num == 1), points(Weight, MPG, col = "red"))
    legend("topright", pch = 1, col = c("blue", "red"), legend = c("Auto", "Manual"))
    abline(fitWT, lwd = 2)
    text(x = 4.75, y = seq(from = 34, to = 27, by = -2), adj = c(1, 1), labels = fitWTText)
    title("MPG by Weight")
}