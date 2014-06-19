
# read txt files
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

feature_names <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
# 1. merges the data set
test <- cbind(X_test,y_test,subject_test)
train <- cbind(X_train,y_train,subject_train)

names(test)[c(562,563)] <- c("y","subject")
names(train)[c(562,563)] <- c("y","subject")

mergedData <- merge(test,train,all=TRUE)

# 2. extracts the measurements
names(mergedData) <- c(as.character(feature_names$V2),"y","subject")
meanstdCol <- grep("mean\\(\\)|std\\(\\)",names(mergedData))
mergedData <- mergedData[,c(meanstdCol,562,563)]

# 3.  name the activities using descriptive names
row1 <-grep(1,mergedData$y)
mergedData$y[row1] <- "WALKING"
row2 <-grep(2,mergedData$y)
mergedData$y[row2] <- "WALKING_UPSTAIRS"
row3 <- grep(3,mergedData$y)
mergedData$y[row3] <- "WALKING_DOWNSTAIRS"
row4 <- grep(4,mergedData$y)
mergedData$y[row4] <- "SITTING"
row5 <- grep(5,mergedData$y)
mergedData$y[row5] <- "STANDING"
row6 <- grep(6,mergedData$y)
mergedData$y[row6] <- "LAYING"

# 4. change the label to be descriptive
names(mergedData) <- gsub("-","_",names(mergedData))
names(mergedData) <- gsub("\\(\\)","",names(mergedData))

# 5. a second, independent tidy data set
mergedData$y <- as.factor(mergedData$y)
mergedData$subject <- as.factor(mergedData$subject)
library(reshape2)

tidyData <- aggregate(mergedData[,c(1:(dim(mergedData)[2]-2))],by = list(mergedData$y,mergedData$subject),FUN = "mean")
names(tidyData)[c(1,2)] <- c("Activity","Subject")

write.table(tidyData,file = "tidy_data.txt")
