#To test out my functions
setwd('/Users/rachelkirsch/Downloads/1560FinalProject/ripta_transfer_research/R Scripts')
source("prepare_data.R")

#load the libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(hms)

#Run the data cleaning function and the transfer calculator function on the csv
#with latitude and longitudinal data
otp_long_ltd <- read.csv('/Users/rachelkirsch/Downloads/1560FinalProject/otp_sim_lat_long.csv')


#running the functions on vectors of route numbers 10, 29, and 11 because they 
#have small, medium, and large number of stops over the month

#run clean_data() on the full RIPTA data, function is sourced from prepare_data.R
mon_sml_transf_plot <- clean_data(otp_long_ltd,
                                  type_of_time = "Actual.Arrival.Time", 
                                  day = "Monday", 
                                  route_number = c(10, 29, 11), 
                                  transfer_wait_time = 15,
                                  from_to = TRUE)


#Repeating for Tuesday Plots
tues_sml_transf_plot <- clean_data(otp_long_ltd,
                                  type_of_time = "Actual.Arrival.Time", 
                                  day = "Tuesday", 
                                  route_number = c(10, 29, 11), 
                                  transfer_wait_time = 15, 
                                  from_to = TRUE)

#Repeating for Saturday Plots
sat_sml_transf_plot <- clean_data(otp_long_ltd,
                                   type_of_time = "Actual.Arrival.Time", 
                                   day = "Saturday", 
                                   route_number = c(10, 29, 11), 
                                   transfer_wait_time = 15, 
                                   from_to = TRUE)


#Repeating for Wednesday Plots
wed_sml_transf_plot <- clean_data(otp_long_ltd,
                                  type_of_time = "Actual.Arrival.Time", 
                                  day = "Wednesday", 
                                  route_number = c(10, 29, 11), 
                                  transfer_wait_time = 15, 
                                  from_to = TRUE)


#Repeating for Thursday Plots
thurs_sml_transf_plot <- clean_data(otp_long_ltd,
                                  type_of_time = "Actual.Arrival.Time", 
                                  day = "Thursday", 
                                  route_number = c(10, 29, 11), 
                                  transfer_wait_time = 15, 
                                  from_to = TRUE)


#Repeating for Friday Plots
fri_sml_transf_plot <- clean_data(otp_long_ltd,
                                    type_of_time = "Actual.Arrival.Time", 
                                    day = "Friday", 
                                    route_number = c(10, 29, 11), 
                                    transfer_wait_time = 15, 
                                    from_to = TRUE)


#Repeating for Sunday Plots
sun_sml_transf_plot <- clean_data(otp_long_ltd,
                                  type_of_time = "Actual.Arrival.Time", 
                                  day = "Sunday", 
                                  route_number = c(10, 29, 11), 
                                  transfer_wait_time = 15, 
                                  from_to = TRUE)


#example plot that isn't saved
clean_data(otp_long_ltd,
          type_of_time = "Actual.Arrival.Time", 
          day = "Saturday", 
          route_number = c(29), 
          transfer_wait_time = 15, 
          from_to = TRUE)