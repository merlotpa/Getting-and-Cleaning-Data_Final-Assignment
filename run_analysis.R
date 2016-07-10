# One of the most exciting areas in all of data science right now is wearable computing - see for example this article .
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
# The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
# A full description is available at the site where the data was obtained:
#         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Here are the data for the project:
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# This script does the following:
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement.
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names.
#   5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#      each variable for each activity and each subject.

library("data.table")
library(stringr)

## 0. download the data if not present already and load it
mainDir = getwd()
rawDir = "rawData"
dir.create(file.path(mainDir, rawDir))
setwd(file.path(mainDir, rawDir))

destfile <- file.path(getwd(), "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
if(!file.exists(destfile)){
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        res <- tryCatch(download.file(url, destfile),
                        error=function(e) 1)
}
unzip("getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", exdir = "./")
setwd(file.path(mainDir))
dataDir <- file.path(mainDir,rawDir, "UCI HAR Dataset")

# Measurement/Features
# 'features_info.txt' describes the origin of the measurements and how they are processed into the list of features  
# 'features.txt' gives the index of every features and we can deduce from the name which ones correspond to the mean 
#  and standard deviation of the measurements.
dt_features <- fread(file.path(dataDir, "features.txt"))
setnames(dt_features, names(dt_features), c("featureIndex", "featureName"))

# Activity labels
# 'activity_labels.txt'
dt_activity_labels <- fread(file.path(dataDir, "activity_labels.txt"))
setnames(dt_activity_labels, names(dt_activity_labels), c("activityIndex", "activity"))

#  Training/Test sets.
# 'train/X_train.txt' and 'test/X_test.txt'
dt_X_train <- fread(file.path(dataDir, "train", "X_train.txt"))
dt_X_test  <- fread(file.path(dataDir, "test" , "X_test.txt" ))

# Training/Test labels files
# 'train/subject_train.txt' and 'test/subject_test.txt'
# Each row identifies the subject who performed the activity for each window sample.
dt_y_train <- fread(file.path(dataDir, "train", "y_train.txt"))
dt_y_test  <- fread(file.path(dataDir, "test" , "y_test.txt" ))

# Training/Test Subject files
# 'train/subject_train.txt' and 'test/subject_test.txt'
# Each row identifies the subject who performed the activity for each window sample.
dt_subject_train <- fread(file.path(dataDir, "train", "subject_train.txt"))
dt_subject_test  <- fread(file.path(dataDir, "test" , "subject_test.txt" ))


## 1. Merges the training and the test sets to create one data set.
### concatenate the rows of Training and Testing data
l = list(dt_X_train, dt_X_test)
dt_X_features <- rbindlist(l)

l = list(dt_y_train, dt_y_test)
dt_y_activities <- rbindlist(l)
setnames(dt_y_activities, "V1", "activity")

l = list(dt_subject_train, dt_subject_test)
dt_subject <- rbindlist(l)
setnames(dt_subject, "V1", "subject")

### concatenate all the columns into one data table (subject, activity, features)
dt_sub_act <- cbind(dt_subject, dt_y_activities)
dt <- cbind(dt_sub_act, dt_X_features)

### use Keys to facilitate Joins and ordering 
setkey(dt, subject, activity)



## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
### Consider only the features that provide means or standard deviations.
grep("mean\\(\\)|std\\(\\)", dt_features$featureName, value=TRUE)
dt_features <- dt_features[grepl("mean\\(\\)|std\\(\\)", featureName)]

### Match the index of the features with the headers of the measurements
dt_features$featureHeader <- paste("V", dt_features$featureIndex, sep='')
dt <- dt[, c(key(dt), dt_features$featureHeader), with=FALSE]



## 3. Uses descriptive activity names to name the activities in the data set
### Merge activity labels.
setnames(dt, "activity", "activityIndex")
dt <- merge(dt, dt_activity_labels, by="activityIndex", all.x=TRUE)

# Remove the activity index and add the activity label as a key.
dt <- dt[, !"activityIndex", with=FALSE] 
setkey(dt, subject, activity)

## 4. Appropriately labels the data set with descriptive variable names.
# Reshape the table to put all measurements onto one single column
dt <- data.table(melt(dt, key(dt), variable.name="featureHeader"))

# This allows us to easily rename the features with a descriptive name by a merge, a clean the table
dt <- merge(dt, dt_features[, list(featureIndex, featureHeader, featureName)], by="featureHeader", all.x=TRUE)
dt <- dt[, !c("featureHeader","featureIndex"), with=FALSE] 

## Now to get tidy data, we need to split the featureName variable into a meaninful set of variables
### Time domain or frequency domain?
dt[ , test := grepl("^f", dt$featureName)]
dt[ , domainType := ifelse(test, 'freq', 'time')]

### which sensor: Accelerometer or gyroscope?
dt[ , test := grepl("^(f|t)(Body|Gravity)Gyro", dt$featureName)]
dt[ , sensorType := ifelse(test, 'gyroscope', 'accelerometer')]

### which axis: X, Y, Z or NA?
lastDash <- function(x) {
        s <- strsplit(x,"-")
        last <- s[[1]][length(s[[1]])]
        gsub('\\(\\)', '', last)
}
dt$axisDir <- as.character(lapply(dt$featureName, lastDash))
dt[ , test := grepl("(X|Y|Z)$", dt$featureName)]
dt[dt$test == FALSE]$axisDir = NA

### which measure is a Mean or a Standard Deviation?
dt$statsType <- str_extract(dt$featureName, "(([M|m]ean)|([S|s]td))\\(\\)")
dt$statsType <- as.character(gsub('\\(\\)', '', dt$statsType))


### which acceleration type: Body or Gravity??
dt$accType <- str_extract(dt$featureName, "(([G|g]ravity)|([B|b]ody))")

### is it JERK signal?
dt$isJerk <- as.character(str_extract(dt$featureName, "([J|j]erk)"))
# dt[ , isJerk := grepl("([J|j]erk)", dt$featureName)]

### is it a Magnitude of these three-dimensional signals were calculated using the Euclidean norm?
dt$isMagnitude <- as.character(str_extract(dt$featureName, "([M|m]ag)"))
# dt[ , isMagnitude := grepl("([M|m]ag)", dt$featureName)]

### use Keys to facilitate Joins and ordering 
setkey(dt, subject, activity, domainType, sensorType, axisDir, statsType, accType, isJerk, isMagnitude)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
### Create a data set with the mean of each feature for each activity and each subject uaing dcast from the melted table
tidy_data <- dt[, list(average = mean(value)), by=key(dt)]

# Write to a file
write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE)
