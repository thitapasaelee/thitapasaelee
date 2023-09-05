# Store the data in vectors for the variables.
midpoint.sbp <- c(100, 125, 135, 160, 200)
range.sbp <- c("< 120", "120 - < 130","130 - < 140", "140 - < 180", ">= 180")
hypertensive <- c(15, 81, 160, 896, 165) 
not.hypertensive <- c(1264, 866, 570, 218, 5)

# Fit the logistic regression model.
logistic.regression <- glm(cbind(hypertensive, not.hypertensive) ~ midpoint.sbp, family =
                                "binomial")
summary(logistic.regression)

p.value <- pchisq(14.997, df = 3, lower.tail = FALSE)
p.value
# deviance and residual degrees of freedom
G.2 <- logistic.regression$deviance
residual.df <- logistic.regression$df.residual 
# Goodness-of-fit p-value. 
p_value <- pchisq(q = G.2, df = residual.df, lower.tail = FALSE)
p_value

logistic.regression$fitted.values

# ------
# Produce estimate for odds ratios.
exp(logistic.regression$coefficients)

# Produce 95% confidence intervals corresponding to odds ratios.
exp(confint.default(logistic.regression))

# Produce predicted probabilities of a heart attack for someone smoking 25 cigarettes per day.
predict(logistic.regression, newdata = data.frame(midpoint.sbp = 125), type = "response")