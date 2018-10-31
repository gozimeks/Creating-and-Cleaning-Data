#Script run_analysis.R
#Author Goziem Moemeka
#Date 10/26/2018

#Credits
# Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and 
# Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass 
# Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living 
# (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

#Modifications
############################################################################################
library(dplyr)
library(data.table)
library(tidyverse)

setwd <- ("/Users/goziemm/Google Drive/Coursera/Getting_cleaning_data/project")
datadirectory <- ("./UCI HAR Dataset")

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
variables <- read.table("./UCI HAR Dataset/features.txt")

#subset variable names from features file.
#create a vector to use to change column names. This is needed to make it easier to identify 
#columns for what they are
cvector <- gsub("-","",variables$V2) #2 column file. Second is all we need
cvector <- gsub("[()]","",cvector)
cvector <- gsub(",","", cvector)


#Get dataset. The data contains accelator and gyroscope observations on walking, sleeping, 
#walking upstairs, walking downstairs, sitting, standing and layer in subjects.

#work on test files
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")


#load test and train data, and select the needed features

#work on training files
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt") #test dataset
testlabel <- read.table("./UCI HAR Dataset/test/y_test.txt")
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Add label and subject columns plus rename all columns
newtestdata <- cbind(testsubject,testlabel,testdata)
colnames(newtestdata) <- c("subject", "activity", cvector) 

#pair down to test data mean and std columns
subtest <- grep("mean|std|subject|activity", colnames(newtestdata) ,value=TRUE)
myvars <- names(newtestdata) %in% c(subtest) ; newtestdata <- newtestdata[myvars]


#work on training files

traindata <- read.table("./UCI HAR Dataset/train/X_train.txt") #training dataset
trainlabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Add label and subject columns plus rename all columns
newtraindata <- cbind(trainsubject,trainlabel,traindata)
colnames(newtraindata) <- c("subject", "activity", cvector) 

#pair down to training data mean and std columns
subtrain <- grep("mean|std|subject|activity", colnames(newtraindata) ,value=TRUE)
myvars <- names(newtraindata) %in% c(subtrain) ; newtraindata <- newtraindata[myvars]


#combine both datasets. Both have identical definations so a simple "all=TRUE" will suffice
combineddata <- merge(newtraindata, newtestdata, all=TRUE) #should be 2947 combined records

#to facilitate aggregation we coerce activity to factor
combineddata$activity <- factor(combineddata$activity, levels = activity_labels[, 1], labels = activity_labels[, 2])

#Create Tidy data with averages per observation
Dhold <- aggregate(combineddata[,3:ncol(combineddata)], list(combineddata$subject,combineddata$activity),mean, na.rm=TRUE)
colnames(Dhold) [1:2]<- c("subject", "activity") 

#write tidy data to csv file.
write.csv(Dhold, file="summarydata.csv", row.names = FALSE)


#End






