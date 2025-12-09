#To test out my functions

# The following commented out code chunk will produce an error if run because
#it was created to run on dataframes that do not have longitude or latitude in the data

# #can my functions run on scheduled and actual arrival times?
# #read in the full dataframe
# otp_df <- read.csv('/Users/rachelkirsch/Downloads/1560FinalProject/otp_simulated.csv')
# 
# #clean the data based on the actual arrival times and calculate the number of transfers to route 10 
# actual_otp_df <- clean_data(otp_df, "Actual.Arrival.Time", "2024-05-01")
# act_resulting_df <- route_transfers(actual_otp_df, route_num = 10, from = FALSE)
# 
# #clean the data based on the scheduled arrival times and calculate the number of transfers to route 10 
# sched_otp_df <- clean_data(otp_df, "Scheduled.Time", "2024-05-01")
# sched_resulting_df <- route_transfers(sched_otp_df, route_num = 10, from = FALSE)
# 
# #trying to run the cleaning function on a day of the week
# sched_mon_df <- clean_data(otp_df, "Scheduled.Time", "Monday")
# #data cleaning on day of the week and actual arrival time
# act_mon_df <- clean_data(otp_df, "Actual.Arrival.Time", "Monday")
# #calculate the transfers for the more advanced dataframe 
# #(day of week and actual arrival time)
# res_act_mon_transfers <- route_transfers(act_mon_df, route_num = 10)


#The following commented out chunk of code no longer runs because
#I have updated the data structure of my program and the dependence between scripts

#Run the data cleaning function and the transfer calculator function on the csv
#with latitude and longitudinal data
otp_long_ltd <- read.csv('/Users/rachelkirsch/Downloads/1560FinalProject/otp_sim_lat_long.csv')
# ripta_df_long_lat <- clean_data(otp_long_ltd, "Actual.Arrival.Time", "Thursday")
# res_long_lat <- route_transfers(ripta_df_long_lat, route_num = 10, from = FALSE, day = "Thursday")
# 
# sun_ripta_df_long_lat <- clean_data(otp_long_ltd, "Actual.Arrival.Time", "Sunday")
# sun_route_transfers(ripta_df_long_lat, route_num = 10, from = FALSE, day = "Sunday")
# 
# mon_ripta_df_long_lat <- clean_data(otp_long_ltd, "Actual.Arrival.Time", "Monday")
# mon_route_transfers(ripta_df_long_lat, route_num = 10, from = FALSE, day = "Sunday")



#Running the clean_data function now that it calls route_transfers which calls plotting_transfers
thurs_rt10_transf_plot <- clean_data(otp_long_ltd,
                                     type_of_time = "Actual.Arrival.Time", 
                                     day = "Tuesday", 
                                     route_number = 10, 
                                     transfer_wait_time = 15, 
                                     from_to = TRUE)
ggsave("/Users/rachelkirsch/Downloads/1560FinalProject/ripta_transfer_research/Results/Sunday_Actual_Rt10_Transfer_Plot.png", 
       plot = thurs_rt10_transf_plot,
       width = 7, height = 7)

mon_rt11_transf_plot <- clean_data(otp_long_ltd,
                                   type_of_time = "Actual.Arrival.Time", 
                                   day = "Monday", 
                                   route_number = 11, 
                                   transfer_wait_time = 15, 
                                   from_to = TRUE)
ggsave("/Users/rachelkirsch/Downloads/1560FinalProject/ripta_transfer_research/Results/mon_actual_rt11_transf_plot.png", 
       plot = mon_rt11_transf_plot,
       width = 7, height = 7)

sapply(otp_long_ltd$Route, clean_data)