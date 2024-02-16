rm(list = ls())
library(tidyverse)
library(stringr)

climate_df <- read.csv("GlobalLandTemperaturesByState.csv")
honey_df <- read.csv("honeyproduction.csv")

#---------------Climate change dataset cleaning-----------------
wa_climate_df <- climate_df %>% 
  filter(Country == "United States", State == "Washington")

#remove months and dates and deleted dt column
wa_climate_df <- wa_climate_df %>% 
  mutate(date = substr(dt, 1, 4)) %>% 
  select(-dt)

# Extract year and store it as numeric
wa_climate_df <- wa_climate_df %>%
  mutate(year_numeric = as.numeric(date)) %>% 
  select(-date)

#filter 1998 - 2012
wa_climate_df <- wa_climate_df %>% 
  filter(year_numeric >= 1998 & year_numeric <= 2012)

#remove this column
wa_climate_df <- wa_climate_df %>% 
  select(-AverageTemperatureUncertainty)

#average of year temperature
#New summarized column
wa_climate_df <- wa_climate_df %>%
  group_by(year_numeric) %>%
  mutate(avg_temp = mean(AverageTemperature))

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
cleaned_df <- left_join(abv_df, wa_honey_df, by = c("State.Code" = "state", "year_numeric" = "year"))

cleaned_df <- cleaned_df %>% 
  select(-State)

#-------------Mutate new columns--------------
#Categorical, 47pounds from the internet
cleaned_df <- cleaned_df %>% 
  mutate(is_yield_above_average = yieldpercol > 47)

#Numerical variable
cleaned_df <- cleaned_df %>% 
  mutate(stocks_value = stocks * priceperlb)

write.csv(cleaned_df, file = "~/Documents/UW/Info 201/Info201-Final/cleaned_df.csv", row.names = FALSE)
