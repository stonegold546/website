+++
# Date this page was created.
date = "2016-04-27"

# Project title.
title = "Effect size web application"

# Project summary to display on homepage.
summary = "A web-based application for effect sizes and their confidence intervals"

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "projects/es-app.png"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["software"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = true

# Optional featured image (relative to `static/img/` folder).
[header]
image = "projects/es-app-full.png"
caption = "Screenshot of application homepage :smile:"

+++

This is a calculator I originally built as a [spreadsheet](/misc/others/cohens_d_calculator.xls) for the Introduction to Educational Statistics class I served as lab instructor/teaching assistant for. I initially intended that it focus only on the Cohen's _d_ family of effect sizes.

You can find the calculator here: https://effect-size-calculator.herokuapp.com/.

Currently, it calculates the following effect sizes, some of them with confidence intervals:

- **Cohen's _d_ family**: One-sample _t_-test; Independent-samples _t_-test; Paired samples _t_-test

- **Binary outcomes**: Odds-ratio; Relative-risk/risk-ratio; Absolute risk; Number Needed to Treat

- **ANOVA**: $(\eta^{2}_p; \omega_{p}^{2})$

- **Regression (OLS)**: $R^{2}$ confidence intervals

- **Multilevel modeling**: Intracluster/Intraclass correlation coefficient (ICC); Snijders & Bosker $R^{2}$; Nakagawa & Schielzeth $R^{2}$

There's a lot more information on the [application's Github page](https://github.com/stonegold546/cohens_d_calculators).

The multilevel component relies on a Python API I developed, this is its [Github](https://github.com/stonegold546/py_cohens_d_calculators_gae).
