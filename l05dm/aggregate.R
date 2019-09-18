# count cases within group
# aggregate by group

require(dplyr)
set.seed(2)
df1 <- data.frame(x = 1:20,
                  Year = sample(2012:2014, 20, replace = TRUE),
                  Month = sample(month.abb[1:3], 20, replace = TRUE))

df1 %>% count(Year, Month)
df1 %>% group_by(Year, Month) %>% mutate(count = n())
df1 %>% group_by(Year, Month) %>% summarise(count = n(),mean=mean(x))

aggregate(x ~ Year + Month, data = df1, FUN = length)

df1 %>%  group_by(Year, Month) %>%mutate(np = row_number())