# -------------------------------------------
# Introduction to R
# 2019年9月26日
# -------------------------------------------

# ----------------------
# -- I. R基本概念与数据元素 --
# ----------------------

1  # Recognizes 1 as a vector with only a single element
1 + 1
a

# A. 赋值语句（Assignments）

add <- 1 + 2    
add  # By just calling the name, you can see the value
add = 1 + 2

# B. 对象（Objects）: <object name> <- <information in R>   

value1 <- 1 + 2
value1        

value2 <- "blue"
value2        


# C. 函数（Functions） 

sqrt(2 ^ 3)
sqrt(value1)
sqrt(value2)
help(sqrt)      
?help
# 常见函数（参见r basic cheatsheet)

# D. 数据类型（Data Types）

# 1. 向量（Vectors）
vec1 <- c(4.6, 4.8, 5.2, 6.3, 6.8, 7.1, 7.2, 7.4, 7.5, 8.6)    
vec2 <- c('BJ', 'SH', 'SZ', 'TJ', 'WH', 'CS', 'JN', 'CQ', 'CD', 'ZZ')
?c  # Combines values into a vector or a list

# 向量元素（Element of  Vectors） : <vector>[<vector of indices>]
vec1[7]      
vec2[1:3]
vec2[c(1,3)]

# 向量长度（Length of the Vectors）        
length(vec1)
length(vec2)          


# 向量类型（Class of Vectors ）       
class(vec1)
class(vec2)

# 用于向量的函数（Functions for a Numeric Vector）
mean(vec1)
var(vec1)
sum(vec1)
max(vec1)
# 常见函数（参见r basic cheatsheet)

# Summaries of Vectors
summary(vec1)
summary(vec2)
summary(as.factor(vec2))  # If you classify obj2 as a factor variable, you can obtain frequencies
?as.factor()

as.character(vec1)
as.factor(vec1)

# 向量运算（Vector Operations）
vec1+1
vec1*5
rep(1, times = 10)   
rep(vec1, times = 5) 
round(vec1/3, 2)
floor(vec1)

# 合并（Combine Two Vectors） Length = 20 
vec3 <- c(vec1, vec2)   
length(vec3)

# ---------------------------------------------------------------
# -- 练习 1 
# --- 创建向量 v1 为取值1到8的重复5次的向量 
# ---------------------------------------------------------------

# 2. 矩阵（Matrix）
m1 <- cbind(vec1, vec2)  # try cbind(vec1, vec3) 
m1  # 与vec3有啥不同?
class(m1)  #所有元素的类型相同(numeric/character...), 
dim(m1)

# 通过[]Brackets引用矩阵中的元素 : <matrix>[<row indices>,<column indices>]
m1[, 1]
m1[2, ]


# 3. 数据框（Data Frame） 
df1 <- data.frame(vec1, vec2)
class(df1)      
str(df1) # compare with Global environment in Rstudio

# 通过[]引用: <dataframe>[<row indices>, <column indices>]
df1[, 1] 
df1[, 2]

df1[, 'vec1']

# 通过变量名引用列（columns ，variables) via names 
df1$vec1
df1$vec2

# ---------------------------------------------------------------
# -- 练习 2 
# --- 创建一个数据框 df2, 在上述df1基础上增加了第三个变量。
# ---------------------------------------------------------------
idnum <- 1:10


# 4. 列表（Lists）
l1 <- list(idnum, df1, 2) 
class(l1)

# Referencing Components
l1[[1]] 
l1[[2]] 

class(l1[[1]])
class(l1[1])

# E. 缺失值（Missing Data）
vec4 <- c(4.6, 4.8, 5.2, 6.3, 6.8, 7.1, 7.2, 7.4, 7.5, 8.6, NA)
sum(vec4)  # Why can't the sum be calculated?
is.na(vec4) 
sum(vec4, na.rm = TRUE)
is.na(vec4)  # NA is still in the vector & only removed from the calculation


# -------------------------------------------
# -- II. Getting Started in R --
# -------------------------------------------  


# A. 设定 Working directory
getwd()  # Print the current working directory
setwd("/Users/liding/E/Bdata/2019R/data")  # 设定硬盘工作路径, 
dir() # 查看有哪些数据


# B. 读入数据(Importing Datasets) 
# 1. 读入.csv format (comma separated values) 
health <- read.csv("Dataset.csv")    
health <- read.table("Dataset.csv", sep = ",", header = TRUE)  
class(health)
# 或者 直接写入路径
# read.csv("/Users/liding/E/Bdata/2019R/data/Dataset.csv")   


# 2. 读入.txt 格式
# read.table("Dataset.txt", sep = " ")

# C. 使用程序包（Packages）
library() 			# Check all packages installed
search() 			  # Check pagkages currently loaded

# 1.如何 install Package？
# - Step1: install.packages("name of package")
# - Step2: library(name of package) 

# 2.用 "readr" 包可以更快读入文本文件
# Save dataset.csv as text file Dataset.txt and use "readr" to re-import
read_table('Dataset.txt') # when your data are separated by one or more spaces
read_delim('Dataset.txt', delim = '\t')
read_csv('Dataset.csv')  


# 3. 读入 SAS, SPSS, and Stata格式文件: package "haven"
# install.packages("haven")
# library(haven)
# read_spss("Dataset.sav")
# read_dta("Dataset.dta")
# read_sas("Dataset.sas7bdat)


# 4. 读入 Excel文件 
# install.packages("readxl")
# package reads both xls and xlsx files
# library(readxl)
# read_excel("Dataset.xlsx")


# D. 写出文件（Export data file ）
write.csv(health, "IntrotoR.final.csv", row.names = FALSE) 

# 或者使用readr包
# write_csv(health, 'healthExam.csv')

# 使用haven包写出 SPSS or Stata 文件
# write_spss(health, "my_spss.sav")
# write_dta(health, "my_stata.dta")

# -------------------------------------------
# -- III. 数据管理 Dataset Manipulation--
# -------------------------------------------  

# A. 设定变量名 Column (Variable) names 
names(health)
names(health)[5:10] <- c("food", "smoke", 
                                 "exercise", "happy",
                                 "alcohol", "doctor")

# renameby variable name: 
# names(health)[names(health)=='health1'] <- "food"


# B. 处理缺失值 Working with Missing Data
health$age

which(health$age == -1)
health$age[which(health$age == -1 )] <- NA
is.na(health$age)
table(is.na(health$age))

mean(health$age)
mean(health$age, na.rm = TRUE)

# C. 创建变量 Computing Variables 
		
# Create New Variable - Sum of the 6 health variables
health$health_sum <- rowSums(health[5:10])

# Alternative method：apply 函数
apply(health[, 5:10], 1, sum) # variance by column: apply(health[, 5:10], 2, var)

# 创建平均健康得分 Create Average Health Score
health$health_avg <- health$health_sum / 6

# 删除变量 Drop variable
health$health_avg <- NULL

# ---------------------------------------------------------------
# -- Exercise 3 
# --- a. 将df2中的字符变量充命名为 'city' 数字变量为 'rate'
# --- b. 在df2中创建一个新变量等于rate的平方除以idnum 
# ---------------------------------------------------------------


# D. Recode a Continuous Variable into a New Categorical Variable
summary(health$age) 			
health$age_cat[health$age <= 32.5] <-"Group 1"
health$age_cat[health$age > 32.5 & health$age <= 50] <- "Group 2"
health$age_cat[health$age > 50] <-"Group 3"

	
# E. Recode function within the "car" package - From continuous to continuous

# install.packages("car")
# library(car)
# health$health22 <- recode(health$smoke, "1=5;2=4;3=3;4=2;5=1")
# health$health55 <- recode(health$alcohol, "1=5;2=4;3=3;4=2;5=1")

# F. Subsets of a Data Frame 

# Subsets by specifying the column name:
health[1:3, c("id", "gender", "smoke")]

# Subsets by specifying the row ###
health$age
which(health$age > 40)  # Returns indices of rows where logical statement is TRUE
which(health$age > 40 & health$age < 50)
which(health$age < 25 | health$age > 50)

sub1 <- health[which(health$age > 40), c("age","smoke")]
sub2 <- subset(health, age > 40, select = c("age","smoke"))
			
sub1 - sub2
# ---------------------------------------------------------------
# -- Exercise 4 
# --- Using df2, create a subset called e4 which contains only the observations with a rate between 5 and 7 
# ---------------------------------------------------------------

# -------------------------------------------
# -- V. Descriptive Statistics --
# ------------------------------------------- 

summary(health) 
summary(health$age)

# A. Continuous variable : age 
mean(health$age, na.rm = TRUE)
median(health$age, na.rm = TRUE)
sd(health$age, na.rm = TRUE)
quantile(health$age, na.rm = TRUE)


# B.  Categorical variable : gender 
table(health$gender)
prop.table(table(health$gender))

table(health$gender, health$age_cat)  

# Try it with margin.table as well 
margin.table(table(health$gender, health$age_cat), 1)
margin.table(table(health$gender, health$age_cat), 2)

# Question: how to find the row and column frequencies?

prop.table(margin.table(table(health$gender, health$age_cat), 1))
prop.table(margin.table(table(health$gender, health$age_cat), 2))

# C. Correlation 
cor(health[5:9])
plot(health[5:9])

# ---------------------------------------------------------------
# -- Exercise 5 
# --- Using df2, create an appropriate set of statistics for the rate variable 
# ---------------------------------------------------------------
	

# ----------------------
# -- VI. Graphics --
# ----------------------

# Boxplot
boxplot(health_sum ~ gender, ylab = "Sum Score", xlab = "Gender", 
        data = health)    

# par( ) function, you can include the option mfrow = c(nrows, ncols) 
# plots that are filled in by row.
par(mfrow = c(2, 2))
boxplot(food ~ gender, ylab = "How much organic food is in your diet?",
        xlab = "Gender", data = health)  
boxplot(smoke ~ gender, ylab = "How many cigarettes do you smoke per week?",
        xlab = "Gender", data = health)  
boxplot(exercise ~ gender, ylab = "How often do you exercise?",
        xlab = "Gender", data = health)  
boxplot(happy ~ gender, ylab = "How happy are you in your life?",
        xlab = "Gender", data = health)  


# Barplot, histogram, boxplot, scatterplot : A total of 6 plots in a window 
par(mfrow = c(3, 2))
barplot(table(health$gender))
plot(health$age, ylab = "Age of Participants")
hist(health$age, col = "blue", breaks = 20, xlab = "Age", 
     main = "Participants")
boxplot(age ~ gender, data = health)
plot(smoke ~ food, pch = "*", data = health)
plot(jitter(smoke) ~  jitter(food), pch = 20, col = rainbow(30), # change pch = 10, change col="red"
     xlab = "How much organic food is in your diet?",
     ylab = "How many cigarettes do you smoke per week?",
     main = "Healthy Life Style", data = health)
par(mfrow = c(1, 1)) #reset the matrix 


# For more advanced graphs: "ggplot2" 
install.packages("ggplot2")
library("ggplot2")
qplot(x = carat, y = price, color = cut, data = diamonds) 

# ---------------------------------------------------------------
# -- Exercise 6 
# --- Using df2, create a histogram of rate with appropriate customizations
# ---------------------------------------------------------------


# -------------------------------------------
# -- VII. Hypothesis Testing --
# ------------------------------------------- 

# Chi-square Test
chisq.test(health$gender, health$age_cat)
summary(table(health$gender, health$age_cat))

# t-test 
# One sample t test
t.test(health$health_sum, mu=3)
# Independent 2 group t test where y is numeric and x is a binary factor
t.test(health_sum ~ gender, data = health)
# Paired t test
t.test(health$food, health$smoke, paired = TRUE) 
tResults <- t.test(health$food, health$health, paired = TRUE) 
summary(tResults)
tResults$statistic
tResults['statistic']

# Linear Regression Model
lm_health <- lm(health_sum ~ age + gender, data = health)
summary(lm_health)
par(mfrow = c(2, 2))
plot(lm_health)
confint(lm_health)

# ANOVA 
aov_health <- aov(health_sum ~ state + gender, data = health)
summary(aov_health)

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
		

# ---------------------------------------------------------------
# References 
# 1.Modern Applied Statistics with S-PLUS, 2nd Edition, W.N. Venables & B.D. Repley 
# 2.Linear Models with R, Julian J. Faraway 
# 3.Quick-R : http://www.statmethods.net 
# 4.NYU Data Services: data.services@nyu.edu
# ---------------------------------------------------------------
