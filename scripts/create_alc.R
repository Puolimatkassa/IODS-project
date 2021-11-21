#Author: Eero Hippeläinen
#Date: 20.11.2021
#This script is for data wrangling of student performance and alcohol consumption. 
#The original data set can be found here: https://archive.ics.uci.edu/ml/datasets/Student+Performance 
#Script was exercise on the IODS-course. I have decided to put it in /script folder.. because it's my habit. Running numbers in comments refers to data wrangling exercise steps. Hopefully this helps the reviewer :).

#3. Read data to R
studentmat <- read.csv("data/student-mat.csv",sep = ";")
studentpor <- read.csv("data/student-por.csv",sep = ";")

#3. structure and dimensions of both data sets
dim(studentmat)
str(studentmat)
dim(studentpor)
str(studentpor)

#4. Because I'm running bit late, I'll copy&paste most of the following data wrangling script from here: https://raw.githubusercontent.com/rsund/IODS-project/master/data/create_alc.R. Which was given in in the exercise. I won't do it blindly so some comments will be between the lines.

#Fist I need to create new data frames, because I used different ones during reading.
por <- studentpor
math <- studentmat

# Define own id for both datasets
# This is probably very good habit. This way both datasets have unique values and double check afterwards is easier.
library(dplyr)
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

# Which columns vary in data sets
# This is trivial. Have a list of columns which we don't need
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por_id),free_cols)

#4. continues: Personally, using of %>% operator needs more practice. 
pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))
str(pormath_free)

# Combine datasets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!
# 
#5. This is almost magic :D. I did not find much about .dots=join_cols input.. If you know more, please let me know. Otherwise it's pretty straight forward. 
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
   n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be successful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  #inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  #inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  
  # Calculate other required variables  
  # 
  #6.  Here are my comments again: This was asked
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )
str(pormath)
dim(pormath)
write.csv(pormath,file="data/student_alc.csv",row.names = FALSE)

#end of the script!
#22.11.2021 EH