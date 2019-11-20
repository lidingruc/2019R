# 取一个变量的lag值或者lead值

library(data.table)
set.seed(1)
data <- data.table(time =c(1:3,1:4),groups = c(rep(c("b","a"),c(3,4))),value = rnorm(7), value1=rnorm(7), value2=rnorm(7))

# 单个变量
data[, lag.value:=c(NA, value[-.N]), by=groups]
data

#多个变量
nm1 <- grep("^value", colnames(data), value=TRUE)
nm2 <- paste("lag", nm1, sep=".")

data[, (nm2):=lapply(.SD, function(x) c(NA, x[-.N])), by=groups, .SDcols=nm1]
data

#v1.9.5之后，用shift
data[, (nm2) :=  shift(.SD), by=groups, .SDcols=nm1]
data

# 多个变量
nm3 <- paste("lead", nm1, sep=".")

data[, (nm3) := shift(.SD, type='lead'), by = groups, .SDcols=nm1]
data

#
library(dplyr)
data <- 
  data %>%
  group_by(groups) %>%
  mutate(lag.value = dplyr::lag(value, n = 1, default = NA))
data

#base R
data$lag.value <- c(NA, data$value[-nrow(data)])
data$lag.value[which(!duplicated(data$groups))] <- NA
data


