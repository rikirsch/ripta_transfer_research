#To test out my functions

#can my functions run on scheduled and actual arrival times?
#read in the full dataframe
otp_df <- read.csv('/Users/rachelkirsch/Downloads/1560FinalProject/otp_simulated.csv')

#clean the data based on the actual arrival times and calculate the number of transfers to route 10 
actual_otp_df <- clean_data(otp_df, "Actual.Arrival.Time", "2024-05-01")
act_resulting_df <- route_transfers(actual_otp_df, route_num = 10, from = FALSE)

#clean the data based on the scheduled arrival times and calculate the number of transfers to route 10 
sched_otp_df <- clean_data(otp_df, "Scheduled.Time", "2024-05-01")
sched_resulting_df <- route_transfers(sched_otp_df, route_num = 10, from = FALSE)

#trying to run the cleaning function on a day of the week
sched_mon_df <- clean_data(otp_df, "Scheduled.Time", "Monday")

act_mon_df <- clean_data(otp_df, "Actual.Arrival.Time", "Monday")

  #THEN! I should create a new function called avg arrival time that will calculate
  # the avg_arrival_time for the given Date(s)
    #if only one date is given, then the avg will be the time/1 so it won't change
    #if a day of the week is given, the the avg will be sum(time)/num(days) and it will change
    #regardless of if one date or multiple dates are specified (via day of the week),
    # the estimation function should be run
