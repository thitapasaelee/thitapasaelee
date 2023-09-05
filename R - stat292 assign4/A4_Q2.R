data <- data.frame(
  smoker = c("Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes",
        "No", "No", "No", "No", "No", "No", "No", "No", "No", "No"),
  diabetic = c("Yes", "Yes", "Yes", "Yes", "Yes", "No", "No", "No", "No", "No",
        "Yes", "Yes", "Yes", "Yes", "Yes", "No", "No", "No", "No", "No"),
  sbp = c("<120", "120 - <130", "130 - <140", "140 - <180", ">=180",
        "<120", "120 - <130", "130 - <140", "140 - <180", ">=180",
        "<120", "120 - <130", "130 - <140", "140 - <180", ">=180",
        "<120", "120 - <130", "130 - <140", "140 - <180", ">=180"),
  Hypertensive = c(1, 0, 0, 5, 0, 9, 33, 79, 367, 55, 0, 0, 1, 10, 2, 5, 48, 80, 514, 108),
  Not.Hypertensive = c(1, 0, 0, 0, 0, 715, 459, 274, 94, 3, 1, 2, 1, 1, 0, 547, 405, 295, 123, 2)
)   
print(data)
model <- glm(cbind(Hypertensive, Not.Hypertensive) ~ factor(smoker) * factor(sbp) + factor(diabetic), data = data, family = "binomial")
summary(model)

M1.model <- glm(cbind(Hypertensive, Not.Hypertensive) ~ factor(diabetic) + factor(sbp), data = data, family = "binomial") 
M2.model <- glm(cbind(Hypertensive, Not.Hypertensive) ~ factor(smoker) * factor(sbp) + factor(diabetic),  data = data, family = "binomial") 
# Carry out a model comparison
anova(M1.model, M2.model, test = "Chisq")

# Produce estimate for odds ratios.
exp(M1.model$coefficients)

# Produce 95% confidence intervals corresponding to odds ratios.
exp(confint.default(M1.model))