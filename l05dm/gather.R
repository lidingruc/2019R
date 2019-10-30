####################
#  gather  multiple groups of variable
#  rbind cases

# 
# 进行长宽数据转换的例子
# 一次处理多个变量时可以先将数据变成长数据然后进行处理

library(dplyr)
library(tidyr)

# From Jenny Bryan --------------------------------------------------------

input <-tribble(
  ~hw,   ~name,  ~mark,   ~pr,
  "hw1", "anna",    95,  "ok",
  "hw1", "alan",    90, "meh",
  "hw1", "carl",    85,  "ok",
  "hw2", "alan",    70, "meh",
  "hw2", "carl",    80,  "ok"
)

# Want:
input %>%
  gather(key = element, value = score, mark, pr) %>%
  unite(thing, hw, element, remove = TRUE) %>%
  spread(thing, score, convert = TRUE)

# http://stackoverflow.com/questions/33599665 -----------------------------

df <- frame_data(
  ~id, ~type,     ~transactions, ~amount,
  20,  "income",  20,            100,
  20,  "expense", 25,            95,
  30,  "income",  50,            300,
  30,  "expense", 45,            250
)

df %>%
  gather(var, val, transactions:amount) %>%
  unite(var2, type, var) %>%
  spread(var2, val)

# http://stackoverflow.com/questions/25925556 -----------------------------

anscombe %>%
  gather() %>%
  separate(key, c("var", "ex"), 1) %>%
  group_by(var) %>%
  mutate(id = row_number()) %>%
  spread(var, value)

# http://stackoverflow.com/questions/27247078 -----------------------------

df <- data_frame(
  id = 1:10,
  time = as.Date('2009-01-01') + 0:9,
  Q3.2.1. = rnorm(10, 0, 1),
  Q3.2.2. = rnorm(10, 0, 1),
  Q3.2.3. = rnorm(10, 0, 1),
  Q3.3.1. = rnorm(10, 0, 1),
  Q3.3.2. = rnorm(10, 0, 1),
  Q3.3.3. = rnorm(10, 0, 1)
)

#方法1
df %>%
  gather(-id, -time, key = key, value = value) %>%
  extract(key, c("question", "loop_number"), "(Q.\\..)\\.(.)", convert = TRUE) %>%
  spread(question, value)

#方法2
colnames(df) <- gsub("\\.(.{2})$", "_\\1", colnames(df))
colnames(df)[2] <- "Date"
res <- reshape(df, idvar=c("id", "Date"), varying=3:8, direction="long", sep="_")
row.names(res) <- 1:nrow(res)

# 方法3
df %>% 
  pivot_longer(cols = starts_with("Q3"), 
    names_to = c(".value", "Q3"), names_sep = "_") %>% 
  select(-Q3)


# http://stackoverflow.com/questions/32934400 -----------------------------

data_frame(
  id = c("v1", "v2", "v3"),
  X_a = c(1,2,3),
  X_b = c(4,5,6),
  Y_a = c(7,8,9),
  Y_b = c(10,11,12)
) %>% 
  gather(key, val, X_a:Y_b) %>% 
  separate(key, c("type", "subtype")) %>% 
  spread(type, val)

## https://github.com/jennybc/lotr
## https://github.com/datacarpentry/archive-datacarpentry/tree/master/lessons/tidy-data
x <- frame_data(
  ~Race,~Female_LoTR,~Male_LoTR,~Female_TT,~Male_TT,~Female_RoTK,~Male_RoTK,
  "Elf",        1229,       971,       331,     513,         183,       510,
  "Hobbit",       14,      3644,         0,    2463,           2,      2673,
  "Man",           0,      1995,       401,    3589,         268,      2459
)

x %>%
  gather(-Race, key = "key", value = "words") %>%
  separate(key, into = c("gender", "film")) %>%
  spread(key = "gender", value = "words")

# 批量统计多个变量
#https://community.rstudio.com/t/summarise-multiple-columns-using-multiple-functions-in-a-tidy-way/8645/9
  library(tidyverse)
  iris %>%
  select_at(vars("Species", starts_with("Petal"))) %>%
  gather(key = 'key', value = 'value', -Species) %>%
  group_by(Species, key) %>%
  summarise(mean = mean(value), min = min(value), anyNA = anyNA(value))
  
  iris %>%
  select_at(vars("Species", starts_with("Petal"))) %>%
  group_by(Species) %>%
  summarise_all(c("typeof", "anyNA", "mean")) %>%
  gather(key = "key", value = "value", -Species) %>%
  separate(key, into = c("measurement", "statistic"), sep = "[_]")


###################
## 数据的纵向合并

## 用基础命令 
#当变量名不一致时，需要先统一变量名。如果一个数据有而另一个数据没有则需要先创建空变量

hdata <- data.frame(
  id = 1:10,
  time = as.Date('2009-01-01') + 0:9,
  Q3.2.1. = rnorm(10, 0, 1),
  Q3.2.2. = rnorm(10, 0, 1),
  Q3.2.3. = rnorm(10, 0, 1),
  Q3.3.1. = rnorm(10, 0, 1),
  Q3.3.2. = rnorm(10, 0, 1),
  Q3.3.3. = rnorm(10, 0, 1)
)

gdata <- data.frame(
  id = 1:10,
  time = as.Date('2009-01-01') + 0:9,
  Q3.2.1. = rnorm(10, 0, 1),
  Q3.2.2. = rnorm(10, 0, 1),
  Q3.2.3. = rnorm(10, 0, 1),
  Q3.4.1. = rnorm(10, 0, 1),
  Q3.4.2. = rnorm(10, 0, 1),
  Q3.4.3. = rnorm(10, 0, 1)
)



#使用下面的命令
# dplyr::bind_rows() 可以设定 id,
# plyr::rbind.fill 
alldata <- plyr::rbind.fill(hdata,gdata) 
alldata <- dplyr::bind_rows(hdata,gdata) 


#统一数据框的列数，方便使用rbind进行数据合并
hvar <- names(hdata)
gvar <- names(gdata)

#最大的变量集
allvar <- union(hvar,gvar)

#缺的变量（没有考虑变量类型问题）
nothvar <- setdiff(allvar, hvar)
notgvar <- setdiff(allvar, gvar)

#生成缺失变量
ahvar <- setNames(data.frame(matrix(ncol = length(nothvar), nrow=dim(hdata) [1])),nothvar)
agvar <- setNames(data.frame(matrix(ncol = length(notgvar), nrow=dim(gdata) [1])),notgvar)

#用合并的方式将缺失变量放进去
hdata <- cbind(hdata,ahvar)
gdata <- cbind(gdata,agvar)

rm(hvar,gvar,allvar,nothvar,notgvar,ahvar,agvar)
##############
#合并主干表格
alldata <- rbind(hdata,gdata)


