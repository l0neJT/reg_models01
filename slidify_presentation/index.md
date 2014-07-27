---
title       : Exploring Transmission Impact on Automobile Efficiency
subtitle    : Using Shiny App and MTCARS Dataset
author      : Logan J Travis
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Executive Summary
* Many struggle to understand the impact of discrete variables in statistical models
* Investigate automobile efficiency as a familiar and accessible example
* Design a simple application targeting non-statisticians to:
    * Interactively model fuel efficiency (MPG) using a variety of continuous variables<br>(e.g. weight, engine displacement)
    * Compare model fit after adding a discrete variable (transmission type)
* Host the application online for all to experience!

---

## Dataset and Methodology
### [MTCARS Dataset](http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html)
* Part of the base R package
* Extracted from the 1974 *Motor Trend* US magazine
* Compares fuel consumption against 10 variable for 32 automobiles

### Linear Regression Models
* Regression by transmission type yields useful results (details on next slide)
* Attempt to improve by regressing other variables
* Compare single variable versus adding transmission type

--- &twocol

## Example Regression Against Transmission Type

*** =left

![plot of chunk plotMPG~Trans](assets/fig/plotMPG~Trans.png) 

*** =right

* Linear regression for MPG ~ transmission *suggests* a benefit for manuals
    * The P-value for the slope (two-sided) bests a 99.9% confidence interval
    * The P-value for the intercept greatly exceeds 99.9% confidence
* Yet, predictions from transmission alone spread +/- 10 MPG
* Would you buy a car offering 6 to 27 MPG?


```
##   Transmission   Fit  Lower Upper
## 1       Manual 24.39 14.003 34.78
## 2    Automatic 17.15  6.876 27.42
```

---

## Shiny App

* Available on the [Rstudio Shiny App Server](http://lonejt.shinyapps.io/shiny_app/)
* Input controls for predictor, interval, and color coding by transmission

    <img src = "./assets/img/app_inputs.png" />

* Plots comparing single and multi-variable regression
* Tabs for summary statistics and table data

---

## Interpreting Results

* Many variables yield tighter fits than transmission type notably:
    * Displacement (cu. in.) with P-value of 9.38e-10
    * Weight (lb/1000) with a P-value of 1.29e-10
* Adding transmission type did not improve better-fit variables
* Adding transmission type *did* improve predictor P-values for poorer-fit<br>variables such as Gross Horsepower and 1/4 Mile Time
* However, model quality (determined by adjusted R squared) always decreased
