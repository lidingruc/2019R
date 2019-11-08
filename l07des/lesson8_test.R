##############
##  本次课的主要内容：
#一、简单描述性统计、列联表、相关。
#二、介绍T检验和方差分析
#三、介绍回归分析及其原理
#四、Rstudio提供的统计原理互动资料https://www.rstudio.com/products/shiny/shiny-user-showcase/
#五、QSS中关于probability和Uncertainty的内容：https://jrnold.github.io/qss-tidy/probability.html
# https://jrnold.github.io/qss-tidy/uncertainty.html
# -------------------------------------------
# --加载必要的包
# -------------------------------------------
if (!require(tidyverse)) install.packages('tidyverse')	
if (!require(data.table))install.packages('data.table')
if (!require(dplyr))install.packages('dplyr')

if (!require(sjPlot))install.packages('sjPlot')
if (!require(sjmisc))install.packages('sjmisc')
if (!require(sjlabelled))install.packages('sjlablled')

if (!require(haven)) install.packages('haven')
if (!require(DT)) install.packages('DT')
# -------------------------------------------
# --一、读入数据并进行了预处理
# -------------------------------------------
### 读入数据,预处理为一般的R数据
setwd("/Users/liding/E/Bdata/liding17/2018R")
library(haven)
cgss2013<-read_dta('./data/cgss2013.dta',encoding="gb18030") 

# 保留变量标签,因为后面的as.numeric会将变量的变迁丢失
labelcgss <- get_label(cgss2013)
cgss2013<- cgss2013 %>% 
  mutate_all(~ replace(., .==-1|.==-2|.==-3|.==9999997|.==9999998|.==9999999, NA)) %>%  
  # 替换缺失值,用的lambdas 函数
  drop_labels()  %>%  
  # 删除未用到的取值标签，含自定义缺失值的标签
  as_label(drop.levels = TRUE)  %>%  
  # 剩余的带标签的变量变为因子变量
  mutate_if(is.labelled, ~as_numeric(as.character(.))) 
# 已经删除了缺失值标签的数字变量变为数字

#还原变量标签
cgss2013 <- set_label(cgss2013,labelcgss)

#更多介绍： https://cran.r-project.org/web/packages/sjlabelled/vignettes/intro_sjlabelled.html

#定义一个函数方便查看数据集中的变量和变量标签
des <- function (dfile) {
  lbl = sapply(dfile, attr, 'label')
  if (is.list(lbl)) {
    lbl[sapply(lbl, is.null)] = ''
    lbl[sapply(lbl, length) > 1] = ''
    lbl = unlist(lbl)
  }
  Encoding(lbl) = 'UTF-8'
  dfile_var = data.frame(var =names(dfile), lbl = lbl) 
  #DT::datatable(dfile_var,rownames=FALSE)
  View(dfile_var)
}  
# 查看数据中的变量信息
des(cgss2013)

# -------------------------------------------
# -- 二. 假设检验 Hypothesis Testing --
# ------------------------------------------- 
############
# 列联表的卡方检验 基本原理
# A、Chi-square Test, small difference
# 教育水平和性别
sjt.xtab(cgss2013$a7a,cgss2013$a2,encoding="UTF-8")
#如果出现乱码，尝试设定encoding为gb2312之类
##########
mytable<-xtabs(~cgss2013$a7a+cgss2013$a2)
chisq.test(mytable)

chisq.test(cgss2013$a7a,cgss2013$a2)

summary(table(cgss2013$a2, cgss2013$a7a))

# expected cell 
ch01 <- chisq.test(cgss2013$a7a,cgss2013$a2)
str(ch01)
ch01$expected

# 标准化偏差，评估单元格影响
ch01$residuals
chisq.test(cgss2013$a7a,cgss2013$a2)$resid

##########
#似然比检验
#### Likelihood-Ratio Test Statistic for IxJ tables
LRstats=function(data){
  G2=2*sum(data*log(data/chisq.test(data)$expected))
  G2pvalue=1-pchisq(G2,df=(dim(data)[1]-1)*(dim(data)[2]-1))
  ans=c(G2,G2pvalue)
  ans
}
LRstats(mytable)

# 二手列联表分析
observed <- matrix(c(32, 24, 265, 199, 391, 287),nrow = 3, byrow = T)
observed

chisq.test(observed, correct = F)
cbind(observed, chisq.test(observed)$expected)
cbind(observed, chisq.test(observed)$resid)

#其他的相关系数可以自己写
#也可以在一些其他包中找到如DescTools、Hmisc中
#DescTools::DescToolsOptions(family="STKaiti")
#DescTools::Desc(cgss2013$a7a) # 乱码后面解决

############
# B、t-test

# One sample t test
t.test(cgss2013$a8a, mu=24000)
t.test(cgss2013$a8a, mu=25000,alternative ='less')

# Independent 2 group t test where y is numeric and x is a binary factor
t.test(a8a ~ a2, data = cgss2013)
var.test(a8a ~ a2, data = cgss2013)
# Paired t test

t.test(cgss2013$a8a, cgss2013$a8b, paired = TRUE) 

tResults <- t.test(cgss2013$a8a, cgss2013$a8b, paired = TRUE) 
summary(tResults)
tResults$statistic
tResults['statistic']

# 原理示例
# 假定方差相等，假定正太分布，检验均值相等假设
# 胆固醇水平
cholest <- data.frame(chol = c(245, 170, 180,190, 200, 210, 220, 230, 240, 250, 260, 185,205, 160, 170, 180, 190, 200, 210, 165), gender = rep(c("female","male"), c(12, 8)))
str(cholest)
cholest 
boxplot(chol ~ gender, cholest, ylab = "Cholesterol Score")

# 正态分布？
par(mfrow = c(1, 2))
qqnorm(cholest$chol[cholest$gender == "male"],
       main = "QQNorm for the Males")

qqnorm(cholest$chol[cholest$gender == "female"],
       main = "QQNorm for the Females")

# 方差相等
var.test(chol ~ gender, cholest)
DescTools::LeveneTest(chol ~ gender, cholest)
# 均值相等 
t.test(chol ~ gender, cholest)

############
#C、anova
par(family="STKaiti")
par(mfrow = c(1, 1))
boxplot(a8a~a7a,data=cgss2013)

edu_inc <- cgss2013 %>% group_by(a7a) %>%
  summarize(meaninc = mean(a8a, na.rm = TRUE)) 

ggplot(edu_inc,aes(x=a7a,y=meaninc)) +
  geom_bar(stat = "identity")

aov_inc <- aov(a8a ~ a7a , data = cgss2013)
summary(aov_inc)
aov_inc 
plot(aov_inc)

TukeyHSD(aov_inc)
 
##交互效应的表示方式
fit <- aov(a8a ~ a7a + a2 + a7a:a2, data = cgss2013)
fit
fit <- aov(a8a ~ a7a*a2, data = cgss2013)
fit

# 协方差分析
aov(a8a ~ a3a + a2, data = cgss2013)
aov(a8a ~ a3a * a2, data = cgss2013)

#可以使用lm模型来做，提取其中的方差分析部分即可
#见下面的例子

# F检验的临界值，4自由度，50个案例
qf(0.95, 4, 45)

############
#D、回归分析 Linear Regression Model

?lm
?predict.lm

lm_inc <- lm(a8a ~ I(2013-a3a) + a2, data = cgss2013)
summary(lm_inc)
anova(lm_inc)
par(mfrow = c(2, 2))
plot(lm_inc)
confint(lm_inc)

## 回归分析的原理展示
## 构建一个虚拟数据
set.seed(1)
x <- seq(1,5,length.out=100)
noise <- rnorm(n =100, mean =0, sd = 1)
beta0 <- 1
beta1 <- 2
y <- beta0+ beta1*x +noise
par(mfrow = c(1, 1))
plot(y ~ x)

model <- lm(y ~x)  # 生成了一个model 对象
plot(y~x)
abline(model)

###回归模型的输出结果
summary(model)
model.matrix(model)

##model对象中包含的其他内容
names(model)

## 判定系数的含义
ybar <- mean(y)
yPred <- model$fitted.values
Rsquared <- sum((yPred-ybar)^2)/sum((y-ybar)^2)
sqrt(sum(model$residuals^2)/98)

## 预测值作图
yConf <- predict(model,interval= 'confidence')
yPred <- predict(model,interval= 'prediction')
plot(y~x,col='grey',pch=16)
yConf <- as.data.frame(yConf)
yPred <- as.data.frame(yPred)
lines(yConf$lwr~x,col='black',lty=3)
lines(yConf$upr~x,col='black',lty=3)
lines(yPred$lwr~x,col='black',lty=2)
lines(yPred$upr~x,col='black',lty=2)
lines(yPred$fit~x,col='black',lty=1)

## 纳入虚拟变量 要转为因子类型
set.seed(1)
x <- factor(rep(c(0,1),each=30))
y <- c(rnorm(30,0,1),rnorm(30,1,1))
plot(y~x)

model <- lm(y~x)
summary(model)
model.matrix(model)

#效果等同于T检验。

# 回归诊断
## 前提是否成立：模型结构假设，误差假设，异常样本
#  真模型是二次回归，线性回归是有偏差的
set.seed(1)
x<-seq(1,5,length.out=100)
noise<-rnorm(n=100,mean=0,sd=1)
beta0<-1
beta1<-2
y<-beta0+beta1*x^2+noise
model<-lm(y~x)
summary(model)
plot(y~x)
abline(model)

## 呈现异方差
plot(model$residuals~x)

## 增加二次项、
model2<-lm(y~x+I(x^2))
summary(model2)
plot(model2$residuals~x)

## 剔除一次项再回归
model3<- update(model2, y ~ . -x)
summary(model3)
plot(model3$residuals~x)

AIC(model,model2,model3)

############
# 在R中模拟异方差
set.seed(123456) 
x = rnorm(500,1,1) 
b0 = 1 # intercept chosen at your choice 
b1 = 1 # coef chosen at your choice 
h = function(x) 1+.4*x # h performs heteroscedasticity function (here 
#I used a linear one) 
eps = rnorm(500,0,h(x)) 
y = b0 + b1*x + eps 
plot(x,y) 
abline(lsfit(x,y)) 
abline(b0,b1,col=2) 


# E、模拟和获取统计检验结果（自学，结合lesson7_basic.R)
# Generate a random sample from specific distribution 
# n=100 from N(0,1) distribution
rnorm(100)
?rnorm
# n=100 from U(0,1) distribution
runif(100)
?runif


# Density for specific distribution
par(mfrow = c(1, 1))  
x <- seq(-4, 4, length = 100)
y1 <- dnorm(x)
plot(x, y1, type = "l", lwd = 2, col = "blue")
y2 <- dnorm(x, m = 0, sd = 2)
lines(x, y2, type = "l", lwd = 2, col = "red")


# Cumulative distribution function : To get p-value, pnorm() function.
pnorm(1.96)
pnorm(1.96, lower.tail = FALSE)


# Quantile function : To get quantiles or "critical values", qnorm( ) function. 
qnorm(0.95) # p = .05, one-tailed (upper)
qnorm(c(0.025, 0.975)) # p = .05, two-tailed


sdest <- unique(flights$dest) %>%
  sample(20)

flights %>%
  filter(dest %in% sdest) %>% 
  group_by(month, dest) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  group_by(dest) %>%
  filter(n() == 12) %>%
  ungroup() %>%
  mutate(dest = reorder(dest, dep_delay)) %>%
  ggplot(aes(x = factor(month), y = dest, fill = dep_delay)) +
  geom_tile() +
  scale_fill_viridis() +
  labs(x = "Month", y = "Destination", fill = "Departure Delay")




