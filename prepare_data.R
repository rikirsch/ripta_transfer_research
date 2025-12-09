#source(find_num_transfers)
#source(Plotting)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(hms)

#' Cleaning the Initial Data
#' @description Clean the initial data and create a subset of the data by the day
#'  and the type of time to compare (Scheduled, Arrival), 
#'  calculate the average arrival time of each stop
#' @param full_data dataframe, the full bus data
#' @param type_of_time string, "Scheduled.Time" or "Arrival.Arrival.Time" decides
#' what column will be used to calculate the number of transfers,
#' eg: do you want to know the theoretical number of transfers with this schedule
#' or the number of transfers that are possible based on the actual arrival times?
#' @param day chr, the date that the number of transfers is calculated for
#' @return cleaned_data dataframe of polished and complete bus routes used to 
#' calculate the number of transfers for the bus route on the specified day
clean_data <- function(full_data, 
                       type_of_time, 
                       day, 
                       route_number, 
                       transfer_wait_time = 15, 
                       from_to = TRUE){
  cleaned_data <- full_data %>%
    #mutate all dates and times as needed
    mutate(Date = as.Date(Date),
           Weekday = weekdays.Date(Date),
           type_of_time = as.POSIXct(eval(as.name(type_of_time)), format = "%Y-%m-%d %H:%M:%S", tz = "EST"),
           Time = type_of_time)
  
  #check to see if finding the trasfers for a specific date or for a day of the week
    if(day %in% c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")){
      #filter to the specified day of the week
      cleaned_data <- cleaned_data %>%
        filter(Weekday == day)
    } else{
      #filter to the specified date
      cleaned_data <- cleaned_data %>%
        filter(Date == day)
    }
  
  #select the columns of interest
  cleaned_data <- cleaned_data %>%
    select(c(Date, Route, Stop, Stop.Sequence, Time, StopLat, StopLng))
 
  #Update time to be the average arrival time on each route and stop
  cleaned_data <- cleaned_data %>%
    #group by parameters of interest, hour is used to differentiate between
    #the multiple times that a route is run a day
    group_by(hour(Time), Route, Stop, Stop.Sequence, StopLat, StopLng) %>%
    #calculate the average arrival time
    summarize(Time = as.POSIXct(as_hms(mean(Time))))    %>%
    ungroup()
   
  #return(cleaned_data)
  res <- route_transfers(cleaned_data,
                         route_number,
                         transfer_wait_time,
                         from = from_to, day)
  return(res)
}

#I want to group by every 20 minutes instead of every hour to try and account for some of the weird grouping that is happening
