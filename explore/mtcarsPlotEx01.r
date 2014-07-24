## Exploratory box plot for 'mtcars' data
mtcarsPlotEx01 <- function() {
    # Load libraries
    library(datasets)
    
    # Create vectors for 'mpg' and 'am'
    mpg <- mtcars$mpg
    am <- mtcars$am
    
    # Create factor vector from 'am' for labeling
    amFactor <- factor(am, labels = c("Auto", "Manual"))
    
    # Box plot comparing mpg for automatic versus manual transmissions
    plot(amFactor, mpg, xlab = "Transmission", ylab = "MPG")
    title("MPG Comparison by Transmission Type")
}