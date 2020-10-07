# Load dplyr

library(dplyr)

# OPTIONAL #
# USE ONLY IF YOU NEED TO DOWNLOAD THE DATA #

# Download the file and save it on  your Working Directory

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./HARdata.zip",method="curl")

#Unzip the data

zipF<-"./HARdata.zip"
outDir<- getwd()
unzip(zipF,exdir=outDir)

# Read and merge the data from the training folder. The colnames for y_train and subject_train where renamed.

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt", header = F)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = F)

  names(y_train) <- "activity"
  names(subject_train) <- "subjectid"
  
  train_df <- cbind(subject_train,y_train, x_train)

# Read and merge the data from the test folder. The colnames for y_test and subject_test where renamed.
  
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt", header = F)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = F)

  names(y_test) <- "activity"
  names(subject_test) <- "subjectid"

  test_df <- cbind(subject_test, y_test, x_test)

# Merge both the data from test and training folders into "har_df"   
    
har_df <- rbind(test_df, train_df)

# Arrange the data, first by the subject id and then by the activity

har_df <- arrange(har_df, subjectid, activity)

# Identify the activities with descriptive activity names

har_df$activity[har_df$activity == 1] <- "walking"
har_df$activity[har_df$activity == 2] <- "walking_upstairs"
har_df$activity[har_df$activity == 3] <- "walking_downstairs"
har_df$activity[har_df$activity == 4] <- "sitting"
har_df$activity[har_df$activity == 5] <- "standing"
har_df$activity[har_df$activity == 6] <- "laying"

# Assign descriptive names to all features (variables) measured during the research.
# In order to prevent issues, all special characters were removed from col names. 

features_names <- read.table("./UCI HAR Dataset/features.txt", header = F)
colnames(har_df) <- c(names(har_df)[1], names(har_df)[2], features_names$V2)
names(har_df) <- gsub(x = names(har_df), pattern = "\\()|\\-", replacement = "")

# Filter the data to display only the measurements on the mean and standard deviation for each measurement.
# grep was used to select only features (variable names) with the words "mean" or "std"

har_df <- select(har_df, 1, 2, as.vector(grep("mean|std", names(har_df))))

# Create an independent tidy data set with the average of each variable for each activity and each subject.

tidy_data <- har_df %>% 
            group_by(subjectid, activity) %>%
            summarize(across(everything(), mean))

# View the means_df. I added this step to get a look at the table before exporting it to the txt file

View(tidy_data)

# Export the table

write.table(means, "tidy_data.txt", row.name=FALSE)

# You should use 
# means_df <- read.table("means.txt", header = TRUE) 
# to properly load the table into R.