#You will be required to submit: 
#1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis
#3) a code book that describes the variables, the data, and any transformations 
#   or work that you performed to clean up the data called CodeBook.md. 
#4)  You should also include a README.md in the repo with your scripts. 
#   This repo explains how all of the scripts work and how they are connected. 

#You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#clean workspace
rm(list=ls())

setwd("C:\\Users\\daisywa\\SkyDrive\\Data Science\\Getting and Cleaning Data\\Week3")

library(reshape)

#1. Read in all datasets;
X.test  <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)   #2947
X.train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE) #7352
Y.test  <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)   #2947
Y.train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE) #7352
UID.test <-read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)     #2947
UID.train <-read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)   #7352
Activity.label <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE) #6

#figure out mean and std column number;
column.name <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
#mean
col.no <- grep("mean\\()", tolower(column.name$V2)) #backslash to include metacharacter ()
colno.mean <- data.frame(column.name[col.no,], type = "mean")
#std
col.no <- grep("std\\()", tolower(column.name$V2))
colno.std <- data.frame(column.name[col.no,], type = "std")

select.col <- rbind(colno.mean, colno.std)
table(select.col$type) #33 33

#clean up the var names
select.col <- data.frame(select.col, simp_name0 = gsub("\\()", "", select.col$V2))
select.col <- data.frame(select.col, simp_name1 = gsub("\\-", "\\_", select.col$simp_name0))
select.col <- data.frame(select.col, simp_name2 = gsub("^(t)", "Time", select.col$simp_name1))
select.col <- data.frame(select.col, simp_name3 = gsub("^(f)", "Freq", select.col$simp_name2))
select.col <- data.frame(select.col, simp_name = gsub("Mag", "Magnitude", select.col$simp_name3))

select.col <- subset(select.col, select = -c(simp_name0, simp_name1, simp_name2, simp_name3))  #drop the interim
select.col <- select.col[order(select.col$V1),]         #sort by column number

#Request 2.& 4. keep the selected column from train data set & label the column names
Xtrain.select <- X.train[, select.col$V1]
colnames(Xtrain.select) <- select.col$simp_name

Xtest.select <- X.test[, select.col$V1]
colnames(Xtest.select) <- select.col$simp_name

#combine UID, Activity and feature: train and test
train.data <- cbind(UID = UID.train$V1, ActivityID = Y.train$V1, Xtrain.select, data.type = "train")
test.data <- cbind(UID = UID.test$V1, ActivityID = Y.test$V1, Xtest.select, data.type = "test")

#Request 1. combine train and test
full.data0 <- rbind(train.data, test.data)

#DQ
#table(full.data0$data.type)

#Request 4. label activity id
colnames(Activity.label) <- c("ActivityID", "ActivityName")
full.data <- merge(full.data0, Activity.label, by.x = "ActivityID", by.y = "ActivityID", all.x = TRUE)

#Request 5. tidy data
library(plyr)

column.names <- colnames(full.data)
feature.colnames <- column.names[regexpr("mean", column.names) > 0 | regexpr("std", column.names) > 0]
tidy.data <- ddply(full.data, c("UID", "ActivityName"),colwise(mean, feature.colnames))

#export to a text file
write.table(tidy.data,"./tidy.data.txt", sep= "\t", col.names = NA)

#tidy.data1  <- merge(tidy.data, Activity.label, by.x = "ActivityName", by.y = "ActivityName", all.x = TRUE)
#tidy.data1 <- tidy.data1[order(tidy.data$UID),]

#for code book
dim(tidy.data) #180 68 variables
variable.list <- as.data.frame(names(tidy.data))
write.table(variable.list,"./tidy_data_VarList.txt", sep= "\t", col.names = NA)
