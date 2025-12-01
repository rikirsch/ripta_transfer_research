#This is where I will calculate the number of possible transfers for each stop,
#on each route, at each time, on each day of the week.

#' Calculate number of possible transfers on the given day for the given route
#'@description a function to find the number of transfers at each stop along a route
#'@param df_by_day dataframe, one day of RIPTA arrival data
#'@param route_num double, the route of interest/to find transfers from
#'@param window_transfer double, the window of waiting for a transfer in minutes,
#'  default 15 minutes
#'@return num_transfers_df dataframe with cols:
#'  route num, stop.sequence, stop loc, stop time, number of possible transfers

route_transfers <- function(df_by_day, route_num, window_transfer = 15){
  #for each stop on the specified route in the stop.sequence
  for(s in df_by_day[df_by_day$Route == route_num, df_by_day$Stop.Sequence]){
    #if it is not the first stop
    if(s != 1){
      #find the goal bus stop (station that you are looking to see if other routes come here)
      goal_stop <- df_by_day[df_by_day$Route == route_num,
                             df_by_day$Stop.Sequence == s]
      #find the goal scheduled time (time you are looking to see if other routes come here)
      goal_scheduled_time <- df_by_day$Scheduled.Time[which(goal_stop)]
      
      #for each route in the data
      for(r in unique(df_by_day$Route)){
        #if the stop on this route is the goal_stop 
        #and the scheduled time on this route is within the specified window of
        #the goal_scheduled time
        #QUESTION: do I need to check that these are happening at the same index?
        
        #uncomment the below chunk to resume working on the if statement
        # if(df_by_day$stop[df_by_day$Route == r] == goal_stop & 
        #    df_by_day$Scheduled.Time[df_by_day$Route == r] <=
        #       goal_scheduled_time + minutes(window_transfer) &
        #    df_by_day$Scheduled.Time[df_by_day$Route == r] >=
        #       goal_scheduled_time - minutes(window_transfer)){
        #   #add (?) to the count for the number of transfers at route route_num at stop.sequence s on the specified day
        #   #instead of adding one each time the if statement is true,
        #   #use the fact that it's vectorized and add the num TRUE of the if statements
        #   #(which is the number of possible transfers for the given route/stop/time)
        # }
        
        #instead of doing the if statement, try summing where this is true:
        #this will find the number of places that this is true 
        #(the stop matches the goal stop and the time is within the transfer window)
        sum(df_by_day$stop[df_by_day$Route == r] == goal_stop & 
            df_by_day$Scheduled.Time[df_by_day$Route == r] <=
            goal_scheduled_time + minutes(window_transfer) &
            df_by_day$Scheduled.Time[df_by_day$Route == r] >=
            goal_scheduled_time - minutes(window_transfer))
      }
    }
  }
}


#Steps:
# 1. How do I find days of the week?
  # - I don't need to worry about this yet, I can just filter by one date and try this on the one date first
# 2. How do I add the transfer time window to the current format of time?
 # - Clean data first to mutate scheduled time to be in date time with format
 # "%Y-%m-%d %H:%M:%S"
 # - use the minute function to add or subtract the window in this script
# 3. How do I check for the possible transfers/am I checking the indexing right?
# 4. How do I store the number of transfers?

#later issues:
  #How do I plot this
  #How do I add in the estimated/average arrival times

#NOTES: 
# Am I using too many for loops? --> can change away from for loops if it is taking too long,
#but I don't need to start out w lapply or anything like that for the purposes of the final

