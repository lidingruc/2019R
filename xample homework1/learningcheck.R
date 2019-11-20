library(nycflights13)
flights_sample <- flights %>% 
  filter(dest=="SFO" |carrier %in% c("HA", "AS"))
ggplot(data = flights_sample, mapping = aes(x = dest, y = air_time)) +
  geom_boxplot() +
  labs(x = "Dest", y = "Air Time")

flights %>% 
  filter(dest=="SFO" |carrier %in% c("HA", "AS")) %>% 
  group_by(dest) %>% 
  summarize(mean_time=mean(air_time,na.rm=TRUE),
            sd_time=sd(air_time,na.rm=TRUE))

library(infer)

null_distribution_movies <- movies_sample %>% 
  specify(formula = rating ~ genre) %>% 
  hypothesize(null = "independence")%>% 
  generate(reps = 1000, type = "permute") %>% 
  calculate(stat = "diff in means", order = c("Action", "Romance"))
null_distribution_movies

obs_diff_means <- movies_sample %>% 
  specify(formula = rating ~ genre) %>% 
  calculate(stat = "diff in means", order = c("Action", "Romance"))
obs_diff_means

visualize(null_distribution_movies, bins = 10) + 
  shade_p_value(obs_stat = obs_diff_means, direction = "both")

null_distribution_movies %>% 
  get_p_value(obs_stat = obs_diff_means, direction = "both")

