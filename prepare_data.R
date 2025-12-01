#source(find_num_transfers)
library(tidyverse)
library(lubridate)
#This is where I will clean the data
otp_df <- read.csv('/Users/rachelkirsch/Downloads/1560FinalProject/otp_simulated.csv') %>%
  mutate(Scheduled.Time = as.POSIXct(Scheduled.Time, format = "%Y-%m-%d %H:%M:%S", tz = "EST"))

otp_df[1,]
#otp_df[1, "Scheduled.Time"] + minute(15)

#THIS IS HOW TO ADD 15 MINUTES
seq(otp_df[1, "Scheduled.Time"], by = "15 mins", length = 1)

#How to find the transfer window:
otp_df[1, "Scheduled.Time"] - minutes(15)
otp_df[1, "Scheduled.Time"] 
otp_df[1, "Scheduled.Time"] + minutes(15)

one_day_ripta <- filter(otp_df, Date == "2024-05-01" )
route_transfers(one_day_ripta, route_num = 10)