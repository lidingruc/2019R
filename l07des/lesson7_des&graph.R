#######################################################
#教学目标：
#一、基本的统计描述（图、表） 
#二、R作图的基本原则
#三、ggplot2作图，映射、几何对象、分组、坐标轴、标签、样式设定等
#四、基础绘图（自学）
#五、分类汇总的其他做法

# --读入数据并进行了预处理
# -------------------------------------------
### 读入数据,预处理为一般的R数据
if (!require(tidyverse)) install.packages('tidyverse')

if (!require(sjPlot))install.packages('sjPlot')
if (!require(sjmisc))install.packages('sjmisc')
if (!require(sjlabelled))install.packages('sjlablled')

if (!require(haven)) install.packages('haven')
if (!require(DT)) install.packages('DT')
if (!require(data.table))install.packages('data.table')


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
# --一、描述统计 Descriptive Statistics
# -------------------------------------------
# A.1分类变量 频次图
sjPlot::set_theme(theme.font ='STXihei' )
cgss2013 %>%
  dplyr::select(a10) %>% as_numeric %>%  
  sjPlot::plot_frq()

# sjplot(fun="frq")  # 此前的版本

cgss2013 %>%
  mutate(grp = 1) %>% 
  dplyr::select(a10,grp) %>% 
  sjPlot::sjplot(fun="grpfrq")+theme(legend.position = "none") 

# A.2分类变量 qplot
cgss2013 %>%
  qplot(a10,data=.)
#qplot(a10,data=cgss2013)

# A.3分类变量 ggplot
cgss2013 %>%
  filter(!is.na(a10)) %>% 
  ggplot(aes(x=a10))+geom_bar() +
  title("频次")+
  xlabel("")+
  ylabel("")


#B.1 分类变量频次表
cgss2013 %>% 
  sjmisc::frq(a10,out = "viewer",encoding="utf-8",show.na = FALSE)

cgss2013 %>% 
  sjmisc::frq(a281:a286,out = "viewer",show.na = FALSE)

# stata tab1 a281-a286

frq(cgss2013$a7a)
frq(cgss2013$a7a,out ="viewer",title="最高的教育水平")

#B.2 分类变量频次表频次表-叠加表
cgss2013 %>% 
  dplyr::select(a281:a286) %>% # tab_stackfrq()
  sjPlot::sjtab(fun = "stackfrq",use.viewer = TRUE
                ,show.total = TRUE) 

#批量查看因子变量的标签与频数信息
sjPlot::view_df(cgss2013[,550:577], show.frq = TRUE, show.prc = TRUE)

#包整合建议:sjtab 中放入frq 函数

#C.1分组条形图：单元格百分比
cgss2013  %>%
  dplyr::select(s5a,a2) %>% 
  #as_numeric() %>% 
  sjPlot::sjplot(fun="grpfrq")

#C.2 分组条形图：组内百分比
cgss2013  %>%
  dplyr::select(s5a,a2) %>% 
  sjPlot::sjplot(fun="xtab",margin="col",show.total=FALSE,coord.flip = FALSE,ylim=c(0,0.55)) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

#C.3 分组条形图：叠加百分比图
cgss2013  %>%
  dplyr::select(a2,s5a) %>% 
  #as_numeric() %>% 
  sjPlot::sjplot(fun="xtab",margin="col",
                 bar.pos="stack",show.total=FALSE)

cgss2013  %>%
  #mutate(a10=fct_collapse(a10,非党员=c("民主党派","共青团员","群众"))) %>% 
  dplyr::select(a2,a10) %>% 
  sjPlot::sjplot(fun="xtab",margin="row",bar.pos = "stack",show.n=FALSE)


#D.1分类变量交叉表-频次
cgss2013 %>% 
  dplyr::select(s5a,a281) %>% 
  sjPlot::sjtab(fun = "xtab") 

#D.2 分类变量交叉表-百分比

cgss2013 %>% 
  dplyr::select(s5a,a284) %>% 
  sjPlot::sjtab(fun = "xtab", use.viewer = TRUE,
                show.obs = FALSE, show.row.prc = TRUE) 

#D.3 分类变量交叉表-百分比，直接输入到console中

cgss2013 %>% 
  dplyr::select(s5a,a281) %>% 
  flat_table(margin = "row") 

sjt.xtab(cgss2013$a7a,cgss2013$a2, 
         show.obs = TRUE, show.cell.prc = FALSE, show.col.prc = TRUE,title="分性别的教育分布情况")


## 连续变量
#E.1 直方图
cgss2013  %>% dplyr::select(a3a) %>%  plot_frq( type="histogram") 

#E.2 密度图
cgss2013  %>% dplyr::select(a3a) %>%  plot_frq( type="density") 

#F.1 描述
cgss2013  %>% dplyr::select(a3a,a3b,a13,a14 ) %>% 
  descr(out="viewer") # without variable label

cgss2013  %>% dplyr::select(a3a,a3b,a13,a14 ) %>% 
  descr()

# G. Correlation 
cor(cgss2013$a8a,cgss2013$a8b,use="complete.obs")

par(family="STKaiti")
plot(cgss2013$a8a,cgss2013$a8b)


# -------------------------------------------
# --二、作图的基本原则
# -------------------------------------------
##
# 1.1、为什么要作图

#########################################################
# 一图胜千言示例1：相关散点图

data <- read.table('./data/anscombe1.txt',T)
head(data)
data <- data[,-1] # 删除第一个变量
head(data)
dim(data)

# 我们可以看原始数据，可以汇总各种指标。
colMeans(data)
rowMeans(data)
sapply(1:4,
   function(x) cor(data[,x],data[,x+4]))

# 但是，都远远不如可视化来得更为直接。
par(mfrow=c(2,2))
sapply(1:4,function(x) plot(data[,x],data[,x+4]))

#########################################################
# 一图胜千言示例2：HLM模型
# Trellis displays (implemented in lattice package; uses grid package)

library(nlme) # for data
library(lattice) # for Trellis graphics 
head(MathAchieve)
head(MathAchSchool)

# data management

Bryk <- MathAchieve[, c("School", "SES", "MathAch")]

Sector <- MathAchSchool$Sector
names(Sector) <- row.names(MathAchSchool)
Bryk$Sector <- Sector[as.character(Bryk$School)]

head(Bryk)

# 可以用join或者merge来做。

# examine 20 Catholic

set.seed(12345) # for reproducibility
cat <- with(Bryk, sample(unique(School[Sector=="Catholic"]), 20))
Cat.20 <- Bryk[Bryk$School %in% cat, ]

res <- xyplot(MathAch ~ SES | School, data=Cat.20, main="Catholic Schools",
              ylab="Math Achievement",
              panel=function(x, y){ 
                panel.xyplot(x, y)
                panel.loess(x, y, span=1)
                panel.lmline(x, y, lty=2)
              }
)
class(res)
res  # "printing" plots the object

remove(list=objects())  # clean up

#########################################################
# 一图胜千言示例3：3D动态图
# rgl 3D graphics package (by Daniel Adler and Duncan Murdoch)
# uses scatter3d() from car package
library(car)
scatter3d(prestige ~ log(income) + education | type, data=Prestige, 
          ellipsoid=TRUE, parallel=FALSE,revolution=TRUE)  

# data(Duncan, package="car")
# 加上revolutions=3表示自动旋转
scatter3d(prestige~education+income, data=Duncan, fit="linear", 
          residuals=TRUE, bg="white", axis.scales=TRUE, grid=TRUE, ellipsoid=TRUE, 
          id.method='mahal', id.n = 3, revolutions=3)

## 3D图
library(rgl)
x <- sort(rnorm(1000))
y <- rnorm(1000)
z <- rnorm(1000) + atan2(x,y)
plot3d(x, y, z, col=rainbow(1000))


#3D 曲面图
library(plyr)
library(lattice)
func3d <- function(x,y) {
  sin(x^2/2 - y^2/4) * cos(2*x - exp(y))
}
vec1 <- vec2 <- seq(0,2,length=30)
para <- expand.grid(x=vec1,y=vec2)
result6 <- mdply(.data=para,.fun=func3d)

wireframe(V1~x*y,data=result6,scales = list(arrows = FALSE),
          drape = TRUE, colorkey = F)

#########################################################
#1.2、作图的基本原则

##1. 需要事先明确可视化的具体目标
###探索性可视化
###解释性可视化

##2. 需要考虑数据和受众群体的特点
###哪些变量最重要最有趣
###受众方面要考虑阅读者的角色和知识背景
###选择合适的映射方式

##3. 在传送足够信息前提下保持简洁

##4、将变量取值映射到图形元素上
### 坐标位置
### 尺寸
### 色彩
### 形状
### 文字

# ----------------------------------------------
# - 三 利用ggplot2作图 -
# ----------------------------------------------
# ggplot2 package (by Hadley Wickham)
# 请主要参看 R4DS 第3章visulisation 和28 章
# https://r4ds.had.co.nz/data-visualisation.html
# https://r4ds.had.co.nz/graphics-for-communication.html
# https://moderndive.com/2-viz.html
#主要内容
# 数据与映射，mapping
# 几何对象，geom
# 统计转换
# 位置调整
# 坐标系统
# 图层语法
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>

library(ggplot2)
library(car)
# library(MASS) #  select 函数冲突
###################################################
# A. ggplot 函数

# 1、quick plot function
# 散点图
qplot(income,prestige, 
      xlab="Average Income",
      ylab="Prestige Score",
      geom=c("point", "smooth"),
      data=Prestige)

# 分色散点图
qplot(income,prestige, 
      color = type,
      xlab="Average Income",
      ylab="Prestige Score",
      data=Prestige) 


qplot(x = sugars, y = calories, color = as.factor(shelf),
      data = UScereal) 

# 多个图形元素
qplot(cty,hwy,
      data=mpg,
      geom=c("jitter", "smooth"))

# 分面
qplot(hwy,data=mpg,binwidth=0.5) +
  scale_x_continuous(breaks =10:45) +
  facet_wrap(~ drv, nrow = 3)


#2、ggplot function函数+ 图层

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

p1 <- ggplot(UScereal)

p <- p1 + geom_histogram(aes(x = calories)) 

print(p)
summary(p)  ## 查看p的内部结构  两层内容

ggplot(UScereal)+ 
  geom_histogram(aes(x = calories)) 


###################################################
# B. 图层 Layers 

# 利用'+'在ggplot object基层上添加图层
p1 <- ggplot(UScereal, aes(x = calories))

p1 + geom_dotplot()

p1 + geom_density() 

p1 + geom_histogram(binwidth = 30)


# 可以添加多个图层
p1 + 
  geom_histogram(binwidth = 10) +
  xlab('Calories in a Single Cup') +
  ylab('Frequency') + 
  ggtitle('Distribution of Calories in US Cereals') +
  theme_bw()


# 图层的顺序无关
p1 + 
  geom_histogram(binwidth = 10) +
  xlab('Calories in a Single Cup') +
  ylab('Frequency') +
  ggtitle('Distribution of Calories in US Cereals') + 
  theme_bw() +
  theme(text = element_text(size = 20))


# 可以添加多个 geom_function
p2 <- ggplot(UScereal, aes(x = sugars, y = calories, color = mfr))

p2  + geom_point() + geom_line()

# ggplot 可以使用哪些几何函数呢？R帮助文件查看3，ggplot 进入index 查看

###################################################
#C、 五种named graph  
# 教材I2SDR（An Introduction to Statistical and Data Sciences via R）
# 参考教材对应的章节自学
# 注意各类图形分别用在什么情况下
# scatterplots : geom_point() 连续变量*连续变量 注意alpha参数和geom_jitter() 
# linegraphs : geom_line()  时序变量*连续变量
# boxplots: geom_boxplot()  连续变量*分类变量
# histograms: geom_histogram()  连续变量 注意 bins或binwidth 参数
# barplots:geom_bar() 或者 geom_col() 分类变量 注意 position参数:簇状、叠加


###################################################
# D 扩展部分
##########
# 一、基础条形图 怎么按照频次进行排序
p <- ggplot(mpg,aes(x=class))+
  geom_bar(stat="")

#geom_bar(stat="count")
#stat="identity"
print(p)
# 方法1：作图过程中改变分类次序（不改变数据，推荐）
ggplot(mpg,
       aes(x=reorder(class,class,
                     function(x) -length(x)))) +
  geom_bar()

# 方法2：改变数据然后作图
## set the levels in order we want
theTable <- within(mpg, 
                   class <- factor(class, levels=names(sort(table(class), decreasing=TRUE))))
## plot
ggplot(theTable,aes(x=class))+geom_bar( )


#方法3：汇总后作图
fdata <- as.data.frame(sort(table(mpg$class),decreasing = TRUE))
names(fdata)<-c("class","count")
ggplot(fdata,aes(x=class,y=count)) +
  geom_bar(stat = "identity")

# 方法4：汇总后作图
fdata <- as.data.frame(table(mpg$class))
names(fdata)<-c("class","count")
ggplot(fdata,aes(x=reorder(class,-count),y=count)) +
  geom_bar(stat = "identity")


##########
# 二、频次图+分类变量
mpg$year <- factor(mpg$year)

#（1）频数叠加条形图
ggplot(mpg,aes(x=class,fill=year))+
  geom_bar(color='black')


#（2）簇状条形图
ggplot(mpg,aes(x=class,fill=year))+
  geom_bar(color='black',
           position=position_dodge())

#（3）百分比叠加图,bar的默认统计量是count
ggplot(mpg,aes(x=class,fill=year))+
  geom_bar(position='fill') 

# 我们也可以自己先汇总，然后作图
ggplot(tally(group_by(mpg, year, class)),
       aes(x = class, y = n, fill = year)) +
  geom_bar(stat="identity",position="fill") + labs(fill="year")

#（4） 变成饼图——极坐标
ggplot(mpg, aes(x = factor(1), fill = factor(class))) +
  geom_bar(width = 1)+ 
  coord_polar(theta = "y")


##########
# 三、连续变化图
data <- read.csv('./data/soft_impact.csv',T)
head(data)
library(tidyverse)
library(tidyr)
data.melt <- gather(data,key=variable,value=value,-Year )

#用reshape2命令进行数据整理
#library(reshape2)
#data.melt <- melt(data,id='Year')
ggplot(data.melt,aes(x=Year,y=value,
                     group=variable,fill=variable))+
  geom_area(color='black',size=0.3,
            position=position_fill())+
  scale_fill_brewer()


ggplot(data.melt,aes(x=Year,y=value,
                     group=variable,color=variable))+
  geom_line() +
  geom_point() +
  theme(text = element_text(family = "STKaiti")) +
  labs(color="软件类型",x="年份",y="影响力")


#################################
#四、汇总量作图
# 类似的例子
#https://stackoverflow.com/questions/22305023/how-to-get-a-barplot-with-several-variables-side-by-side-grouped-by-a-factor
#
library(ggplot2)

# 两个变量的取值
d <- data.frame(A=c(1:10), B=c(11:20))
d$ind <- seq_along(d$A)

# 分别绘制，不推荐，容易出现遮挡
ggplot(d, aes(ind, y = value, fill = variable,col=variable)) +
  geom_bar(aes(y = B, col=NA,fill = "B")
           ,stat='identity', position='dodge')+ 
  geom_bar(aes(y = A, col = "A",fill=NA)
           ,stat='identity') 

#变成长数据后作图
#library(reshape2)
#d.m <- melt(d, id.var='ind')

d.m <- gather(d,key=variable,value=value, -ind)
ggplot(d.m, aes(x=ind, y=value, fill=variable)) + 
  geom_bar(stat='identity', position='dodge')

#加上标签
ggplot(d.m,aes(x=ind,y=value,fill=factor(variable)))+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_discrete(name="Gender",
                      breaks=c("A", "B"),
                      labels=c("Male", "Female"))+
  xlab("Beverage")+ylab("Mean Percentage")


# 基于明细数据的分类汇总量作图
# 参考https://stackoverflow.com/questions/11857935/plotting-the-average-values-for-each-level-in-ggplot2

df=data.frame(score1=c(4,2,3,5,7,6,5,6,4,2,3,5,4,8),
              score2=c(4,5,3,5,7,6,5,9,4,2,3,5,4,8),
              age=c(18,18,23,50,19,39,19,23,22,22,40,35,22,16))

# 绘制其中一个变量的统计量
ggplot(df, aes(x=factor(age), y=score1)) + 
  stat_summary(fun.y="mean", geom="bar")

#绘制两个变量
df.m<- melt(df,id="age")
ggplot(df.m, aes(x=factor(age), y=value, fill=factor(variable))) +
  stat_summary(fun.y=mean, geom="bar",position=position_dodge(1))

# 也可以先汇总好，然后在ggplot中作图
temp = aggregate(list(score = df$score1), list(age = factor(df$age)), mean)
ggplot(data=temp, aes(x = age, y=score)) +
  geom_bar(stat='identity')

#####################
##五、直方图+一些调整和修正
ggplot(data=iris,aes(x=Sepal.Length))+ 
  geom_histogram()

ggplot(iris,aes(x=Sepal.Length))+ 
  geom_histogram(binwidth=0.1,   # 设置组距
                 fill='skyblue', # 设置填充色
                 colour='black') # 设置边框色

# 增加概率密度曲线 
ggplot(iris,aes(x=Sepal.Length)) +
  geom_histogram(aes(y=..density..),
                 fill='skyblue',
                 color='black') +
  stat_density(geom='line',color='black',
               linetype=2,adjust=2)

#调整平滑宽度，adjust参数越大，越平滑。
ggplot(iris,aes(x=Sepal.Length)) +
  geom_histogram(aes(y=..density..), # 注意要将y设为相对频数
                 fill='gray60',
                 color='gray') +
  stat_density(geom='line',color='black',linetype=1,adjust=0.5)+
  stat_density(geom='line',color='black',linetype=2,adjust=1)+
  stat_density(geom='line',color='black',linetype=3,adjust=2)

## 叠加的直方图,没有图标，代码重复不推荐
dat <- data.frame(xx = c(runif(100,20,50),runif(100,40,80),runif(100,0,30)),yy = rep(letters[1:3],each = 100))
ggplot(dat,aes(x=xx)) + 
  geom_histogram(data=subset(dat,yy == 'a'),fill = "red", alpha = 0.2) +
  geom_histogram(data=subset(dat,yy == 'b'),fill = "blue", alpha = 0.2) +
  geom_histogram(data=subset(dat,yy == 'c'),fill = "green", alpha = 0.2)

# 推荐code 
ggplot(dat, aes(x=xx, fill=yy)) + geom_histogram(alpha=0.2, position="identity")

# 默认是stack，不可以
ggplot(dat, aes(x=xx, fill=yy)) + geom_histogram(alpha=0.2, position="stack")


## 在直方图上面加曲线
#  定义函数
# Single histogram:
plot_histogram <- function(df, feature) {
    plt <- ggplot(df, aes(x=eval(parse(text=feature)))) +
      geom_histogram(aes(y = ..density..), alpha=0.7, fill="#33AADE", color="black") +
      geom_density(alpha=0.3, fill="red") +
      geom_vline(aes(xintercept=mean(eval(parse(text=feature)))), color="black", linetype="dashed", size=1) +
      labs(x=feature, y = "Density")
    print(plt)
  }
  
#Multiple histogram:
  
  plot_multi_histogram <- function(df, feature, label_column) {
    plt <- ggplot(df, aes(x=eval(parse(text=feature)), fill=eval(parse(text=label_column)))) +
      geom_histogram(alpha=0.7, position="identity", aes(y = ..density..), color="black") +
      geom_density(alpha=0.7) +
      geom_vline(aes(xintercept=mean(eval(parse(text=feature)))), color="black", linetype="dashed", size=1) +
      labs(x=feature, y = "Density")
    plt + guides(fill=guide_legend(title=label_column))
  }

# 使用函数
plot_histogram(iris, 'Sepal.Width')

plot_multi_histogram(iris, 'Sepal.Width', 'Species')
 

# 统计函数的用法
# 计算每个class 每个cyl出现的个数的平均数
ggplot(mpg) + 
  stat_summary(aes(x = class, y = cyl), 
               fun.y = function(x) length(x) / length(unique(x)), 
               geom = "bar")

# 在ggplot内部也可以使用使用管道函数
ggplot(mpg %>% count(class), aes(x = class, n)) + 
  geom_line(aes(group=1)) 


ggplot(mpg, aes(cty, hwy)) +
  geom_count()


#####################
##六、其他图形
#面积曲线-分类
ggplot(iris,aes(x=Sepal.Length,fill=Species)) +
  geom_density(alpha=0.5,color='gray')


# 箱子图-分类
ggplot(iris,aes(x=Species,y=Sepal.Length,fill=Species)) +
  geom_boxplot()

#小提琴图(扩展)
ggplot(iris,aes(x=Species,y=Sepal.Length,fill=Species)) +
  geom_violin()


#小提琴叠加点图(扩展)
ggplot(iris,aes(x=Species,y=Sepal.Length,
                     fill=Species)) +
  geom_violin(fill='gray',alpha=0.5)+
  geom_dotplot(binaxis = "y", stackdir = "center")


###################################################
# D. 选择和修改美学特征
# Aesthetics: x position, y position, size of elements, shape of elements, color of elements
# elements: geometric shapes such as points, lines, line segments, bars and text
# geomitries have their own aesthetics i.e. points have their own shape and size


# 在ggplot function中设定color 与 manufacturer 对应:
p2 <- ggplot(UScereal, aes(x = sugars, y = calories, color = mfr))

p2 + geom_point() 

my_colors <- c('#9ebcda', '#8c96c6', '#8c6bb1', '#88419d', '#810f7c', '#4d004b')

p2 + geom_point() + scale_color_manual(values = my_colors) 


# 或者在geom_point function中设定:
p2 <- ggplot(UScereal, aes(x = sugars, y = calories))

p2 + geom_point(aes(color = mfr))


# 给点添加标签 Adding Labels to points

# 使用 geom_text() layer
p2 + geom_point(aes(color = mfr)) + 
  geom_text(aes(label = row.names(UScereal)), hjust = 1.1)

p2 + geom_point(aes(color = mfr)) + 
  geom_text(aes(label = ifelse(calories>300,row.names(UScereal),"")), hjust = 1.1)


# 改变 point size
p2 + geom_point(aes(color = mfr), size = 4) 


# 编辑 legend

# Use the scale_color_manual() layer, and the color argument in the labs() layer 
p2 + geom_point(aes(color = mfr), size = 5) +
  labs(color = 'Manufacturer') + 
  scale_color_manual(values = c('blue', 'green', 'purple', 'navyblue', 'red', 'orange'),
                     labels = c('General Mills', 'Kelloggs', 'Nabisco', 'Post', 'Quaker Oats', 'Ralston Purina'))  + 
  theme(text = element_text(size = 30)) 


###################################################
# E. 分面 Faceting  - divide a plot into subplots based on the valuesof one or more discrete variables

# Tip: Use facets to help tell your story
# Q: How is the distribution of sugar across different shelves?
# Q: Are cereals with higher sugar content on lower shelves/at a child's eye level?

p3 <- ggplot(UScereal, aes(x = sugars))

p3 + geom_histogram(binwidth = 4)

# Each graph is in a separate row of the window
p3 + geom_histogram(binwidth = 4) + facet_grid(shelf ~ .)

# Each graph is in a separate column of the window
p3 + geom_histogram(binwidth = 4) + facet_grid(. ~ shelf)

# Finished product 
p3 + geom_histogram(fill = '#3182bd', color = '#08519c', binwidth = 4) +
  facet_grid(shelf ~ .) + theme(text = element_text(size = 20)) + 
  labs(title = 'Are Sugary Cereals on Lower Shelves?',
       x = 'Sugars (grams)', y = 'Count')


###################################################
#F、在图中添加自定义的统计量，例如Box Plots 添加中位数
p4 <- ggplot(UScereal, aes(mfr, calories))
p4 + geom_boxplot()
p4 + geom_boxplot(notch = TRUE)
p4 + geom_violin()

p4 + geom_boxplot(outlier.shape = 8, outlier.size = 4, fill = '#3182bd') + coord_flip() + 
  labs(x = 'Manufacturer', y = 'Calories') + theme_bw() + 
  scale_x_discrete(labels = c('General Mills', 'Kelloggs', 'Nabisco', 'Post', 'Quaker Oats', 'Ralston Purina'))

# Add median value to boxplot
p4_meds <- UScereal %>% group_by(mfr) %>% summarise(med = median(calories))

p4 + geom_boxplot(outlier.shape = 8, outlier.size = 4, fill = '#8c96c6') + 
  labs(x = 'Manufacturer', y = 'Calories') + theme_bw() + 
  scale_x_discrete(labels = c('General Mills', 'Kelloggs', 'Nabisco', 'Post', 'Quaker Oats', 'Ralston Purina')) + 
  geom_text(data = p4_meds, aes(x = mfr, y = med, label = round(med,1)), size = 4, vjust = 1.2)


###################################################
#G、图表风格
library("ggthemes")
p2 + geom_point(aes(color = mfr), size = 4) +
  theme_stata()



###################################################
#ggplot作图练习:使用mpg数据构建图形，下面的命令都在做什么？
#请添加上适当的批语

#
p<-ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) + geom_point()
# 
p+geom_text(aes(label=manufacturer),hjust=0, vjust=0)
#
p+geom_text(aes(label=ifelse(cty>30,manufacturer,'')),hjust=0,vjust=0)

# 不用factor函数有什么不同吗？试一试
p<-ggplot(data=mpg,mapping=aes(x=cty,y=hwy,colour=factor(year))) 
p + geom_point()

# 
p + stat_smooth() ## 平滑散点图

#下面的图，如果变成两条拟合曲线，怎么做？)

p<-ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) +
	geom_point(aes(colour=factor(year))) +
	stat_smooth()
print(p)

# 如何来控制Scale标度呈现样式，修改相关的颜色参数试试？
p<-ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) +
	geom_point(aes(colour=factor(year))) +
	stat_smooth() +
	scale_color_manual(values=c('blue2','red4'))
print(p)

#facet_wrap是在做什么？
p<-ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) +
	geom_point(aes(colour=factor(year))) +
	stat_smooth() +
	scale_color_manual(values=c('blue2','red4')) +
	facet_wrap(~year,ncol=1)
print(p)

# 下面的命令做了哪些图形改进？
p<-ggplot(data=mpg,mapping=aes(x=cty,y=hwy)) +
	geom_point(aes(colour=class,size=displ),
				alpha=0.5,position = 'jitter') +
	stat_smooth() +
	scale_size_continuous(rang = c(4,10)) +
	facet_wrap(~year,ncol=1) +
	opts(title='汽车型号与油耗')+
	labs(y='每加仑高速公路行驶距离',
		x='每加仑城市公路行驶距离',
		size='排量',
		colour ='车型')
print(p)

###################################################
#lattice包
library(lattice)
num<-sample(1:3,size=50,replace=T)
barchart(table(num))
qqmath(rnorm(100))
#单维散点
stripplot(~Sepal.Length | Species,data=iris,layout=c(1,3)) # |表示条件
#密度
densityplot(~ Sepal.Length,groups=Species,data=iris,plot.points=FALSE)
#箱子图
bwplot(Species~ Sepal.Length, data = iris)
#散点图
xyplot(Sepal.Width~Sepal.Length,groups=Species,data=iris)
#矩阵散点
splom(iris[1:4])  # 矩阵散点图
#分面直方图
histogram(~Sepal.Length | Species,data=iris,layout(c(1,2,3)))



###################################################
##其他作图包
##REmap – 动态地图
#bigvis – 大数据集的可视化
#ggsci – 为ggplot2提供科技期刊所用的绘图风格
#rCharts – 生成动态交互图

# Scatterplot Matrix
install.packages('GGally')
library(GGally)
ggpairs(UScereal[, c(2, 8, 9, 11)],
        upper = list(continuous = 'smooth', combo = 'facetdensity', discrete = 'blank') ,
        lower = list(continuous = 'cor', combo = 'box'))

# Maps
# http://bcb.dfci.harvard.edu/~aedin/courses/R/CDC/maps.html
# http://rstudio.github.io/leaflet/
# maps, choroplethr, 

#玫瑰图
set.seed(1)
#随机生成100次风向，并汇集到16个区间内
dir <- cut_interval(runif(100,0,360),n=16)
#随机生成100次风速，并划分成4种强度
mag <- cut_interval(rgamma(100,15),4) 
sample <- data.frame(dir=dir,mag=mag)
#将风向映射到X轴，频数映射到Y轴，风速大小映射到填充色，生成条形图后再转为极坐标形式即可
p <- ggplot(sample,aes(x=dir,fill=mag))+
  geom_bar()+ coord_polar()

#马赛克图（用矩形面积表示份量）	  
library(vcd)
mosaic(Survived~ Class+Sex, data = Titanic,shade=T, 
       highlighting_fill=c('red4',"skyblue"),
       highlighting_direction = "right")

## 层次树图
library(treemap)
data <- read.csv('data/apple.csv',T)
treemap(data,
        index=c("item", "subitem"),
        vSize="time1206",
        vColor="time1106",
        type="comp",
        title='苹果公司财务报表可视化',
        palette='RdBu')

library(maps)
data(us.cities) 
big_cities <- subset(us.cities,long> -130)
ggplot(big_cities,aes(long,lat))+borders("state",size=0.5,colour="grey70")+geom_point(colour="black",alpha=0.5,aes(size = pop)) 

p <-ggplot(us.cities,aes(long,lat))+
  borders("state",colour="grey70")
p+geom_point(aes(long,lat,size=pop),data=us.cities,colour="black",alpha=0.5)
