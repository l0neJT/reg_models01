## Exploratory box plot for 'mtcars' data
mtcarsPlotEx01 <- function() {
    # Create vectors for 'mpg' and 'am'
    mpg <- mtcars$mpg
    am <- mtcars$am
    
    # Create factor vector from 'am' for labeling
    transAM <- function(am) {ifelse(am == 0, "Auto", "Manual")}
    amFactor <- as.factor(sapply(am, transAM))
    
    # Bar plot comparing mpg for automatic versus manual transmissions
    plot(amFactor, mpg, xlab = "Transmission", ylab = "MPG")
    title("MPG Comparison by Transmission Type")
}