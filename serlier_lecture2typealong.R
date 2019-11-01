#get current dir
getwd()
#set current dir
setwd('./datasets/')
MyData <- read.csv(file="./survey.csv", header=TRUE, sep=",")
head(MyData)

class(MyData)
tail(MyData)
str(MyData)
summary(MyData)
attributes(MyData)
nrow(MyData)
ncol(MyData)
MyData$Program[1]
colnames(MyData)[1] <- "Index"
MyData$Program
MyData[['Program']]
MyData['Program']

plot(MyData$Program)
plot(MyData[['Program']])
MyData[6,5:6]

MyData[survey$Program=="MISM", ]
MyData[which(MyData$Program=="MISM"), ]
head(MyData[, c(1,5)],5)
tv.hours <- MyData$TVhours
tv.hours
sort(tv.hours, decreasing <- TRUE)
sort(tv.hours, decreasing = FALSE)

# 
# MyDataSub <- subset(MyData, select=c("OperatingSystem", "TVhours"), 
#                     subset=().....


