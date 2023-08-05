area <- c(516,469.06,462.25,938.6,1357.15,1773.66,1686.01,1786.29,
          3090.07,3980.12,4424.84,4451.68,4982.89,4450.86,
          5490.74,7476.21,7138.82,9149.94,10133.07,9287.69,13729.13,20300.77,
          24712.72,27144.03,26117.81)
species <- c(3,7,6,8,10,9,10,11,16,9,13,14,12,14,20,22,15,20,22,21,15,24,25,25,24)
head(cbind(area,species))

# Fit a linear regression 
mussle.lm <- lm(species ~ area)
# ANOVA table output for the linear regression.
anova(mussle.lm)

# Summary output for the linear regression.
summary(mussle.lm)

mussel2.lm <- lm(species ~ log(area))
summary(mussel2.lm)

