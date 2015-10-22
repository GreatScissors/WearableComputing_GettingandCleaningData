setwd("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test")
subject_test_data <- read.table("subject_test.txt")
x_test_data <- read.table("x_test.txt")
y_test_data <- read.table("y_test.txt")
setwd("..")
setwd("train")
subject_train_data <- read.table("subject_train.txt")
x_train_data <- read.table("X_train.txt")
y_train_data <- read.table("y_train.txt")

# rename identical column names to Subject and Activity
names(subject_test_data)[names(subject_test_data)=="V1"] <- "Subject"
names(y_test_data)[names(y_test_data)=="V1"] <- "Activity"

# merge test data tables
testTotal <- cbind(x_test_data, subject_test_data, y_test_data)

# rename identical column names to Subject and Activity
names(subject_train_data)[names(subject_train_data)=="V1"] <- "Subject"
names(y_train_data)[names(y_train_data)=="V1"] <- "Activity"

# merge train data tables
trainTotal <- cbind(x_train_data, subject_train_data, y_train_data)

# merge test and train data tables
dataTotal <- rbind(testTotal,trainTotal)

# set to UCL Har Dataset parent folder
setwd("..")

# read features table and search for mean() and std()
features <- read.table("features.txt")
featuresMean <- features[grep("mean", features$V2), ]
featuresAngleMean <- features[grep("Mean", features$V2), ]
featuresStd <- features[grep("std", features$V2), ]

# includes only the mean and standard deviation columns
vfeaturesMean <- as.vector(featuresMean$V1)
vfeaturesAngleMean <- as.vector(featuresAngleMean$V1)
vfeaturesStd <- as.vector(featuresStd$V1)

# include only the columns needed
colvector <- c(vfeaturesMean,vfeaturesStd, vfeaturesAngleMean, which(colnames(dataTotal)=="Subject"), which(colnames(dataTotal)=="Activity"))
colvector <- sort(colvector)
workingData <- dataTotal[,colvector]

# data table of used features
usedFeatures <- features[sort(c(vfeaturesMean,vfeaturesStd,vfeaturesAngleMean)),]

# rename V1, V2, V3 column labels... into variable names
for (i in 1:nrow(usedFeatures)) {
  colnames(workingData)[i] <- as.character(usedFeatures[i,"V2"])
}

# put the Subject and Activity columns first
workingData <- workingData[, c((ncol(workingData)-1), ncol(workingData), 1:(ncol(workingData)-2))]

library(reshape2)

# melt data into long-format
dataMelt <- melt(workingData,id=c("Subject","Activity"),measure.vars = c(3:ncol(workingData)))
# go from long-format to wide-format with the average of each variable for each activity and each subject
finalData <- dcast(dataMelt, Subject + Activity ~ variable,mean)

# converts values in activity column to descriptive activity names
finalData$Activity[finalData$Activity == "1"] <- "Walking"
finalData$Activity[finalData$Activity == "2"] <- "Walking Upstairs"
finalData$Activity[finalData$Activity == "3"] <- "Walking Downstairs"
finalData$Activity[finalData$Activity == "4"] <- "Sitting"
finalData$Activity[finalData$Activity == "5"] <- "Standing"
finalData$Activity[finalData$Activity == "6"] <- "Laying"

setwd("..")
setwd("..")

# write the data frame to TidyData.txt
write.table(finalData, "TidyData.txt", row.names = FALSE)