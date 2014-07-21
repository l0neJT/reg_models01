# Shiny Application for Exploring MTCARS Data Through Linear Regression
## John's Hopkins University Developing Data Producs on Coursera
Logan J Travis
2014-07-27

### Overview
Course project for [Developing Data Products][coursera_data_prods] class by John's Hopkins University on Coursera. Creates and interactive [shiny][shiny_home] application to explore the [mtcars][mtcars_doc] data (included in the the base version of R) using statistacl regression models.

### Assignment Text
1. Write a [shiny][shiny_home] application with associated supporting documentation. The documentation should be thought of as whatever a user will need to get started using your application.
2. Deploy the application on Rstudio's shiny server
3. Share the application link by pasting it into the text box below
4. Share your server.R and ui.R code on github

The application must include the following:
* Some form of input (widget: textbox, radio button, checkbox, ...)
* Some operation on the ui input in sever.R
* Some reactive output displayed as a result of server calculations
* You must also include enough documentation so that a novice user could use your application.
* The documentation should be at the Shiny website itself. Do not post to an external link.

The Shiny application in question is entirely up to you. However, if you're having trouble coming up with ideas, you could start from the simple prediction algorithm done in class and build a new algorithm on one of the R datasets packages. Please make the package simple for the end user, so that they don't need a lot of your prerequisite knowledge to evaluate your application. You should emphasize a simple project given the short time frame.

### Files
#### ./
* ui.r creates the shiny app interface
* server.r runs manages i/o and runs helper functions

### Links
[coursera_data_prods]: https://www.coursera.org/course/devdataprod
[mtcars_do]: http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html
[shiny_home]: http://shiny.rstudio.com/