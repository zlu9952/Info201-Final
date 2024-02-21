rm(list = ls())
library(tidyverse)
library(stringr)
library(ggplot2)

climate_df <- read.csv("GlobalLandTemperaturesByState.csv")
honey_df <- read.csv("honeyproduction.csv")

#---------------Climate change dataset cleaning-----------------
wa_climate_df <- climate_df %>% 
  filter(Country == "United States")

#remove months and dates and deleted dt column
wa_climate_df <- wa_climate_df %>% 
  mutate(date = substr(dt, 1, 4)) %>% 
  select(-dt)

# Extract year and store it as numeric
wa_climate_df <- wa_climate_df %>%
  mutate(year_numeric = as.numeric(date)) %>% 
  select(-date)

#filter 2001 - 2012
wa_climate_df <- wa_climate_df %>% 
  filter(year_numeric >= 2000 & year_numeric <= 2012)

#remove this column
wa_climate_df <- wa_climate_df %>% 
  select(-AverageTemperatureUncertainty)

#average of year temperature
#New summarized column
wa_climate_df <- wa_climate_df %>%
  group_by(year_numeric) %>%
  mutate(avg_temp =round(mean(AverageTemperature),0))

#group by year
wa_climate_df<- wa_climate_df %>% 
  select(-AverageTemperature) %>% 
  distinct()

#---------------Honey dataset cleaning-----------------
wa_honey_df <- honey_df %>% 
  filter(state == "WA")

#--------------Join Data-----------------
state_name_abv_df <- data.frame(State.Code = state.abb, State.Name = state.name)
abv_df <- left_join(wa_climate_df, state_name_abv_df, by = c("State" = "State.Name"))
cleaned_df <- left_join(abv_df, honey_df, by = c("State.Code" = "state", "year_numeric" = "year"))
cleaned_df<- na.omit(cleaned_df)
cleaned_df <- cleaned_df %>% 
  select(-State)

#-------------Mutate new columns--------------
#Categorical, 47pounds from the internet
cleaned_df <- cleaned_df %>% 
  mutate(is_yield_above_average = yieldpercol > 47)

#Numerical variable
cleaned_df <- cleaned_df %>% 
  mutate(stocks_value = stocks * priceperlb)

#Change col name
colnames(cleaned_df)[4] <- c('state')

write.csv(cleaned_df, file = "~/Desktop/cleaned_df.csv", row.names = FALSE)
#-------------ggplot-----------
#plot one
ggplot(data = cleaned_df)+
  geom_point(aes(x = year_numeric, y =priceperlb, color = state)) +
  scale_x_continuous(breaks = seq(2000, 2012, 2))

#plot two
install.packages("usmap")
library(usmap)
plot_usmap(data = cleaned_df, values = "avg_temp", include = c("AL","AR","AZ","CA","CO","FL","HI","IA","ID","IL","IN","KS","KY","LA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NJ","NM","NV","NY","OH","OK","OR","PA","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY"), color = "blue") +
  scale_fill_continuous(low = "white", high = "blue", name = "Average Temperature in US", label = scales::comma) + 
  labs(title = "United States", subtitle = "Average temperature yearly for each state") +
  theme(legend.position = "right")
