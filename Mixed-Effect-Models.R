# Load required libraries
library(tidyverse)
library(lme4)
library(ggplot2)
library(Hmisc)
library(jtools)
# Task 1: Data Exploration

?sleepstudy

# a. Load the "sleepstudy" dataset

data("sleepstudy")
data <- tibble(sleepstudy)
Hmisc::describe(data)

#In this case I will treat the time variable (Days) as quantitative for modelling, but I will temporarily use it as factor for better visualizations

data$Days <- factor(data$Days,levels = c(0:9))
head(data)

# b. Explore the structure of the dataset
str(data)

# c. Visualize the data

ggplot(data, aes(x = Days, y = Reaction)) +
  geom_point() + 
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


# Task 3: Fit an adequate Model(s)

ml1 <- lmer(Reaction ~ Days + (Days |Subject), data = data)
summ(ml1)
plot(ml1)
#This model has random intercepts for each subject.

ml2 <- lmer(Reaction ~ Days + (1|Subject) + (0 + Days | Subject), data = data)
summ(ml2)
plot(ml2)

#This model has random intercepts and slopes for each subject.
anova(ml1, ml2)

#The results of the ANOVA test provide evidence of the model adequacy. The test indicates if there is a significant difference between the log-likelihood values of the models, which can indicate the need for a more complex model

# Task 4 : Interpret the results.
#The mixed effects linear regression model 1 has been applied to predict the Reaction time of a person in response to a stimulus.The fixed effects of this model include the intercept, Days, and Subject variables. The intercept term represents the average reaction time of a person. The Days variable indicates the relationship between the number of days since the subject began training and the reaction time. The Subject variable is a random effect term, representing the unique effects of different subjects in the experiment.

#he fixed effects in model2 are the intercept, Days, and their interaction with each other.  The intercept represents the average Reaction time for the entire sample, while the Days effect represents the average change in Reaction time per unit increase in Days. The random effects in this model are grouped by both "Group" and "Subject".


#Task 5 : Residual Analysis
ggplot(sleepstudy, aes(x = Days, y = residuals(ml1))) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Residuals vs Days (ml1)", 
       x = "Days", 
       y = "Residuals")
#this residual analysis indicates that the model provides a reasonably good fit to the data.

ggplot(sleepstudy, aes(x = Days, y = residuals(ml2))) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Residuals vs Days (ml2)", 
       x = "Days", 
       y = "Residuals")
# This residuals plot provides a clear indication that the model assumptions may be satisfied, and the model is likely to provide accurate predictions.
