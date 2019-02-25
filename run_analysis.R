library(dplyr)

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")


#For read train data 
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
Sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#For read test data
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
Sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#For read features data (descripcion data)
features<-read.table('./data/UCI HAR Dataset/features.txt')

#For read activity labels 
activity_labels<-read.table('./data/UCI HAR Dataset/activity_labels.txt')

#1 Merges the training and the test sets to create one data set.
#Use rbind function to merge the trainig and the test sets 

X_total<-rbind(X_train, X_test)
Y_total<-rbind(Y_train, Y_test)
Sub_total<-rbind(Sub_train, Sub_test)

#2 Extracts only the measurements on the mean and standard deviation for each measurement.
#Use grep command to get column indexes for variable name contains "mean()" or "std()"
selected_variable<-features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_total<-X_total[,selected_variable[,1]]

#3 Uses descriptive activity names to name the activities in the data set.
#Convert activity labels to characters and add a new column as factor
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]


#4 Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- features[selected_variable[,1],2]

#5 From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable 
#for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./data/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)