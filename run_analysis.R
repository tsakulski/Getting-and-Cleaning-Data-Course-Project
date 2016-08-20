## read the files from the directory
staza_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(staza_rf, recursive=TRUE)
files

## read data from the test folder
dataAktivnostTest  <- read.table(file.path(staza_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivnostTrain <- read.table(file.path(staza_rf, "train", "Y_train.txt"),header = FALSE)

## read data from the train folder
dataSubjekatTrain <- read.table(file.path(staza_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjekatTest  <- read.table(file.path(staza_rf, "test" , "subject_test.txt"),header = FALSE)

## read features files
dataKarakterTest  <- read.table(file.path(staza_rf, "test" , "X_test.txt" ),header = FALSE)
dataKarakterTrain <- read.table(file.path(staza_rf, "train", "X_train.txt"),header = FALSE)

############# Task 1: merges the training and the test sets to create one data set
## 1. concatenate data tables by rows
dataSubjekat <- rbind(dataSubjekatTrain, dataSubjekatTest)
dataActivnost<- rbind(dataActivnostTrain, dataAktivnostTest)
dataKarakter<- rbind(dataKarakterTrain, dataKarakterTest)
## 2.set names to variables
names(dataSubjekat)<-c("subject")
names(dataActivnost)<- c("activity")
dataKarakterNames <- read.table(file.path(staza_rf, "features.txt"), head=FALSE)
names(dataKarakter)<- dataKarakterNames$V2
## 3. merge columns to get the data frame "Data" for all data
dataCombine <- cbind(dataSubjekat, dataActivnost)
Data <- cbind(dataKarakter, dataCombine)

############# Task 2: extract only the measurements on the mean and standard deviation for each measurement
## taken Names of Features with "mean()" or "std()"
subdataKarakterNames<-dataKarakterNames$V2[grep("mean\\(\\)|std\\(\\)", dataKarakterNames$V2)]
## Subset the data frame "Data" by seleted names of Features
selectedNames<-c(as.character(subdataKarakterNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

############ Task 3: Use descriptive activity names to name the activities in the data set
## 1.Read descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(staza_rf, "activity_labels.txt"),header = FALSE)

############# Task 4: Appropriately labels the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

############### Task 5: create a second,independent tidy data set and ouput it
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
