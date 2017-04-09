#Downloading Files and extracting the contents to the repository##
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./getting and cleaning data assignment/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./getting and cleaning data assignment/Dataset.zip",exdir="./data")


#Combine train tables into the train dataset dataset
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)


#Combine test tables into the test dataset dataset
test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


# merge test and train datasets
dataset <- rbind(train, test)


# Load activity labels + features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract Feature names of Name and Standard Deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#Subset and rename coloumns of datset
dataset <- dataset[featuresWanted]
colnames(dataset) <- c("subject", "activity", featuresWanted.names)

#Use descriptive activity names to name coloumn in dataset
finalDataSet <- merge(dataset, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#Tidy Dataset
tidySet <- aggregate(. ~subjectId + activityId, finalDataSet, mean)


#Write DataSet
write.table(tidySet, "tidySet.txt", row.name=FALSE)



