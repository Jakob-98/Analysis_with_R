#https://www.youtube.com/watch?v=6EXPYzbfLCE
#https://www.rdocumentation.org/packages/randomForest/versions/4.6-14
#https://www.kaggle.com/viczyf/titanic-random-forest-82-78


library(randomForest)
library(ggplot2)
library(cowplot)


trainset <- read.csv(file="./datasets/titanic/train.csv", header=TRUE, sep=",")
testset <- read.csv(file="./datasets/titanic/test.csv", header=TRUE, sep=",")


#exploratory analysis
head(trainset)
nrow(trainset)
str(trainset)

surivaltable <- table(trainset['Survived'])
barplot(surivaltable, legend = TRUE)


#Survival rate seems heavily dependent on class
aggregate(trainset$Survived, by=list(Class=trainset$Pclass), FUN=mean)

#name prefixes can be used for classification
head(trainset$Name)
testname <- 'Braund, Mr. Owen Harris'
#testing splitting the strings
(outstr <- strsplit(strsplit(testname, ', ', fixed = TRUE)[[1]][2], '. ', fixed = TRUE)[[1]][1])


#why wont this work???
# nametoprefix <- function(name) {
#   #print(typeof(name))
#   print(name)
#   return(name)
#   return(strsplit(strsplit(name, ', ', fixed = TRUE)[[1]][2], '. ', fixed = TRUE)[[1]][1])
# }
# 
# sapply(trainset$Name[1:3], nametoprefix)
# sapply(trainset$Name, strsplit(strsplit(trainset$name[i, ], ', ', fixed = TRUE)[[1]][2], '. ', fixed = TRUE)[[1]][1])
# 


trainset$Sex <- as.factor(trainset$Sex)
trainset$Pclass <- as.factor(trainset$Pclass)
trainset$Parch <- as.factor(trainset$Parch)
trainset$SibSp <- as.factor(trainset$SibSp)
trainset$SibSp <- as.factor(trainset$SibSp)


trainset$Survived <- ifelse(test=trainset$Survived == 0, yes="survived", no='died')
trainset$Survived <- as.factor(trainset$Survived)


#Setting columns which I havent properly processed to null, as they won't improve the model at this time. I need to do this to prevent error in imputing
trainset$Cabin <- NULL
trainset$Ticket <- NULL
trainset$Name <- NULL

#removing NA values -> I need to improve this, this is an ugly fix. 
trainset <- trainset[, colSums(is.na(trainset)) == 0]

#setting a random seed to keep the same results
set.seed(55)
trainset.imputed <- rfImpute(Survived ~., data = trainset, iter=6)
titanic.rf <- randomForest(Survived ~ ., data = trainset, proximity=TRUE)

print(titanic.rf)

#checking the out-of-bag error rate
oob.error.data <- data.frame(
  Trees=rep(1:nrow(titanic.rf$err.rate), times=3),
  Type=rep(c("OOB", "died", 'survived'), each=nrow(titanic.rf$err.rate)),
  Error=c(titanic.rf$err.rate[,"OOB"],
          titanic.rf$err.rate[,'died'],
          titanic.rf$err.rate[,'survived']))

ggplot(data=oob.error.data, aes(x=Trees, y=Error)) + geom_line(aes(color=Type))

#determining number of variables to try at each set
oob.values <- vector(length=10)
for(i in 1:10) {
  temp.model <- randomForest(Survived ~ ., data = trainset, mtry = i, proximity=TRUE)
  oob.values[i] <- temp.model$err.rate[nrow(temp.model$err.rate),1]
}
oob.values #use this to optimize the nvar




#A matrix of proximity measures among the input (based on the frequency that pairs of data points are in the same terminal nodes).

# MDS plot creation: 
distance.matrix <- dist(1-titanic.rf$proximity)
mds.stuff <- cmdscale(distance.matrix, eig=TRUE, x.ret=TRUE)
mds.var.per <- round(mds.stuff$eig/sum(mds.stuff$eig)*100, 1)

mds.values <- mds.stuff$points

mds.data <- data.frame(Sample=rownames(mds.values),
                       X=mds.values[,1],
                       Y=mds.values[,2],
                       Status=trainset$Survived)

ggplot(data=mds.data, aes(x=X, y=Y, label=Sample)) +
  geom_text(aes(color=Status)) +
  theme_bw() +
  xlab(paste("MDS1 - ", mds.var.per[1], "%", sep="")) + 
  ylab(paste("MDS2 - ", mds.var.per[2], "%", sep="")) +
  ggtitle("MDS plot using (1 - Random Forest Proximities)")


str(trainset)
str(testset)

#predicting on the validaiton set
predValid = predict(titanic.rf, testset, type="class")
