#heart disease dataset: https://www.kaggle.com/ronitf/heart-disease-uci/download

hrtdata <- read.csv(file="./datasets/heart-disease-uci/heart.csv", header=TRUE, sep=",")

smp_size <- floor(0.75 * nrow(hrtdata))

set.seed(123)

train_set <- sample(seq_len(nrow(hrtdata)), size = smp_size)

train <- hrtdata[train_set, ]
test <- hrtdata[-train_set, ]
head(train)

heart.rf <- randomForest(target ~ ., data = train, proximity=TRUE)


# MDS plot creation: 
distance.matrix <- dist(1-heart.rf$proximity)
mds.stuff <- cmdscale(distance.matrix, eig=TRUE, x.ret=TRUE)
mds.var.per <- round(mds.stuff$eig/sum(mds.stuff$eig)*100, 1)

mds.values <- mds.stuff$points

mds.data <- data.frame(Sample=rownames(mds.values),
                       X=mds.values[,1],
                       Y=mds.values[,2],
                       Status=train$target)

ggplot(data=mds.data, aes(x=X, y=Y, label=Sample)) +
  geom_text(aes(color=Status)) +
  theme_bw() +
  xlab(paste("MDS1 - ", mds.var.per[1], "%", sep="")) + 
  ylab(paste("MDS2 - ", mds.var.per[2], "%", sep="")) +
  ggtitle("MDS plot using (1 - Random Forest Proximities)")


mean(predict(heart.rf, test, type="class"))

     