+++
date = "2017-09-21T10:00:00"
draft = false
tags = ["missing-data", "little's mcar test", "small-samples"]
title = "Little's MCAR test at different sample sizes"
math = true
+++

{{% alert note %}}
Little's MCAR test is unable to tell data that are MCAR from data that are MAR in small samples, but maintains the nominal error rate when null is true across a wide range of sample sizes.
{{% /alert %}}

I just found out about the R [simglm package](https://cran.r-project.org/web/packages/simglm/simglm.pdf) and decided to do a small simulation to test Little's MCAR test[^1] under different sample sizes. I could have investigated heteroskedasticity in linear regression instead, and I probably will in the future. I was able to find some examples of researchers using Little's MCAR test at small sample sizes, so I ran a toy simulation.

![Data are MCAR](/img/posts/little_mcar/zoom_in.png)
![Data are MAR](/img/posts/little_mcar/zoom_in_mar.png)

And this is the [script I used](/misc/scripts/little_sim.R), the underlying regression is near perfect (no multicollinearity).

[^1]: Little, R. J. A. (1988). A Test of Missing Completely at Random for Multivariate Data with Missing Values. _Journal of the American Statistical Association, 83_(404), 1198. https://doi.org/10.2307/2290157
