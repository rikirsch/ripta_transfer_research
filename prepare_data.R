#source(find_num_transfers)
library(tidyverse)
library(lubridate)

#' Cleaning the Initial Data
#' @description Clean the initial data and create a subset of the data by the day
#'  and the type of time to compare (Scheduled, Arrival)
#' @param full_data dataframe, the full bus data
#' @param type_of_time string, "Scheduled.Time" or "Arrival.Arrival.Time" decides
#' what column will be used to calculate the number of transfers,
#' eg: do you want to know the theoretical number of transfers with this schedule
#' or the number of transfers that are possible based on the actual arrival times?
#' @param day chr, the date that the number of transfers is calculated for
#' @return cleaned_data dataframe of polished and complete bus routes used to 
#' calculate the number of transfers for the bus route on the specified day
clean_data <- function(full_data, type_of_time, day){
  cleaned_data <- full_data %>%
    mutate(type_of_time = as.POSIXct(Scheduled.Time, format = "%Y-%m-%d %H:%M:%S", tz = "EST"),
           Time = type_of_time) %>%
    filter(Date == day) %>%
    select(c(Date, Route, Stop, Stop.Sequence, Time))
  return(cleaned_data)
}
  


actual_otp_df <- clean_data(read.csv('/Users/rachelkirsch/Downloads/1560FinalProject/otp_simulated.csv'),
                       Actual.Arrival.Time,
                       "2024-05-01")
    
act_resulting_df <- route_transfers(actual_otp_df, route_num = 10, from = FALSE)


sched_otp_df <- clean_data(read.csv('/Users/rachelkirsch/Downloads/1560FinalProject/otp_simulated.csv'),
                           Scheduled.Time,
                           "2024-05-01")
sched_resulting_df <- route_transfers(sched_otp_df, route_num = 10, from = FALSE)
