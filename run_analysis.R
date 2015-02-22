#This script is generating one tidy data frame from several data files


#Loadint the data, working directory set to the downloaded unzipped directory
testx <- read.table(paste(getwd(),"test/X_test.txt", sep = "/"))
testy <- read.table(paste(getwd(),"test/y_test.txt", sep = "/"))
subjecttest <- read.table(paste(getwd(),"test/subject_test.txt", sep = "/"))

trainx <- read.table(paste(getwd(),"train/X_train.txt", sep = "/"))
trainy <- read.table(paste(getwd(),"train/y_train.txt", sep = "/"))
subjecttrain<- read.table(paste(getwd(),"train/subject_train.txt", sep = "/"))

features <- read.table(paste(getwd(),"features.txt", sep = "/"))

#merging the sets
x <- rbind(testx, trainx)
y <- rbind(testy, trainy)
subject <- rbind(subjecttest, subjecttrain)

#creating one data set
dat <- cbind(x,y,subject)

library(dplyr)

#extracting only the means and standard devaition measurements, from data and features
m <- grep("mean", as.character(features[,2]))
s <- as.integer(grep("std", as.character(features[,2])))
d <- sort(c(m,s))
dat <- dat[,d]
nn <- as.character(features[,2])
nn <- nn[d]

#renaming the activities, based on activity_labels.txt
y <- factor(y[,1])
levels(y) <- c("walking", "walkingupstairs", "walkingdownstairs", "sitting", "standing", "laying")
y <- as.character(y)

#adding subject and activity columns to the data frame
dat <- cbind(subject, y, dat)
names(dat) <- c("subject", "activity", nn)

#Getting long tidy data set
library(reshape2)
dat <- melt(dat, id = c("subject", "activity"), na.rm = T)
dat <- dcast(dat, subject + activity ~ variable, mean)
dat <- melt(dat, id = c("subject", "activity"))
names(dat) <- c("subject", "activity", "measure", "value")
write.table(dat,paste(getwd(),"data.txt", sep = "/"), row.names = FALSE)
