# reg_models01
## John's Hopkins University Regression Models on Coursera
Logan J Travis
2014-07-27

### Overview
Course project for [Regression Models][coursera_reg_models] class by John's Hopkins University on Coursera. Analyzes the [mtcars][mtcars_doc] data (included in the the base version of R) using statistacl regression models.

### Assignment Text
You work for [Motor Trend][motor_trend], a magazine about the automobile industry. Looking at a data set of a collection of cars, they are interested in exploring the relationship between a set of variables and miles per gallon (MPG) (outcome). They are particularly interested in the following two questions:

* “Is an automatic or manual transmission better for MPG”
* "Quantify the MPG difference between automatic and manual transmissions"
Question

Take the [mtcars][mtcars_doc] data set and write up an analysis to answer their question using regression models and exploratory data analyses.

Your report must be:

* Written as a PDF printout of a compiled (using knitr) R markdown document.
* Do not use any packages that are not in R-base or the library datasets.
* Brief. Roughly the equivalent of 2 pages or less for the main text. Supporting figures in an appendix can be included up to 5 total pages including the 2 for the main report. The appendix can only include figures.
* Include a first paragraph executive summary.

### Files
#### ./explore/
* mtcarsPlotEx01.r creates a box plot of MPG by transmission type
* mtcarsPlotEx02.r creates a scatter plot with linear model line of MPG by transmission type (automatic = 0 and manual = 1)
* mtcarsPlotEx03.r creates a scatter plot with linear model line of MPG by weight (in 1000 lbs) grouped by transmission type

#### ./shiny_app

#### ./slidify_presentation

### Links
[coursera_reg_models]: https://www.coursera.org/course/regmods
[mtcars_do]: http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html
[motor_trend]: http://www.motortrend.com/