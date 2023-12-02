# Load required libraries
library(tidyverse)
library(lme4)
library(ggplot2)
install.packages("jtools")
library(jtools)
# Task 1: Data Exploration

?sleepstudy

# a. Load the "sleepstudy" dataset

data("sleepstudy")
data <- tibble(sleepstudy)
data
#In this case I will treat the time variable (Days) as quantitative for modelling, but will temporarily use it as factor for better visualizations
data$Days <- factor(data$Days,levels = c(0:9))
head(data)
# b. Explore the structure of the dataset
str(data)

# c. Visualize the data

ggplot(data, aes(x = Days, y = Reaction)) +
  geom_point() + 
  geom_smooth(method = "lm") +
  labs(title = "Reaction Times over Days",
       x = "Days",
       y = "Reaction Time")

# Task 2: Descriptive Statistics.
#a. Compute and report summary statistics for the key variables.

summary(data)

#b. Create visualizations (e.g., histograms, boxplots) to better understand the distribution of reaction times over different days
ggplot(data, aes(x = Days, y = Reaction)) + 
  geom_boxplot(fill = 'white', color = "orange") + 
  labs(title = "Boxplot of Reaction Times over Days", 
       x = "Days", 
       y = "Reaction Time")


day_mean <- data %>% 
  group_by(Days) %>% 
  summarise(Reaction = mean(Reaction))

ggplot(data, aes(x = Days, y = Reaction, color=Days, fill=Days)) +
  geom_point() +
  geom_bar(data = day_mean ,stat = "identity", alpha = .1) + 
  theme_minimal()

# Task 3: Fit an adequate Model(s)

ml1 <- lmer(Reaction ~ Days + (1 |Subject), data = data)
summ(ml1)
plot(ml1)
#This model has random intercepts for each subject.
ml2 <- lmer(Reaction ~ Days + (1|Subject) + (0 + Days | Subject), data = data)
summ(ml2)
plot(ml2)

anova(ml1, ml2)
# Task 4 : Interpret the results.

#Task 5 : Residual Analysis

