# GettingAndCleaningCourseProject
This is the course project for the "Getting and Cleaning Data" course from Coursera.

In this project, the goal is collect, work with, and clean the data set

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip .

Here is its complete description:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones .

The instruction was:

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This all is done in the attached code. It is supposed that an unzipped subdirectory "UCI HAR Dataset" is in our working directory.

First we read the 3 files from each of the subdirectories "train" and "test". These files correspond to 

-labels of participants from 1 to 30, file "subject_*.txt",

-labels of activities from 1 to 6, file "y_*.txt",

-measured data in 561 columns, file "X_*.txt".

The tables we get are named similarly to data files.

1. Since the train and the test data sets not not intersect, by the next step we concatenate the data "X", "y" and "subject" in the order (train, test) by rbind. The new tables are called "X", "Activity" and "Subject".
Step 1 is complete.

2. Now we read the list of features "features.txt" corresponding to columns of the data sets. Since we need only columns corresponding to mean and standart deviation, we define a boolean vector "subset_features" corresponding to names containing "mean" or "std", using the grepl function.
Then we subset columns of X according to that vector. Step 2 is complete.

3. Read the list of activities "activity_labels.txt" and replace the entries of the table "Activity" from a label to an activity name from that list. Step 3 is complete.

4. Name the columns of X according to the features with TRUE values in "subset_features". To do it properly, we replace forbidden symbols "-", "(" and ")" by dots using the command "make.names". 

5. We bind the tables "Subject", "Activity" and "X" into one data set "X", and then use the dplyr command "summarise_each" to get exactly the needed data set called "ANSWER".

6. It remains to write this data set to a file answer.txt submitted to Coursera.
