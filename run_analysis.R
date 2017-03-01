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
## and each subject
