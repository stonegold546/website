hsb <- read.csv("datasets/hsb_comb_full.csv")
names(hsb)
# Let's go with the first school, and the first 5 student-level variables
hsb <- hsb[hsb$schoolid == hsb$schoolid[1], 1:5]
summary(hsb)
# Mathach, ses and female seem to have some variability
# Let's predict math achievement using female (dummy), ses (continuous)
lm(mathach ~ female + ses, hsb)
