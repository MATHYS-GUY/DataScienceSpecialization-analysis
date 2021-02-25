---
title: "Analysis Getting and Cleaning Data Course Project"
author: "Guy Mathys"
date: "25-2-2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
# Readme overview
- How the script works
- Codebook

# How the script works (analysis.R)
- Getting and Cleaning Data Course Project
-  Merges the training and the test sets to create one data set.
-  Extracts only the measurements on the mean and standard deviation for each measurement. 
-  Uses descriptive activity names to name the activities in the data set
-  Appropriately labels the data set with descriptive variable names. 
-  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## start program
```{r echo=TRUE, comment = ""}
#closeAllConnections()     works in R , not in Knit
rm(list=ls())
library(data.table)
directorydata ="C:/Users/guyma/Documents/Data/UCI HAR Dataset"
setwd(directorydata)
```
## download and unzip files
```{r echo=TRUE, comment = ""}


if(!file.exists("C:/Users/guyma/Documents/Data/run_analysis.zip"))
{
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile = "C:/Users/guyma/Documents/Data/run_analysis.zip")
        downloaddate = Sys.Date()
        unzip("C:/Users/guyma/Documents/Data/run_analysis.zip", files = NULL, list = FALSE, overwrite = TRUE,
              junkpaths = FALSE, exdir = ".", unzip = "internal",
              setTimes = FALSE)
}
```
## load files
```{r echo=TRUE, comment = ""}

filename <- paste(directorydata, "/activity_labels.txt",sep ="")
activity_labels <- read.table(file=filename)[,2]
filename <- paste(directorydata, "/features.txt",sep ="")
features <- read.table(file=filename)[,2]
filename <- paste(directorydata,"/train/X_train.txt",sep="")
X_train  <- read.table(file=filename)
filename <- paste(directorydata,"/train/y_train.txt",sep="")
y_train  <- read.table(file=filename)
filename <- paste(directorydata,"/train/subject_train.txt",sep="")
subject_train <-read.table(file=filename)
filename <- paste(directorydata,"/test/X_test.txt",sep="")
X_test   <- read.table(file=filename)
filename <- paste(directorydata,"/test/y_test.txt",sep="")
y_test   <- read.table(file=filename)
filename <- paste(directorydata,"/test/subject_test.txt",sep="")
subject_test <- read.table(file=filename)
```
## Merges the training and the test sets to create one data set
```{r echo=TRUE, comment = ""}
X <- rbind(X_train ,X_test)
y <- rbind(y_train, y_test)
subject <-rbind (subject_train, subject_test)
```
## Appropriately labels the data set with descriptive variable names
```{r echo=TRUE, comment = ""}
names(X) <- features
names(X)<-gsub("^t", "time", names(X))
names(X)<-gsub("^f", "frequency", names(X))
names(X)<-gsub("Acc", "Accelerometer", names(X))
names(X)<-gsub("Gyro", "Gyroscope", names(X))
names(X)<-gsub("Mag", "Magnitude", names(X))
names(X)<-gsub("BodyBody", "Body", names(X))
names(subject)<-c("subject")

```
## Extracts only the measurements on the mean and standard deviation for each measurement
```{r echo=TRUE, comment = ""}
extract_features <- grepl("mean|std", features)
X = X[,extract_features]
```
## Uses descriptive activity names to name the activities in the data set
```{r echo=TRUE, comment = ""}
y[,2] = activity_labels[y[,1]]
activities <- c("activity_ID","activity")
names(y) <- activities
```
## tidy data set with the average of each variable for each activity and each subject.
```{r echo=TRUE, comment = ""}

z <- cbind(X,y,subject)
tidyData<-aggregate(. ~subject + activity, z, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = paste(directorydata, "/tidydata.txt", sep=""),row.name=FALSE)
head(tidyData)
```
# Code book

## adaptable Variables

-directorydata : -directory where the data is read and writen
                 -is used for setting the working directory
- filename : the directory and file used for writing and reading

## from files
- activity_labels from file activity_labels.txt
- features        from file features.txt
- X_train         from file X_train.txt
- y_train         from file y_train.txt
- subject_train   from file subject_train.txt
- X_test          from file X_test.txt
- y_test          from file y_test.txt
- subject_test    from file subject_test.txt

## new variables in this program
- X is X_train +  X_test added names from features , limited to relevant columns
- y is y_train +  Y_test added name
- subject is  subject_train + subject_test
- z is x +y
- tidyData result based on z

                


