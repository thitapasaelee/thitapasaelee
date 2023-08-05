uptake <- c(6360, 4250, 5270, 2890, 4430, 3150,
        3690, 4750, 5200, 2370, 1890, 2240,
        250, 480, 310, 410, 300, 430,
        2860, 2390, 3140, 1080, 950, 1200)
pH <- rep(rep(c("acid", "neutral"), each = 3), times = 4)
plant <- rep(c("Alpine pennycress","Bladder campion", "Lettuce","Martin red fescue"), each = 6)

tapply(uptake, plant, mean)

# Create the boxplot
boxplot(uptake ~ factor(plant), xlab = "plant", ylab = "Uptake", main = "Uptake by plants")

# create log boxplot
boxplot(log(uptake) ~ factor(plant), xlab = "plant", ylab = "log Uptake", main = "Uptake by plants")