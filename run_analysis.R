#analysis.R
# 
#Getting and Cleaning Data Course Project
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# start program
closeAllConnections()
rm(list=ls())
library(data.table)
directorydata ="C:/Users/guyma/Documents/Data/UCI HAR Dataset"
setwd(directorydata)

# download and unzip files

if(!file.exists("C:/Users/guyma/Documents/Data/run_analysis.zip"))
{
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile = "C:/Users/guyma/Documents/Data/run_analysis.zip")
        downloaddate = Sys.Date()
        unzip("C:/Users/guyma/Documents/Data/run_analysis.zip", files = NULL, list = FALSE, overwrite = TRUE,
              junkpaths = FALSE, exdir = ".", unzip = "internal",
              setTimes = FALSE)
}

# load files
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

# 1 Merges the training and the test sets to create one data set.
X <- rbind(X_train ,X_test)
y <- rbind(y_train, y_test)
subject <-rbind (subject_train, subject_test)

# 2 Appropriately labels the data set with descriptive variable names. 
names(X) <- features
names(X)<-gsub("^t", "time", names(X))
names(X)<-gsub("^f", "frequency", names(X))
names(X)<-gsub("Acc", "Accelerometer", names(X))
names(X)<-gsub("Gyro", "Gyroscope", names(X))
names(X)<-gsub("Mag", "Magnitude", names(X))
names(X)<-gsub("BodyBody", "Body", names(X))
names(subject)<-c("subject")


#Extracts only the measurements on the mean and standard deviation for each measurement. 
extract_features <- grepl("mean|std", features)
X = X[,extract_features]

#Uses descriptive activity names to name the activities in the data set
y[,2] = activity_labels[y[,1]]
activities <- c("activity_ID","activity")
names(y) <- activities

#tidy data set with the average of each variable for each activity and each subject.
z <- cbind(X,y,subject)
tidyData<-aggregate(. ~subject + activity, z, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = paste(directorydata, "/tidydata.txt", sep=""),row.name=FALSE)
head(tidyData)

