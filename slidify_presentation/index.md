---
title       : Modeling Transmission Impact on Automobile Efficiency
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
* Investigate automobile effiencey as a familiar and accesible example
* Design a simple application targeting non-statisticians to:
    * Interactively model fuel efficiency (MPG) using a variety of continuous variables<br>(e.g. weight, engine displacement)
    * Compare model fit after adding a discrete variable (transmission type)
* Host the application online for all to experience!

---

## Dataset and Methodology
### MTCARS Dataset

### Linear Regression Models

--- &twocol

## Example Regression Against Transmission Type

*** =left

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1.png) 

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

---

## Interpreting Results
