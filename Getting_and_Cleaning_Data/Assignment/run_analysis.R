# Run analysis script
# Load libraries
library(data.table)
library(dplyr)

# Download data if .zip file does not exist and unzip
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("data.zip")){
    download.file(url, destfile = "data.zip",method = "curl")
    unzip("data.zip")
}

# Load activity labels
actLabels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", header=FALSE)
names(actLabels) <- c("tag", "activity") # Assign variable names

# Load list of features 
Features <- read.csv2("UCI HAR Dataset/features.txt", sep=" ", header = FALSE)
names(Features) <- c("feature_label", "feature_name") # Rename columns

# ###########
# Load test data set
# List of subjects
testSubject <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
names(testSubject) <- "subject" # Rename column

# List of activity labels for test dataset
testLabels <- read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE)
names(testLabels) <- "tag" # Rename column
testLabels$activity <- actLabels$activity[testLabels[,]] # Append activities as var names
testLabels$subject <- testSubject$subject # Append list of subject

# Load 561-feature vector with data for test dataset
testVar <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
names(testVar) <- Features$feature_name # Rename the 561 columns with features names

# Load dplyr to combine two tests datasets efficiently
test <- bind_cols(testLabels, testVar) # Combine all test data into a single data.frame()

# #########
# Load train data set
# List of subjects
trainSubject <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
names(trainSubject) <- "subject" # Rename column

# List of activity labels for train dataset
trainLabels <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE)
names(trainLabels) <- "tag" # Rename column
trainLabels$activity <- actLabels$activity[trainLabels[,]] # Append activities as var names
trainLabels$subject <- trainSubject$subject # Append list of subject

# Load 561-feature vector with data for train dataset
trainVar <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
names(trainVar) <- Features$feature_name # Rename the 561 columns with features names

# Load dplyr to combine two trains datasets efficiently
train <- bind_cols(trainLabels, trainVar) # Combine all train data into a single data.frame()

# ############
# Merge the two data sets using the data.table package for efficiency
dtAllData <- rbindlist(list(test,train))

# ############
# Extract "*mean*" and standard deviation "*std*" from columns names 
meanNames <- data.frame(indx = grep("mean", Features$feature_name), 
        names = Features$feature_name[grep("mean", Features$feature_name)])
stdNames <- data.frame(indx = grep("std", Features$feature_name), 
        names = Features$feature_name[grep("std", Features$feature_name)])
meanStdNames <- full_join(meanNames,stdNames)

# Extract mean and std data
dtMeanStd <- data.frame(dtAllData[, c("tag", "activity", "subject"), with=FALSE], 
                    dtAllData[, meanStdNames[,2], with=FALSE])

# Aggregate data statistics: calculate average of each variable 
# for each activity and each subject. 
aggrData <- aggregate(dtMeanStd[, 4:ncol(dtMeanStd)],
                by=list(subject = dtMeanStd$subject, 
                tag = dtMeanStd$tag, 
                activity = dtMeanStd$activity), 
                mean)

# Saving tidy data set to file
