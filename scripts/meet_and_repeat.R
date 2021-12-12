#author: Eero Hippeläinen
#At 22:15 on 12.12.2021
#Data wranglind script for 6th excersice

# Library of libraries 
library(dplyr)
library(tidyr)
library(ggplot2)

# First, read the data sets.
# Following datacamp naming conventions. I'll carry out wrangling simultaneously.

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')


# Column names
names(BPRS)
names(RATS)
# Look at the structure of BPRS
str(BPRS)
str(RATS)
# print out summaries of the variables
summary(BPRS)
summary(RATS)
glimpse(RATS)

#Both data looks pretty simple experiment data. Measurements over time (weigth for rats) or two different treatments followed several weeks or treatments. What seems to be problem that column names should be changed to as a variable time (T), right?

# Factor treatment & subject from BPRS 
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
str(BPRS)

#you can check if variable is factor with the following function
is.factor(BPRS$treatment)

# Factor variables ID and Group from RATS
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

summary(RATS)
summary(BPRS)

#Here's a good link about gather() function. How data is made "long"
#http://statseducation.com/Introduction-to-R/modules/tidy%20data/gather/
#Basically it's making column names, which in this case represents time, to real variable. So that we can plot of rats as function of time, weight(T)

# Convert BPRS to long form. Then extract the week number. Take a glimpse at the BPRSL data
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
glimpse(BPRSL)

# Convert data to long form. Column names which are weeks are changed to variable. Number of the week is extracted and other variables can now plotted as function of weeks/time! This is super usefull feature, which helps me a alot with my experiment data (I'm a medical physicist!)
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

# Glimpse the data
glimpse(RATSL)

# I think I took serious look already, but let's plot RATS weight as function of time. 
# Usefull link for plotting to start: https://beanumber.github.io/sds192/lab-ggplot2.html#:~:text=Aesthetic%20Mapping%20(%20aes%20),color%20(%E2%80%9Coutside%E2%80%9D%20color)

ggplot(RATSL, aes(x = Time, y = Weight, group = ID)) +
  geom_line(aes(linetype = Group)) +
  scale_x_continuous(name = "Time (days)", breaks = seq(0, 60, 10)) +
  scale_y_continuous(name = "Weight (grams)") +
  theme(legend.position = "top")

# Then write the datasets to data folder:
write.table(RATS,file="data/RATS.csv",sep = ",",row.names = F)
write.table(RATSL,file="data/RATSL.csv",sep = ",",row.names = F)
write.table(BPRS,file="data/BPRS.csv",sep = ",",row.names = F)
write.table(BPRSL,file="data/BPRSL.csv",sep = ",",row.names = F)
