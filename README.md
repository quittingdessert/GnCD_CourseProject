Getting and Cleaning Human Activity Recognition Using Smartphones Data Set
==================

Getting and Cleaning Data - Course Project Submission

# Data Background
The accelerometers data was collected from the Samsung Galaxy S smartphone. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Data Files
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. Below is the primary files for this project.

### Dimension tables
* features.txt -  list of all 561 features
* activity_labels.txt: Links the class labels with their activity name, e.g. walking, walking_upstairs, etc.

### Fact tables
* train/subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. The file is available for the train and test data.
* train/X_train.txt: Training set. A 561-feature vector with time and frequency domain variables.
* test/X_test.txt: Test set. A 561-feature vector with time and frequency domain variables.
* train/y_train.txt: Training labels of activities.
* test/y_test.txt: Test labels of activities.

# Objectives
Through a R script, run_analysis.R (see file in the same repo), create two output data sets. Requirements as following:
1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive activity names. 

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Script Summary
run_analysis.R was designed to do following:

1. Read in feature.txt and identify the column numbers and names for meansurements related to mean and standard deviation. Only features with both mean and standard deviation were selected here, i.e. 33 means and 33 standard deviations.

2. Rename features with appropriate names to indicate domain(time or frequency), device(accelerometer, gyroscope),  acceleration signals (body or gravity), Jerk from body signal, and magnitude.

3. Select interested features identified in previous steps from X_train and X_test, and give corresponding column names created from 2.

4. Column bind X_train, Subject_train, and y_train into one data set and repeat the same thing to create one test data set.

5. Row bind the train and test data set created from the previuos step into one full data set.

6. Merge the full data set with activity_labels to obtain activity names.

7. Apply ddply to create tidy data containing average for each subject and activity.

