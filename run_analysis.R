library(dplyr)
setwd("~/Desktop/coursera/Datascience cursus 3/data/UCI HAR Dataset")
train<- read.table("./train/X_train.txt")
trainvariable <- read.table("./features.txt")
variable <- trainvariable[,2]
## add the variable names as 561 colnames to the train dataframe
colnames(train)<- variable
##read subjects and activities
subjecttrain<- read.table("./train/subject_train.txt")
activitytrain<- read.table("./train/y_train.txt")
##select only mean and standard deviation
trainingkort<- train[grepl("[Mm]ean|std", names(train))]
## add activities and subjects and a column to indicate trainig or test
merge3<- cbind(activitytrain, trainingkort)
totaltrain<-cbind(subjecttrain,merge3)
## adding a column for "training" or "testing" in case that is needed later
totaltrain$set<- "train"
names(totaltrain)[1]<- "subject"
names(totaltrain)[2]<- "activity" 
## Now the same for the test file
test<- read.table("./test/X_test.txt")
colnames(test)<- variable
subjecttest<- read.table("./test/subject_test.txt")
activitytest<- read.table("./test/y_test.txt")
testingkort<- test[grepl("[Mm]ean|std", names(test))]
merge4<- cbind(activitytest, testingkort)
totaltest<-cbind(subjecttest,merge4)
totaltest$set<- "test"
names(totaltest)[1]<- "subject"
names(totaltest)[2]<- "activity"
## now merging the 2 dataframes
totaldata<- rbind(totaltrain, totaltest)
## now replace the values in the activity column with descriptive values
totaldata$activity[totaldata$activity == "1"] <- "walking"
totaldata$activity[totaldata$activity == "2"] <- "walking_upstairs"
totaldata$activity[totaldata$activity == "3"] <- "walking_downstairs"
totaldata$activity[totaldata$activity == "4"] <- "sitting"
totaldata$activity[totaldata$activity == "5"] <- "standing"
totaldata$activity[totaldata$activity == "6"] <- "laying"

##Sort the dataframe on 1. subject and 2. activity
Totaldatasorted<- arrange(totaldata, subject, activity)
## make last column the first column (train/test)
TSD<- Totaldatasorted[,c(ncol(Totaldatasorted),1:(ncol(Totaldatasorted)-1))]

## Make 2nd independent tidy data set with averages for each activity
## and each subject. According to instruction by mentor on the forum this can be
## a wide format dataframe with subject&activity combined.

# Add column with merged subject and activity
TSD$id=paste(TSD$subject, TSD$activity, sep="_")
# remove 3 columns
datafinal<- TSD
datafinal$subject <- NULL
datafinal$set <- NULL
datafinal$activity <- NULL
## move pasted column to 1st column
datafinal2<- datafinal[,c(ncol(datafinal),1:(ncol(datafinal)-1))]

# aggregate to average the variables for each activity and subject
groupdata<- aggregate(datafinal2[,2:87], list(datafinal2$id), mean)
## the sorting of the id changed because of this. Change back.
library(gtools)
sortedgroupdata<- groupdata[mixedorder(groupdata$Group.1),]
##change columnvariables to rownames
tidydata <- data.frame(sortedgroupdata[,-1], row.names=sortedgroupdata[,1])


