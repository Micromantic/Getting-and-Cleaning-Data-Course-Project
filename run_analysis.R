library(dplyr)


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./HARdata.zip",method="curl")

zipF<-"./HARdata.zip"
outDir<- getwd()
unzip(zipF,exdir=outDir)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt", header = F)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = F)

  names(y_train) <- "activity"
  names(subject_train) <- "subjectid"
  
  train_df <- cbind(subject_train,y_train, x_train)

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt", header = F)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = F)

  names(y_test) <- "activity"
  names(subject_test) <- "subjectid"

  test_df <- cbind(subject_test, y_test, x_test)

har_df <- rbind(test_df, train_df)

har_df <- arrange(har_df, subjectid, activity)

har_df$activity[har_df$activity == 1] <- "walking"
har_df$activity[har_df$activity == 2] <- "walking_upstairs"
har_df$activity[har_df$activity == 3] <- "walking_downstairs"
har_df$activity[har_df$activity == 4] <- "sitting"
har_df$activity[har_df$activity == 5] <- "standing"
har_df$activity[har_df$activity == 6] <- "laying"


features_names <- read.table("./UCI HAR Dataset/features.txt", header = F)
colnames(har_df) <- c(names(har_df)[1], names(har_df)[2], features_names$V2)
names(har_df) <- gsub(x = names(har_df), pattern = "\\()|\\-", replacement = "")


har_df <- select(har_df, 1, 2, as.vector(grep("mean|std", names(har_df))))


tidy_data <- har_df %>% 
            group_by(subjectid, activity) %>%
            summarize(across(everything(), mean))

View(tidy_data)

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
