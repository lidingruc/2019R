# 利用RScripts演示数据分析
# 数据科学与社会研究:技术基础 2019年
# 展示R studio界面，进行数据加载和分析
# 李丁(liding@ruc.edu.cn)
# 中国人民大学社会与人口学院

###################################################
# 第一个例子
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
head(Duncan)
names(Duncan)
summary(Duncan)  # generic summary function
summary(Duncan$prestige)
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

scatterplotMatrix(~ income + education + prestige | type, data=Duncan,regLine=FALSE, smooth=list(spread=FALSE))

scatterplotMatrix(~ income + education + prestige,
                  data=Duncan, id=TRUE, smooth=list(method=gamLine))


# 可以标出图中点的标签，必须退出才能进行后面的
plot(education, income)
identify(education, income, row.names(Duncan)) # must exit from identify mode!

row.names(Duncan)[c(6, 16, 27)]

# fitting a regression
(duncan.model <- lm(prestige ~ income + education))

summary(duncan.model)  # again, summary generic
# 科学计数设定 options(scipen=10)
detach("Duncan")


#####################################
# 第一个例子
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

cgss2003 %>% 
  genTable(percent(sex)~birth,data=.) %>% 
  ftable(.,row.vars=2)

des(cgss2003)
