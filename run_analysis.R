## Read the data (it is numeric), the participants' indices (numeric) and 
## the activity labels (left character since it is just a label).
## The data is read both for train and test sets.

X_train<-read.table("./UCI HAR Dataset/train/X_train.txt", colClasses="numeric")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", colClasses="character")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", colClasses="numeric")

X_test<-read.table("./UCI HAR Dataset/test/X_test.txt", colClasses="numeric")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", colClasses="character")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses="numeric")


## Read the list of features to be used as columns names
features_names<-read.table("./UCI HAR Dataset/features.txt")

## Read the activity labels
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",colClasses="character")

## Give names to columns of the table of features
names(features_names)<-c("index","feature")

## Choose only names containing substrings "mean", "std", or "Mean".
## It is not clear from the instruction if the last five columns with "Mean" in the name are needed.
## If not, just remove the second condition.
subset_features<-grepl("mean",features_names$feature)|
                 grepl("Mean",features_names$feature)|
                 grepl("std",features_names$feature)

## Subsetting data sets to needed columns.
## I do it before merging data sets to save memory and time.
X_train_cleaned<-X_train[,subset_features]
X_test_cleaned<-X_test[,subset_features]

## Original features are called with the use of symbols "-","(",")", which are not good in column names.
## The command make.names replaces special symbols by dots.
## We name columns of both data sets with these correct names
names(X_train_cleaned)<-make.names(features_names[which(subset_features),2],unique=TRUE)
names(X_test_cleaned)<-make.names(features_names[which(subset_features),2],unique=TRUE)

## Give names to the vectors of participants and activities
names(subject_train)<-"Participant"
names(subject_test)<-"Participant"
names(y_train)<-"Activity"
names(y_test)<-"Activity"

## Make tables with columns "Participant","Activity", and the rest of data
X_train_cleaned<-cbind(subject_train,y_train,X_train_cleaned)
X_test_cleaned<-cbind(subject_test,y_test,X_test_cleaned)

## At last, merge the train and test sets
X<-merge(X_train_cleaned,X_test_cleaned,all=TRUE)

## Remove bulky data sets which are not more needed. Less bulky sets are left in the environment.
rm("X_train_cleaned","X_test_cleaned","X_test","X_train")

## Renaming activity labels to activity names. This is why we have read the file with activity labels.
for (i in 1:nrow(activity_labels)){X$Activity[X$Activity==activity_labels[i,1]]<-activity_labels[i,2]}

## Now the data set X is tidy. For each participant and each activity, it contains 
## several observations of many features each.
## Everything is properly named.
## It remains to take the average of each feature variable for each activity and each participant.
## The dplur command "summarise_each" is made exactly for that.
library(dplyr)
ANSWER<- tbl_df(X) %>% group_by(Participant,Activity) %>% summarise_each(funs(mean))

##Write the answer to the file "answer.txt". This is the file uploaded to Coursera.
write.table(ANSWER,file="answer.txt", row.name=FALSE)
