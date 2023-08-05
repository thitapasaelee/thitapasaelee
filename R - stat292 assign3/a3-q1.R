score <- c(34, 37, 53, 46, 36, 46, 33, 52,
           52, 56, 50, 57, 55, 51, 44, 40,
           56, 47, 33, 46, 48, 46, 43, 53,
           54, 54, 54, 70, 56, 57, 63, 50)

type <- rep(c(1,2,3,4), each = 8)

# Produce a boxplot of score by type.
boxplot(score ~ factor(type), 
        main = "Distribution of Student Score by Personality Types", 
        xlab = "Personality Types", ylab = "Test Score")

# Carry out a one-way ANOVA of score on teacher.
type.ANOVA <- aov(score ~ factor(type))
summary(type.ANOVA)

# Carry out Levene's test
library(car)

# Needs the "car" package to have been loaded.
leveneTest(score ~ factor(type), center = "mean")

# Scatterplot of residuals vs. fitted values for score on teacher.
plot(x = type.ANOVA$fitted.values, y = type.ANOVA$residuals, 
     main = "Residuals vs. fitted values\n ANOVA on personality types effect data",
     xlab = "Predicted values", ylab = "Residuals")
abline(h = 0, lty = 2)

# Normal Q-Q plot of residuals for teacher effects data.
qqnorm(type.ANOVA$residuals, 
       main = "Normal Q-Q plot of residuals\n ANOVA on personality types effect data")
qqline(type.ANOVA$residuals)