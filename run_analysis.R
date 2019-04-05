#Getting and Cleaning Data Course Project for Coursera
#Author zekePhoenix

#Creat file path URL for download
file_path <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 

download.file(file_path, "projectdata.zip") #download zip file to working directory as "projectdata.zip"

unzip("projectdata.zip") #Extract zip file to working directory

# install 'dplyr' package if nessesary
#install.packages('dplyr') # install 'dplyr' package if nessesary

library(dplyr) # load 'dplyr' package

#read train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#read data descriptions
variable_names <- read.table("./UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subject_all <- rbind(subject_train, subject_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
x_all <- x_all[,selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(y_all) <- "activity"
y_all$activitylabel <- factor(y_all$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_all[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(x_all) <- variable_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(subject_all) <- "subject"
total <- cbind(x_all, activitylabel, subject_all)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarise_each(list(mean))
write.table(total_mean, file = "./UCI HAR Dataset/finaltidydata.txt", row.names = FALSE, col.names = TRUE)



