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
    select(c(Date, Route, Stop, Stop.Sequence, Time))

  #Here is where I want to call a function to find the avg arrival times of each route and stop
  #I will decide if I want this to be in this function or outside of this function
  #it might just be a few lines of summarizing/grouping/mutating, 
  #but I want to do it here so that the returned data has the Time col as the avg time
  
  #find the number of days of interest
  n_days <- length(unique(cleaned_data$Date))
  
  #issue w/not being able to change date and time into just time
  cleaned_data <- cleaned_data %>%
    group_by(hour(Time), Route, Stop) %>%
    #calculate the average time
    mutate(Time = mean(Time))   %>%
    #update the time column to exclude the date
    mutate(Time = format(Time, '%H:%M:%S'))
  
  return(cleaned_data)
}
