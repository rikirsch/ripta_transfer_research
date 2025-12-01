#This is where I will calculate the number of possible transfers for each stop,
#on each route, at each time, on each day of the week.

#NOTES: 
  # I will need to figure out how to clean the Scheduled.Time to add on the specified_window 
  # How am I storing this data?
  # Am I using too many for loops? Can I do this with vectorized functions?


#a function to find the number of transfers at each stop along a specified route on a specified day
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
        #and the scheduled time on this route is within the specified window of the goal_scheduled time
        if(df_by_day$stop[df_by_day$Route == r] == goal_stop & 
           df_by_day$Scheduled.Time[df_by_day$Route == r] <=
              goal_scheduled_time + window_transfer &
           df_by_day$Scheduled.Time[df_by_day$Route == r] >=
              goal_scheduled_time - window_transfer){
          #add (?) to the count for the number of transfers at route route_num at stop.sequence s on the specified day
          #instead of adding one each time the if statement is true,
          #use the fact that it's vectorized and add the num TRUE of the if statements
          #(which is the number of possible transfers for the given route/stop/time)
        }
      }
    }
  }
}