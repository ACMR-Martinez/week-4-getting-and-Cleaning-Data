##You should create one R script called run_analysis.R that does the following.

##Merges the training and the test sets to create one 
##data set.
alldataSubjec <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubjec, "V1", "subject")
alldataActivity <- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "acivityNum")

dataTable <- rbind(dataTrain, dataTest)

dataFeatures <- tbl_df(read.table(file.path(filesPath,
                                            "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

activityLabels <- tbl_df(read.table(file.path(filesPath, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum", "activityName"))

alldataSubjec <- cbind(alldataSubjec, alldataActivity)
dataTable <- cbind(alldataSubjec, dataTable)


##Extracts only the measurements on the mean and standard
##deviation for each measurement.

dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName)

dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable, select= dataFeaturesMeanStd)



##Uses descriptive activity names to name the activities 
##in the data set

dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))


##Appropriately labels the data set with descriptive
##variable names.

names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))



##From the data set in step 4, creates a second, 
##independent tidy data set with the average of each
##variable for each activity and each subject.

write.table(dataTable, "Tidy.txt", row.names = F)
