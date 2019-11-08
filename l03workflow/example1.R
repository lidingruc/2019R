# 利用RScripts演示数据分析
# 数据科学与社会研究:技术基础 2019年
# 展示R studio界面，进行数据加载和分析
# 李丁(liding@ruc.edu.cn)
# 中国人民大学社会与人口学院

###################################################

# -------------------------------------------
# -- I. 界面介绍  窗口分菜单简单介绍(3-5）分钟 
# 窗口布局
# 如何安装包
# 新建Rscrip文件开始介绍
# -------------------------------------------
  
# ----------------------
# -- II. R基本概念与数据元素 --
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
  
# ------------------------------------------------------------------------------------------
# -- 练习 1 
# --- 创建向量 v1 为取值1到8的重复5次的向量 
# ------------------------------------------------------------------------------------------  


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
  
# --------------------------------------------------------------------------------------------------
# -- 练习 2 
# --- 创建一个数据框 df2, 在上述df1基础上增加了第三个变量。
# --------------------------------------------------------------------------------------------------
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


###################################################
# 第一个例子
install.packages("car")
data(package="car")
library(car)
data(Duncan)
# 文件可下载：
# http://socserv.mcmaster.ca/jfox/Courses/R/ICPSR/Duncan.txt
#  ./同级目录 ../上级目录
# setwd()  # 设定路径
# Duncan<- read.table("Duncan.txt",header= TRUE) #等价
# Duncan <- read.table(file.choose(), header=TRUE)
#stata的示例数据
#library(haven)
#dose<- read_dta("http://www.stata-press.com/data/r14/dose.dta")

?Duncan # 查看包中有关数据的背景信息
Duncan
head(Duncan,10)
tail(Duncan,6)
names(Duncan)
summary(Duncan)  # generic summary function
summary(Duncan$prestige)
summary(Duncan[4])
prestige # error! 属于个数据集中 Duncan$prestige

##########################
# attaching a data frame (best avoided)
attach(Duncan)
prestige
# the search path
# R 查找的顺序，先在全局环境中查找，然后在其他加载的环境中查找。
# 加载的数据在全局环境之后
search()
# distributions and bivariate relationships
# 双变量散点图
# windows()  # for demo, not necessary in RStudio; on Mac OS X, quartz() 在Rstudio和mac中不要用。
plot(Duncan$education ~ Duncan$prestige)

hist(prestige)

pairs(cbind(prestige, income, education))

# 两两散点图、拟合线、直方图。
# 自己课后拆解理解命令过程
pairs(cbind(prestige, income, education), 
      panel=function(x, y){
        points(x, y)
        abline(lm(y ~ x), lty="dashed")
        lines(lowess(x, y))
      },
      diag.panel=function(x){
        par(new=TRUE)
        hist(x, main="", axes=FALSE)
      }
)

# 定义为一个函数，方便以后使用
# 将上面的命令封装成为一个函数，输入参数后可以多处使用
scatmat <- function(...) { # user-defined function
  pairs(cbind(...),
        panel=function(x, y){
          points(x, y)
          abline(lm(y ~ x), lty=2)
          lines(lowess(x, y))
        },
        diag.panel=function(x){
          par(new=TRUE)
          hist(x, main="", axes=FALSE)
        }
  )
}

scatmat(prestige, income, education)
# car 包中已经写好的命令
# library(car)
scatterplotMatrix(~ income + education + prestige | type, data=Duncan)

car::scatterplotMatrix(~ income + education + prestige | type, data=Duncan,regLine=FALSE, smooth=list(spread=FALSE))

car::scatterplotMatrix(~ income + education + prestige,
                  data=Duncan, id=TRUE, smooth=list(method=gamLine))


# 可以标出图中点的标签，必须退出才能进行后面的
plot(education, income)
identify(education, income, row.names(Duncan)) # must exit from identify mode!

row.names(Duncan)[c(6, 16, 27)]

# fitting a regression
(duncan.model <-  lm(prestige ~ income + education))

summary(duncan.model)  # again, summary generic
# 科学计数设定 options(scipen=10)
detach("Duncan")


#####################################
# 第二个例子
# 加载后面的分析中需要用到的包
library(tidyverse)
library(gganimate)
help(filter)
#读入数据
setwd("/Users/liding/E/Bdata/2019R/")
#setwd("Users\\liding\\E\\Bdata\\2019R\\")
gapminder <- read.csv("./data/gapminder.csv")

#初步了解数据
names(gapminder)
head(gapminder)
View(gapminder)
dim(gapminder)
table(gapminder$year)
table(gapminder$year[1:300])
table(gapminder[1:300,3])
table(gapminder[gapminder$year==2007,3])


#选择2007年数据进行分析
gap07 <- gapminder %>%
  filter(year == 2007)

# 散点图呈现GDP和预期寿命的关系
qplot(x = gdpPercap, y = lifeExp, data = gap07)

# 分大陆的关系
qplot(x = gdpPercap, y = lifeExp, color = continent, data = gap07)

# 将人口规模信息也放进去
qplot(x = gdpPercap, y = lifeExp, color = continent, size = pop,data = gap07)

# 制作动态图形的方法
ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = continent)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

# 在rmd中gif大小控制问题
# https://github.com/thomasp85/gganimate/issues/212

###################################################
# 第三个例子
# 利用R读入中文CGSS数据进行分析

library(haven)
setwd("/Users/liding/E/Bdata/2019R/l03workflow")
cgss2013<-read_spss('../data/cgss2013.sav')
cgss2003<-read_dta('../data/cgss2003.dta')
table(cgss2003$ethnic)

#定义一个函数，方便查看数据集中有哪些变量
#这样就可以像在stata中一样挑选变量进行探索和描述
des <- function (dfile) {
  lbl = sapply(dfile, attr, 'label')
  if (is.list(lbl)) {
    lbl[sapply(lbl, is.null)] = ''
    lbl[sapply(lbl, length) > 1] = ''
    lbl = unlist(lbl)
  }
  Encoding(lbl) = 'UTF-8'
  dfile_var = data.frame(var =names(dfile), lbl = lbl) 
  View(dfile_var)
}  
# 通过View数据框的方式查看有哪些变量
# as.numeric  将变量的标签吃掉了
des(cgss2003)


#1、替换特殊缺失值
cgss2003[cgss2003==-1] <- NA;cgss2003[cgss2003==-2] <- NA;cgss2003[cgss2003==-3] <- NA

#2、丢弃没有用到的取值标签（包括上面特殊缺失值标签）
cgss2003 <- sjlabelled::drop_labels(cgss2003) 
#3、label转为因子
cgss2003 <- sjmisc::to_label(cgss2003) 
# 将剩下的labelled变量转化为数值变量（原来带特殊值标签的连续变量在此），新haven包将带有label的变量标记为haven_labelled类型。
w <- which(sapply(cgss2003, class) == 'haven_labelled')
cgss2003[w] <- lapply(cgss2003[w], 
                      function(x) as.numeric(as.character(x))
)

# 加载一个统计包
library(memisc)
options(digits=3)
sex.tab <- genTable(percent(sex)~sitetype,data=cgss2003)
ftable(sex.tab,row.vars=2)
ftable(sex.tab,row.vars=1)
#出生年份，不呈现缺失值
table(cgss2003$birth) # table不能缩写
# 呈现缺失值，带总数
birthy<-table(cgss2003$birth,useNA = "ifany")
addmargins(birthy)
# 注意 NaN 表示无意义的数，例如负数开平方。与NA不同，可替换为NA


###################################################
# 第三个例子- tidyverse 风格
# 利用R读入中文CGSS stata格式数据进行分析
# tidyverse风格
# 最后将没有标签的数字变量变成数字可能出现错误
# 尚未确证 as.numeric(as.character())
# https://stackoverflow.com/questions/38809509/recode-and-mutate-all-in-dplyr
# https://stackoverflow.com/questions/3418128/how-to-convert-a-factor-to-integer-numeric-without-loss-of-information

library(haven)
setwd("/Users/liding/E/Bdata/2019R/l03workflow")
cgss2003<-read_dta('../data/cgss2003.dta') %>% 
  mutate_all(funs(replace(., . ==-1|.==-2|.==-3, NA))) %>% 
 sjlabelled::drop_labels()  %>% 
 sjmisc::to_label()  %>% 
 mutate_if(is.labelled, as.numeric)
 #mutate_if(is.labelled, as.numeric(levels(.x))[.x])
 #mutate_if(is.labelled, as.numeric(as.character(.)))

cgss2003 %>% 
  genTable(percent(sex)~birth,data=.) %>% 
  ftable(.,row.vars=2)

des(cgss2003)


###################################################
# 第四个例子- 批量读入一个文件夹中的文件
#https://www.r-bloggers.com/merge-all-files-in-a-directory-using-r-into-a-single-dataframe/
setwd("/Users/liding/Downloads/lianjia-beike-spider-master/data/ke/zufang/bj/20190920")

file_list <- list.files()

for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.csv(file, header=FALSE, sep=",")
  }
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.csv(file, header=FALSE, sep=",")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
  
}


# 方式2
# https://stackoverflow.com/questions/24819433/reading-multiple-csv-files-from-a-folder-into-a-single-dataframe-in-r
#https://stackoverflow.com/questions/9564489/opening-all-files-in-a-folder-and-applying-a-function

setwd("/Users/liding/Downloads/lianjia-beike-spider-master/data/ke/zufang/bj/20190920")
file_names <- dir() #where you have your files
your_data_frame <- do.call(rbind,lapply(file_names,read.csv,header=FALSE))

#方式3
library(data.table)  
files <- list.files(path = "/Users/liding/Downloads/lianjia-beike-spider-master/data/ke/zufang/bj/20190920",pattern = ".csv")
temp <- lapply(files, fread, sep=",",header=FALSE)
data <- rbindlist( temp )

# 汇总各个小区的房价的价格
datasum <- dataset %>% 
  mutate(V6=str_replace(dataset$V6,"平米","")) %>% 
  mutate(V6=as.numeric(V6)) %>% 
  mutate(dj=as.numeric(V7)/V6) %>% 
  group_by(V2,V3)%>%
  summarise(pdj=mean(dj,na.rm=TRUE))


# 读入数据库文件
library(RODBC)
setwd("/Users/liding/Documents/空间/data/")
#channel<-odbcConnect("mydsn",uid="user",pwd="rply") 
#channel<-odbcConnectAccess("TrainDatabase.mdb") # 不能用
channel <- odbcConnect("train") 
sqlTables(channel)
df <-sqlFetch(channel, "TrainList")
head(df)


## 如果需要使用jupyter notebook
## 可以在安装了anaconda之后，在cmd中 运行 R 然后安装下面的包
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec()

