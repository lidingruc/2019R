# ---------------------------------------------------------------
# -- Exercise Solutions  --
# Of course there is always more than 1 solution, below are just examples
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# -- Exercise 1 
# --- Create a vector called e1 which is a sequence of 1 to 10, repeating 5 times 
# ---------------------------------------------------------------

e1 <- rep(1:10, times = 5)

v <- c(1:10)
e1 <- rep(v, times = 5)


# ---------------------------------------------------------------
# -- Exercise 2 
# --- Create a data frame called df2, which adds a third variable (idnum, see below) to df1
# ---------------------------------------------------------------
vec1 <- c(4.6, 4.8, 5.2, 6.3, 6.8, 7.1, 7.2, 7.4, 7.5, 8.6)    
vec2 <- c('BJ', 'SH', 'SZ', 'TJ', 'WH', 'CS', 'JN', 'CQ', 'CD', 'ZZ')
df1 <- data.frame(vec1, vec2)
idnum <- seq(from = 1, to = 10)
df2 <- data.frame(idnum, df1)

# ---------------------------------------------------------------
# -- Exercise 3 
# --- a. In df2, rename vec1 'rate' and rename vec2 'state'
# --- b. Create a new variable in df2 called e3, which is the sqrt of rate, divided by the idnum 
# ---------------------------------------------------------------
names(df2)[2:3] <- c('rate', 'city') 
df2$e3 <- sqrt(df2$rate) / df2$idnum

names(df2)[names(df2) %in% c("vec1","vec2")]<-c('rate', 'city') 

# ---------------------------------------------------------------
# -- Exercise 4 
# --- Using df2, create a subset called e4 which contains only the observations with a rate between 5 and 7 
# ---------------------------------------------------------------

e4 <- subset(df2, rate > 5 & rate < 7)

# ---------------------------------------------------------------
# -- Exercise 5 
# --- Using df2, create an appropriate set of statistics for the rate variable 
# ---------------------------------------------------------------

summary(df2$rate)
mean(df2$rate)
max(df2$rate)
quantile(df2$rate)

# ---------------------------------------------------------------
# -- Exercise 6 
# --- Using df2, create a histogram of rate with appropriate customizations
# ---------------------------------------------------------------

hist(df2$rate, xlab = "Rate", main = "Histogram of Rate", col = "green")
