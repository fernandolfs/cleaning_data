# initialize work variables
## working with paths
work_dir <- "C:\\projects\\coursera\\cleaning_data\\cleaning_data\\"
cur_dir <- getwd()
setwd(work_dir)

#reading feature names
features <- read.table("./data/features.txt")
ac <- read.table("./data/activity_labels.txt")

##function to load and prepare data
prepareData <- function(measures, subjects, activities)
{
  ##read xdata
  x <- read.table(measures)
  colnames(x) <- features$V2
  
  ##select only mean measures
  test <- x[,grep("mean", features$V2, ignore.case=TRUE)]
  
  ##select only std measures and colbind it to mean measures
  test <- cbind(x[,grep(c("std"), features$V2, ignore.case=TRUE)],test)
  
  ##bind the activities
  test <- cbind(read.table(activities), test)
  colnames(test)[1] <- "activities"
  
  ##and bind the subjects
  test <- cbind(read.table(subjects), test)
  colnames(test)[1] <- "subjects"
  
  test
}

##merge all data
data <- rbind(
  ##read & combine test data
  prepareData(
    "./data/test/X_test.txt", 
    "./data/test/subject_test.txt",
    "./data/test/y_test.txt"
    ),

  ##read & combine train data
  train <- prepareData(
    "./data/train/X_train.txt", 
    "./data/train/subject_train.txt",
    "./data/train/y_train.txt"
    )
  )

##add activity names
data <- merge(x=data, y=ac, by.x="activities", by.y="V1")
colnames(data)[length(colnames(data))] <- "activity_name"

tidy <- melt(data, c("activities", "subjects", "activity_name"))
tidy <- dcast(z, activity_name + subjects ~ variable, mean)

#writing the dataframe as csv
write.csv(tidy, "tidy.txt")

#set back dir
setwd(cur_dir)