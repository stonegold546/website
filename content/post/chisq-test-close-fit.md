+++
date = "2017-11-16T10:00:00"
draft = false
tags = ["sem", "cfa", "misspecification", "fit indices"]
title = "A Chi-Square test of close fit in covariance-based SEM"
math = true
+++

{{% alert note %}}
If you can assume close fit for the RMSEA, there is no reason why you cannot for a Chi-Square test in SEMs. The method to do this is relatively simple, and may cause SEM practitioners to reconsider the Chi-Square test.
{{% /alert %}}

When assessing the fit of structural equation models, it is common for applied researchers to dismiss the $\chi^2$ test because it will almost always detect a statistically significant discrepancy between your model and the data, given a large enough sample size. This is because, almost always, our models are approximations of the data. If our model-implied covariance matrix actually matched the sample covariance matrix within sampling variability, the $\chi^2$ test would not be statistically significant regardless of sample size.

Because of the sensitivity of the $\chi^2$ test to large sample sizes, practitioners often rely on other fit indices like the `RMSEA`, `CFI`, and `TLI` - all of which are based on the $\chi^2$. For the RMSEA, MacCallum, Browne and Sugawara (1996)[^1] specified values of .05 and .08 as indicating close and mediocre[^2] fit respectively. And in lavaan, you automatically get a test of close fit for the RMSEA with confidence intervals and a p-value. This test actually uses the $\chi^2$ distribution, and there is no reason why one cannot perform a $\chi^2$ test of close or mediocre fit depending on one's standards.[^3]

**The sections that follow may include details that not everyone would like to read about, you can skip to the [bottom of the page for annotated lavaan code](#lavaan) for how to compute a $\chi^2$ test of close or mediocre fit.**

So the formula for the RMSEA is:

$\sqrt{\frac{\chi^2-df}{df(N-1)}}$

where $\chi^2$ is the $\chi^2$ test statistic of your model, $df$ is your model degrees of freedom, and $N$ is sample size.

If your model fit the data perfectly, the numerator, $\chi^2-df$, is zero; this is the hypothesis the standard $\chi^2$-test tests. And to test this hypothesis, it uses the $\chi^2$-distribution. If we want to perform a test of close fit on the RMSEA, we do not assume a nil null distribution for the $\chi^2$. Instead, we use the non-central $\chi^2$ distribution with a non-centrality parameter that corresponds to an RMSEA of .05. The idea is we accept some level of misspecification, and we use a distribution that corresponds to this level of misspecification. Lavaan reports the result of this test as one of the fit statistics.

For those who are not familiar with non-central distributions, they are the general family of distributions to which the distributions we are familiar with belong. For example, the $t$-test assumes a nil (zero) null effect so we use the non-central $t$-distribution, with an expected value (and non-centrality parameter) of zero. This distribution is what we call the $t$-distribution. If we want to create confidence intervals without assuming a nil effect, we can actually use a $t$-distribution while specifying its non-centrality parameter $(\lambda)$. It is the distribution when the null of zero is false. The [Wikipedia introduction to this topic for the $t$-distribution](https://en.wikipedia.org/wiki/Noncentral_t-distribution) is decent.

So how does this help us? The non-centrality parameter $(\lambda)$ for the RMSEA test in lavaan is actually the $\chi^2-df$ value that corresponds to an RMSEA of .05. In math:

$RMSEA = \sqrt{\frac{\chi^2-df}{df(N-1)}}$

$RMSEA^2 = \frac{\chi^2-df}{df(N-1)}$

$RMSEA^2 \times df(N-1) = \chi^2-df$

Since $\chi^2-df$ is $\lambda$, then:

$\lambda = RMSEA^2 \times df(N-1)$

So for a test of close fit, $\lambda$ is:

$RMSEA^2 \times df(N-1) = .05^2 \times df(N-1) = .0025 \times df(N-1)$

And for a test of mediocre fit, $\lambda$ is:

$RMSEA^2 \times df(N-1) = .08^2 \times df(N-1) = .0064 \times df(N-1)$

Note that lavaan may do things a little differently.[^4]

Hence, given a model degrees of freedom, and sample size, we can calculate the non-centrality parameter $(\lambda)$. And given $\lambda$, a $\chi^2$ value and the degrees of freedom for the model, we can calculate the p-value for a test of close or mediocre fit.

The R syntax for this is:

```{r}
pchisq(Chi-sq-value, degrees-of-freedom, non-centrality-parameter, FALSE)
```

<div id="lavaan">

## Demonstration

```{r}
library(lavaan)
data("HolzingerSwineford1939")
# model syntax for a bifactor model with the HolzingerSwineford1939 dataset
# eliminating visual factor resolves Heywood case
writeLines(syntax <- paste(
  paste("g =~", paste0("x", 1:9, collapse = " + ")),
  # paste("visual =~", paste0("x", 1:3, collapse = " + ")),
  paste("textual =~", paste0("x", 4:6, collapse = " + ")),
  paste("speed =~", paste0("x", 7:9, collapse = " + ")),
  sep = "\n"
))

g =~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9
textual =~ x4 + x5 + x6
speed =~ x7 + x8 + x9

# Run model & report fit measures
# Reporting only fit statistics relevant to this demonstration
summary(hs.fit <- cfa(syntax, HolzingerSwineford1939, std.lv = TRUE,
                      orthogonal = TRUE), fit.measures = TRUE)

lavaan (0.5-23.1097) converged normally after  25 iterations

  Number of observations                           301

  Estimator                                         ML
  Minimum Function Test Statistic               42.291
  Degrees of freedom                                21
  P-value (Chi-square)                           0.004

Root Mean Square Error of Approximation:

  RMSEA                                          0.058
  90 Percent Confidence Interval          0.032  0.083
  P-value RMSEA <= 0.05                          0.276

# Chi-square is statistically significant, this test of perfect fit suggests
# the misfit between our model-implied cov matrix and sample cov matrix is
# greater than expected due to sampling variability.

# The default Chi-square test:

pchisq(q = 42.291, df = 21, ncp = 0, lower.tail = FALSE)

[1] 0.003867178

# Use formula above to calculate non-centrality parameter for test of close fit
# .0025 multiplied by model degrees of freedom by sample size - 1

(ncp.close <- .0025 * 21 * (301 - 1))

[1] 15.75

# Calculate Chi-square test of close fit

pchisq(q = 42.291, df = 21, ncp = ncp.close, lower.tail = FALSE)

[1] 0.2740353

# The p-value for a test of close fit is .27, close to the value reported by
# lavaan. The reason they are not closer is that lavaan does not subtract 1
# from the sample size when calculating the non-centrality parameter under
# its default settings for ML. See the final footnote below for details.

# And if we lower our standards to conduct a chi-square test of mediocre fit:
# .0064 multiplied by model degrees of freedom by sample size - 1

(ncp.med <- .0064 * 21 * (301 - 1))

[1] 40.32

pchisq(q = 42.291, df = 21, ncp = ncp.med, lower.tail = FALSE)

[1] 0.9199686

# If we assume mediocre misspecification in our model, the probability of
# observing our model-implied covariance matrix is 92%. Pretty good.
```

In closing, SEM practitioners typically report the $\chi^2$-test, but routinely expect the test to detect model misspecification, so often ignore it in practice. I hope the steps above show how one can conduct $\chi^2$-tests that assume some degree of model misspecification as the null hypothesis. I guess I hope that by doing this, we can make our $\chi^2$-tests somewhat relevant. The nice thing about the RMSEA and CI lavaan provides is that together, they may be more informative than a p-value from a $\chi^2$ test.

---

> P.S.: Another approach to latent variable modeling is PLS path modeling. It is a method for SEMs based on OLS regression. It stems from the work of Hermann Wold. Wold was Joreskog's (LISREL) advisor, Joreskog was Muthen's (Mplus) advisor. This is why my title uses _covariance-based SEM_ instead of _latent variable models_ or just _SEMs_.

[^1]: MacCallum, R. C., Browne, M. W., & Sugawara, H. M. (1996). Power analysis and determination of sample size for covariance structure modeling. _Psychological Methods, 1_(2), 130–149. https://doi.org/10.1037/1082-989X.1.2.130
[^2]: I always thought mediocre meant a bad thing, it only means unexceptional, ordinary.
[^3]: I got this unoriginal idea from discussing with one of my colleagues, Menglin Xu. We were chatting around 11 pm in the office and she mentioned the non-central $\chi^2$ distribution in SEMs. Given my interest in non-central distributions in relation to [confidence intervals for effect sizes](https://effect-size-calculator.herokuapp.com/), this idea came to mind.
[^4]: I found out by digging around [this page](https://github.com/cran/lavaan/blob/d7bdae575dd78d5ac518e30f84ccfb57023819af/R/lav_fit_measures.R) and calculating in R. I continued exploring and noticed lavaan using $N$ only happens with ML estimation. If you try WLSMV estimation, lavaan uses $N-1$; and I got very confused on noticing this and emailed one of my factor analysis professors, Paul De Boeck. He replied in an email mentioning Wishart, bias correction and the lavaan manual. From the lavaan manual, lavaan's default for ML estimation is something it refers to as the _normal likelihood approach_. When it does this, it uses $N$. If you change it to the _wishart likelihood approach_ by specifying `likelihood = "wishart"` within the `sem()`, `cfa()` or `lavaan()` functions, it then uses $N-1$. This is only relevant for ML estimation. For other estimation methods, it's $N-1$. I spent a few hours learning about the problem then trying to figure out what was going on, and I got an email reply within minutes of emailing my professor :). [From the lavaan website on Wishart versus Normal](http://lavaan.ugent.be/tutorial/est.html).
