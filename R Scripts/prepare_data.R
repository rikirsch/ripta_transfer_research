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
#' @param full_data dataframe, the full bus data that has been read in
#' @param type_of_time string, "Scheduled.Time" or "Arrival.Arrival.Time" decides
#' what column will be used to calculate the number of transfers,
#' eg: do you want to know the theoretical number of transfers with this schedule
#' or the number of transfers that are possible based on average real arrival times?
#' @param day chr, the date that the number of transfers is calculated for,
#' single date or day of the week
#' @param route_number vector(int), the route(s) to calculate and plot
#'  the number of transfers for
#' @param transfer_wait_time int, the length of time in minutes to wait for a transfer,
#' default 15 minutes
#' @param from_to boolean, TRUE if looking for the number of transfers possible
#' FROM the specified route(s), FALSE if looking for the number of transfers
#' possible TO the specified routes, 
#' default to TRUE
#' @return ggplot of the number of possible transfers from/to the specified routes,
#' on the specified days, x,y are latitude and longitude of the city
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
           type_of_time = as.POSIXct(eval(as.name(type_of_time)),
                                     format = "%Y-%m-%d %H:%M:%S", tz = "EST"),
           Time = type_of_time)
  
  #check to see if finding the transfers for a specific date or a day of the week
  if(day %in% c("Sunday", "Monday", "Tuesday", "Wednesday",
                "Thursday", "Friday", "Saturday", "Sunday")){
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
  
  #results are the calculated route transfers, route_transfers will call the plotting function
  res <- route_transfers(cleaned_data,
                         route_number,
                         transfer_wait_time,
                         from = from_to, day)
  
  #return the plotted possible transfers
  return(res)
}
