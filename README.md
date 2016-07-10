# Peer Graded Assignment: Getting and Cleaning Data Course Project

This assignment is the final project of the course on COURSERA named ["Getting and Cleaning Data"](https://www.coursera.org/learn/data-cleaning)

## COURSERA instructions

> Submit by July 10, 11:59 PM PDT
> 
> Important Information
> 
> It is especially important to submit this assignment before the deadline, July 10, 11:59 PM PDT, because it must be graded by others. If you submit late, there may not be enough classmates around to review your work. This makes it difficult - and in some cases, impossible - to produce a grade. Submit on time to avoid these risks.
> 
> ## Instructions
> 
> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
> 
> ### Review criteria
> 
> 1. The submitted data set is tidy.
> 2. The Github repo contains the required scripts.
> 3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
> 4. The README that explains the analysis files is clear and understandable.
> 5. The work submitted for this project is the work of the student who submitted it.
> 
> ### Getting and Cleaning Data Course Project 
> 
> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit:
> a tidy data set as described below,
> a link to a Github repository with your script for performing the analysis, and
> a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
> 
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
> 
> [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
> 
> Here are the data for the project:
> 
> [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
>
> You should create one R script called run_analysis.R that does the following.
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names.
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> 
> Good luck!

## Content of this repository

### The raw data

The raw data is already saved locally in this repository for reproducability purpose ([./rawData/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](./rawData/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)).

If deleted, the raw data will be downloaded again programatically through the main script with a call to this url:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

### The tidy data set

The tiny data set containing the average of each variable for each activity and each subject is one output of this project and saved in this file [`tidy_data.txt`](./output/tidy_data.txt)`.

It follows the principles of a tiny data set.

* each variable forms a column
* each observation forms a row
* each table/file stores data about only one kind of observation

It is described in the codebook presented below.

### The codebook

The codebook ([`Codebook.md`](./output/Codebook.md)) describes all the variables, their values along with units and any other relevant information in the tidy data set.

### Recipe and 'R' Script

Run the R script [`run_analysis.r`](./src/run_analysis.R) in order to regenerate the tiny data from the raw smartphones' data.

The script performs the tasks expected for the assignment:

* it downloads the raw data if it's not already present in [rawData/](./rawData)
* it extracts the .zip file into a directory named 'UCI HAR Dataset'

    > The dataset includes the following files:
    >    =========================================
    >    - 'README.txt'
    > 
    > - 'features_info.txt': Shows information about the variables used on the feature vector.
    > 
    > - 'features.txt': List of all features.
    > 
    > - 'activity_labels.txt': Links the class labels with their activity name.
    > 
    > - 'train/X_train.txt': Training set.
    > 
    > - 'train/y_train.txt': Training labels.
    > 
    > - 'test/X_test.txt': Test set.
    > 
    > - 'test/y_test.txt': Test labels.

* Loads the data of each file into data tables.
* Merges the training and the test sets to create one data set.
* Extracts only the measurements related to the mean and standard deviation for each measurement.
* Joins and Maps various raw files in order to produce descriptive activity names to name the activities in the data set ("LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS").
* Melt the data to enable the split of data variable in various columns and appropriately labels the data set with descriptive variable names (domainType, sensorType, axisDir, statsType, accType, isJerk, isMagnitude).
*Creates a second, independent [tidy data set](./output/tidy_data.txt) with the average of each variable for each activity and each subject.
