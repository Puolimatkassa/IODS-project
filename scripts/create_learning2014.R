# By Eero Hippeläinen
# Started editing:8.11.2021
# Reads data from http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt
# Does some simple data wrangling to creat 'analysis_dataset'

#-----------------------------1.part------------------------------#
# Let's have a look at the help
?read.table

# Read the file from the web to variable 'rawdata'. 
# The data has header, so header = TRUE. Data is tabular separated thus separator = "\t"
learn2014 <- read.table('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt',header=TRUE,sep="\t")

# Structure of the data
str(learn2014)

# and dimensions
dim(learn2014)

#-------------------------end-1.part------------------------------#

#-----------------------------2.part------------------------------#
# for data handling we need a library, let's see what we have
library()

# It seems that dplyr is not on my computer. Let's install it
install.packages("tidyverse")

# and then load the dplyr library
library(dplyr)

# Let's make variables with includes questions related to deep, surface and statetic questions, respectively


deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#Create new rows to learn2014 which include results from from collected questions. Results are scaled by taking mean
deep_columns <- select(learn2014, one_of(deep_questions))

# let's have a look at the data
head(deep_columns)
# Scale it by taking mean, and also creating a new column to learn2014
learn2014$deep <- rowMeans(deep_columns)

str(learn2014)

# Then do it for other combinatory questions 
surface_columns <- select(learn2014, one_of(surface_questions))
learn2014$surf <- rowMeans(surface_columns)

strategic_columns <- select(learn2014,one_of(strategic_questions))
learn2014$stra <- rowMeans(strategic_columns)


# Let's have the following columns: gender, age, attitude, deep, stra, surf and points
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset: analysis_dataset
analysis_dataset <- select(learn2014,one_of(keep_columns))

analysis_dataset <- filter(analysis_dataset,Points > 0)
# Let's have a look what we got
head(analysis_dataset)
# What is the minimum value of Points column?
min(analysis_dataset$Points)
# Structure of the wrangled dataset
str(analysis_dataset)

# Success!
#'data.frame':	166 obs. of  7 variables:
#'$ gender  : chr  "F" "M" "F" "M" ...
#'$ Age     : int  53 55 49 53 49 38 50 37 37 42 ...
#'$ Attitude: int  37 31 25 35 37 38 35 29 38 21 ...
#'$ deep    : num  3.58 2.92 3.5 3.5 3.67 ...
#'$ stra    : num  3.38 2.75 3.62 3.12 3.62 ...
#'$ surf    : num  2.58 3.17 2.25 2.25 2.83 ...
#'$ Points  : int  25 12 24 10 22 21 21 31 24 26 ...
#-------------------------end-2.part------------------------------#

#-----------------------------3.part------------------------------#
# Set a workin direcotry using: setwd("<dir>")

# Let's write a comma separate datafile. Tip: Remove row names with row.names=FALSE
# This will keep the data in original shape
write.csv(analysis_dataset,file="data/learning2014.csv",row.names = FALSE)

test1 <- read.csv("data/learning2014.csv")
str(test1)

# Let see if data frames are equal after reading and writing
all_equal(test1,learning_data)

#Without row.names = FALSE we will get followin data after reading:
# I got new column X
#'data.frame':	166 obs. of  8 variables:
#$ X       : int  1 2 3 4 5 6 7 8 9 10 ...
#
write.table(analysis_dataset,file="data/learning2014_2.csv",sep = ",",row.names = F)

test2 <- read.table("data/learning2014.csv",sep=",",header = TRUE)
str(test2)
#It works!
#-------------------------end-3.part------------------------------#