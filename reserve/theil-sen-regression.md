+++
date = "2017-09-20T10:00:00"
draft = false
tags = ["regression", "robust", "Theil-Sen"]
title = "Theil-Sen regression in R"
math = true
+++

{{% alert note %}}
When performing a simple linear regression, if you have any concern about outliers, consider the `Theil-Sen estimator`.
{{% /alert %}}

A not-so

I mentioned to the class that some folks would recommend applying HCSEs by default. After class, I tried to learn about the difference between the different HCs. The following papers were helpful: Zeileis (2004),[^1] Long & Ervin (2000),[^2] Cribari-Neto, Souza & Vasconcellos (2007),[^3] and Hausman & Palmer (2012)[^4]. The [documentation for the sandwich package](https://cran.r-project.org/web/packages/sandwich/sandwich.pdf) was a big help. The Hausman & Palmer (H&P) paper is probably best if you're only going to read one of the papers, and it can also serve as a short handy reference for dealing with heteroskedasticity at small sample sizes.

I learned that **HCSEs can be problematic (H&P Table 1)**. Additionally, the **Wild Bootstrap does a good job of maintaining the nominal error rate in small samples (_n=40_) under homoskedasticity, moderate heteroskedasticity and severe heteroskedasticity (H&P Table 1). It is also statistically powerful (H&P Fig. 1 & 2)**. The good thing is the [hcci package](https://cran.r-project.org/web/packages/hcci/index.html) contains a function called `Pboot()` which performs the wild bootstrap to correct for heteroskedasticity.

As far as I see, the function has one limitation: when you perform your regression, you cannot use the optional dataframe argument in `lm()`. Here's an example with [this dataset](/misc/atlschools.csv):

```{r}
library(hcci)
atlschools <- read.csv("./atlschools.csv")
# You can not pass the dataframe to the Pboot function so the next few lines are required prior to calling lm()
ppc <- atlschools$PPC # per-pupil costs
ptr_c <- scale(atlschools$PTR, scale = FALSE) # pupil/teacher ratio
mts_c_10 <- scale(atlschools$MTS, scale = FALSE) / 10 # monthly teacher salary

coef(summary(fit.0 <- lm(ppc ~ ptr_c + mts_c_10)))
             Estimate Std. Error   t value     Pr(>|t|)
(Intercept) 67.884318  1.1526357 58.894861 3.017231e-41
ptr_c       -2.798285  0.3685282 -7.593138 2.427617e-09
mts_c_10     2.477010  0.8167532  3.032752 4.190607e-03

Pboot(model = fit.0, J = 1000, K = 100)

$beta
[1] 67.884318 -2.798285  2.477010

$ci_lower_simple
[1] 65.5454924 -3.7301276 -0.0653991

$ci_upper_simple
[1] 70.221038 -1.904783  4.969260
```

The CI of monthly teacher salary includes 0, evidence to suggest we cannot distinguish its slope from 0. The inference at $\alpha=.05$ is different from OLS.

[^1]: Zeileis, A. (2004). Econometric Computing with HC and HAC Covariance Matrix Estimators. _Journal of Statistical Software, 11_(10). https://doi.org/10.18637/jss.v011.i10
[^2]: Long, J. S., & Ervin, L. H. (2000). Using Heteroscedasticity Consistent Standard Errors in the Linear Regression Model. _The American Statistician, 54_(3), 217–224. https://doi.org/10.1080/00031305.2000.10474549
[^3]: Cribari-Neto, F., Souza, T. C., & Vasconcellos, K. L. P. (2007). Inference Under Heteroskedasticity and Leveraged Data. _Communications in Statistics - Theory and Methods, 36_(10), 1877–1888. https://doi.org/10.1080/03610920601126589
[^4]: Hausman, J., & Palmer, C. (2012). Heteroskedasticity-robust inference in finite samples. _Economics Letters, 116_(2), 232–235. https://doi.org/10.1016/j.econlet.2012.02.007
