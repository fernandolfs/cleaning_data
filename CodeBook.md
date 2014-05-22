# Step by Step description

* At first some environment config is done
```
work_dir <- "./"
cur_dir <- getwd()
setwd(work_dir)
```

* Then the script loads the activity and feature labels 
```
features <- read.table("./data/features.txt")
ac <- read.table("./data/activity_labels.txt")
```

* The function ```prepareData```
```
prepareData <- function(measures, subjects, activities)
{
  x <- read.table(measures)
  colnames(x) <- features$V2
  
  test <- x[,grep("mean", features$V2, ignore.case=TRUE)]
  
  test <- cbind(x[,grep(c("std"), features$V2, ignore.case=TRUE)],test)
  
  test <- cbind(read.table(activities), test)
  colnames(test)[1] <- "activities"
  
  test <- cbind(read.table(subjects), test)
  colnames(test)[1] <- "subjects"
  
  test
}
```

* It is used to do the following tasks for both train and test data:
 * load the measures file
 * select only mean and std features
 * add the subjects column
 * add the activities column
 * set columns names
 * return the new dataset


* With the function prepareData in place the script loads and prepare both train and test data
```
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
```

* then it adds one column with ativity names merging the activity names loaded before with the function´s resultant dataset
```
data <- merge(x=data, y=ac, by.x="activities", by.y="V1")
colnames(data)[length(colnames(data))] <- "activity_name"
```

* and calculates the mean of the selected mesures for each activity and subject by melting and casting
```
tidy <- melt(data, c("activities", "subjects", "activity_name"))
tidy <- dcast(tidy, activity_name + subjects ~ variable, mean)
```

* finally the script writes down the tidy data file and restore the working path
```
write.csv(tidy, "tidy.txt")
setwd(cur_dir)
```

* the result file is named *tidy.txt* at the workdir