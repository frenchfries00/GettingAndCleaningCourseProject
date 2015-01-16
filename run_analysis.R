## Read the data (it is numeric), the participants' indices (numeric) and 
## the activity labels (left "character" since it is just a label).
## The data is read both for train and test sets.

X_train<-read.table("./UCI HAR Dataset/train/X_train.txt", colClasses="numeric")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", colClasses="character")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", colClasses="numeric")

X_test<-read.table("./UCI HAR Dataset/test/X_test.txt", colClasses="numeric")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", colClasses="character")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses="numeric")

#Merge train and test data. 
##Since the train and test sets do not intersect, we just use concatenation.
X<-rbind(X_train,X_test)

##We also concatenate labels.
Activity<-rbind(y_train,y_test)
Subject<-rbind(subject_train,subject_test)
##Step 1 of the instructions is complete.


## Read the list of features to be used as columns names
features_names<-read.table("./UCI HAR Dataset/features.txt")

## Give names to columns of the table of features
names(features_names)<-c("index","feature")

## Choose only names containing substrings "mean" or "std".
## It is not clear from the instruction if the last five columns with "Mean" in the name are needed.
## If yes, add the condition  "|grepl("Mean",features_names$feature)"
subset_features<-grepl("mean",features_names$feature)|  grepl("std",features_names$feature)

## Subset data set X to needed columns.
X<-X[,subset_features]
## Step 2 is complete.

## Read the file of activity labels
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",colClasses="character")
## Replace activity numbers by activity names
for (i in 1:nrow(activity_labels)){Activity[Activity==activity_labels[i,1]]<-activity_labels[i,2]}
## Step 3 is complete.

## Original features are called with the use of symbols "-","(",")", which are not good in column names.
## The command make.names replaces special symbols by dots.
## We name columns of X with these correct names.
names(X)<-make.names(features_names[which(subset_features),2],unique=TRUE)
names(Subject)<-"Subject"
names(Activity)<-"Activity"
## Step 4 is complete.

## Now we introduce a complete tidy data set with Subject and Activity attached to the data on "mean"
## and "std" features.
X<-cbind(Subject, Activity,X)

## The data set X is tidy. It contains several observations of many features each,
## for each subject (participant) and each activity.
## It remains to take the average of each feature variable for each activity and each subject.
## The dplur command "summarise_each" is made exactly for that.
library(dplyr)
ANSWER<- tbl_df(X) %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
## Step 5 is complete. It remains to write the data to a file.

## Write the answer to the file "answer.txt". This is the file uploaded to Coursera.
write.table(ANSWER,file="answer.txt", row.name=FALSE)
