
# Read the “Human development” and “Gender inequality” datas into R
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the dataset
dim(hd)    #Find the dimensions (195 obs. of 8 variables)
dim(gii)   #195 obs. of 10 variables
str(hd)         #Find the structure
str(gii)
summary(hd)    #View summary of all variables
summary(gii)  

# Look at the meta files and rename the variables
# The meta files can bee seen here: http://hdr.undp.org/en/content/human-development-index-hdi and http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf
head(hd)
names(hd) <- c('hdirank', 'country', 'hdi', 'birth', 'educ_exp', 'educ_mean', 
               'gni', 'gni-hdi')
head(hd) # check if OK

head(gii)
names(gii) <- c('giirank', 'country', 'gii', 'mmr', 'abr', 'pr', 
                'edu2F', 'edu2M', 'labF', 'labM')
head(gii) # check

# Mutate the “Gender inequality” data and create two new variables
gii$edu_ratio <- gii$edu2F/gii$edu2M
gii$lab_ratio <- gii$labF/gii$labM

# Join together the two datasets using the variable Country as the identifier
human <- merge(x=hd,y=gii,by="country",all=FALSE) #inner join
dim(human)   #check the dimension: 195 observations and 19 variables

write.csv(human,"C:/Users/Lenovo/Documents/R/IODS-project/data/human.csv", row.names = FALSE)
