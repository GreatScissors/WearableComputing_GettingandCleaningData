# WearableComputing_GettingandCleaningData
## *significant workings of script*, see in-script comments
## Samsung data must be unzipped and placed in the working directory

1. Lines 1-9: read the data into seperate tables
2. Lines 11-26: merge datasets with cbind, then rbind
3. Lines 31-35: search variable names given by features.txt with "mean", "Mean", and "std"
4. Lines 36-45: creates a vector of the columns to be extracted and extracts them into workingData data frame
5. Lines 47-53: labels the variables by their feature name
6. Lines 55-56: puts the Subject and Activity columns first
7. Lines 60-63: melts and dcasts the data with the mean values calculated for each variable for each activity and each subject
8. Lines 65-71: converts numerical values in activity column to descriptive activity names
9. Lines 76-77: write the final data frame to TidyData.txt to the working directory containing the Samsung data