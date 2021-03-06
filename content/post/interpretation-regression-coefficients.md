+++
date = "2017-08-11T10:00:00"
draft = false
tags = ["regression", "causality"]
title = "On the interpretation of regression coefficients"
math = true
+++

{{% alert note %}}
We should interpret regression coefficients for continuous variables as we would descriptive dummy variables, unless we intend to make causal claims.
{{% /alert %}}

I am going to be teaching regression labs in the Fall, and somehow, I stumbled onto Gelman and Hill's _Data analysis using regression and multilevel/hierarchical models_.[^1] So I started reading it and it's a good book.

A useful piece of advice they give is to interpret regression coefficients in a predictive manner (p. 34). To see what they mean, let us consider an example.

## Predicting student performance

I'll use a [subset of the High School & Beyond dataset](/misc/datasets/hsb_comb_full.csv).

```r
hsb <- read.csv("datasets/hsb_comb_full.csv")
names(hsb)
[1] "schoolid" "minority" "female"   "ses"      "mathach"  "size"     "sector"   
[8] "pracad"   "disclim"  "himinty"  "MEANSES"  "N_BREAK"  "sesdev"   "myschool"

# Let's go with the first school, and the first 5 student-level variables
hsb <- hsb[hsb$schoolid == hsb$schoolid[1], 1:5]
summary(hsb)
schoolid       minority           female            ses             mathach      
Min.   :1224   Min.   :0.00000   Min.   :0.0000   Min.   :-1.6580   Min.   :-2.832  
1st Qu.:1224   1st Qu.:0.00000   1st Qu.:0.0000   1st Qu.:-0.8830   1st Qu.: 3.450  
Median :1224   Median :0.00000   Median :1.0000   Median :-0.4680   Median : 8.296  
Mean   :1224   Mean   :0.08511   Mean   :0.5957   Mean   :-0.4344   Mean   : 9.715  
3rd Qu.:1224   3rd Qu.:0.00000   3rd Qu.:1.0000   3rd Qu.:-0.0330   3rd Qu.:16.370  
Max.   :1224   Max.   :1.00000   Max.   :1.0000   Max.   : 0.9720   Max.   :23.584  

# Mathach, ses and female seem to have some variability
# Let's predict math achievement using female (dummy), ses (continuous)
lm(mathach ~ female + ses, hsb)

Call:
lm(formula = mathach ~ female + ses, data = hsb)

Coefficients:
(Intercept)       female          ses  
     12.092       -2.062        2.643  
```

Now the typical approach to interpreting the coefficient for `female` is:

> Holding SES constant, there is on average, a 2.06-point difference in math achievement between males and females, with males performing better.

There is nothing wrong with this approach, however to clarify the language, we could say:

> For students with the same SES, we expect a 2.06-point difference in math achievement between males and females, with males performing better.

The problem arises with the interpretation of `ses`, it typically goes:

> Holding gender constant, a point improvement in SES relates with a 2.64 increase in math achievement.

We typically claim this is a correlational statement, devoid of causal claims. However, it has causal overtones. It insinuates that within an individual, if we could raise their SES by 1 point, we can expect an increase in math achievement by 2.64 points.

Gelman and Hill advice phrasing its interpretation like this:

> For students of the same gender, we expect a 2.64-point difference in math achievement between students who have a point difference in SES.

This is what they call a _predictive interpretation_ of regression coefficients. It is devoid of causality, and communicates that we are making predictions for or describing the difference between different individuals.

[^1]: Gelman, A., & Hill, J. (2007). _Data analysis using regression and multilevel/hierarchical models_. Cambridge University Press.
