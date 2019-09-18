# bysort 处理
########################
# 一个数据处理的例子
#bysort categrory : gen 的R版本
#bysort vect:gen n=_n
#bysort category: gen var1 = _n==1
#category    var1     var2     var3     var4     var5    var6   
#a            1        1        0        3       n/a      n/a
#a            2        0        0        3        1        1
#a            3        0        1        3        1        1
#b            4        1        0        4        1       n/a
#b            6        0        0        4        2        2
#b            8        0        0        4        2        2
#b           10        0        1        4        2        2
#c           11        1        0        3        1       n/a
#c           14        0        0        3        3        3
#c           17        0        1        3        3        3

# 使用R完成上面的操作
vect=c(1,1,1,2,2,3,2,3,3,3,3,3,4)
ave(1:length(vect), vect, FUN = seq_along)
#bysort vect:gen N=_N
ave(1:length(vect), vect, FUN = length)

dat <- read.table(header = TRUE, 
                  text = 'category    var1 
                  a            1     
                  a            2    
                  a            3     
                  b            4     
                  b            6  
                  b            8   
                  b           10    
                  c           11     
                  c           14      
                  c           17')

#https://stackoverflow.com/questions/25277042/searching-for-a-straightforward-way-to-do-statas-bysort-tasks-in-r

#方法1
dat <- within(dat, {
  var6 <- ave(var1, category, FUN = function(x) c(NA, diff(x)))
  var5 <- c(NA, diff(var1))
  var4 <- ave(var1, category, FUN = length)
  var3 <- rev(!duplicated(rev(category))) * 1
  var2 <- (!duplicated(category)) * 1
})

# 方法2
library(dplyr)
dat <- dat %>%
  group_by(category) %>%
  mutate(var2 = ifelse(row_number() == 1, 1, 0))%>%
  mutate(var3 = ifelse(row_number() == n(), 1, 0)) %>%
  mutate(var4 = n()) %>%
  mutate(var6 = lag(var1, 1)) %>%
  ungroup() %>%
  mutate(var5 = lag(var1, 1))
