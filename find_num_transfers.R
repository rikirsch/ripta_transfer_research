#This is where I will calculate the number of possible transfers for each stop,
#on each route, at each time, on each day of the week.

#' Calculate number of possible transfers on the given day for the given route
#'@description a function to find the number of transfers at each stop along a route
#'@param df_by_day dataframe, one day of RIPTA arrival data
#'@param route_num double, the route of interest/to find transfers from
#'@param window_transfer double, the window of waiting for a transfer in minutes,
#'  default 15 minutes
#'@param from boolean, TRUE if calculating the number of buses you can transfer
#' to FROM this route, FALSE if calculating the number of buses you can use to 
#' transfer TO this route, 
#' default value is TRUE (number of buses you can get to FROM this stop)
#'@return num_transfers_df dataframe with cols:
#'  route num, stop.sequence, stop loc, stop time, number of possible transfers

route_transfers <- function(df_by_day, route_num, window_transfer = 15, from = TRUE){
  #set up the results df
  res_df <- df_by_day %>%
    filter(Route == route_num) %>%
    select(c(Date, Route, Stop, Stop.Sequence, Scheduled.Time)) %>%
    mutate(num_transfers = 0)
  
  #subset the route on the given day
  route_df <- df_by_day[df_by_day$Route == route_num, ]
 
  #for each stop on the specified route (other than the first stop where people won't transfer from)
  for(cur_stop in 2:length(route_df$Route)){ 
    cur_run <- route_df[cur_stop, ] #find the full current run
    
    #find the goal bus stop (station that you are looking to see if other routes come here)
    goal_stop <- route_df[cur_stop, ]$Stop

    #find the goal scheduled time (time you are looking to see if other routes come here)
    goal_scheduled_time <- route_df[cur_stop, ]$Scheduled.Time
  
    #set the min and max time a bus can get to this stop to be considered a transfer
    #this will depend on if you are looking for the num transfers From or To this stop
    min_time <- ifelse(from, goal_scheduled_time,
                       goal_scheduled_time - minutes(window_transfer))
    max_time <- ifelse(from, goal_scheduled_time + minutes(window_transfer),
                       goal_scheduled_time)
      
    #for each route in the data
    for(r in unique(df_by_day$Route)){
      temp_df <- df_by_day %>%
        #if the stop is on a different route and at the goal_stop 
        #and the scheduled time on this route is within the specified window of
        #the goal_scheduled time, store these rows in a temporary data frame
      filter(Route != route_num,
              Stop == goal_stop,
             Scheduled.Time >= min_time,
             Scheduled.Time <= max_time)
      
      #If the temporary data frame is null, then there are no transfers at this stop, time, and day
      if(is.null(temp_df$Route)){
        num_temp_transfers <- 0
      }
      
      #update the number of transfers to the number of observations in the temporary data frame
      else{
        num_temp_transfers <- length(temp_df$Route)
      }
      
      #update the number of transfers for the given route, stop, and time 
      #(which is specified in cur_run)
      res_df <- res_df %>%
        mutate(num_transfers = 
                 case_when((Route == cur_run$Route[1]) &
                           (Stop == cur_run$Stop[1]) &
                           (Scheduled.Time == cur_run$Scheduled.Time[1]) ~ num_temp_transfers,
                           TRUE ~ num_transfers))
    }
  }
  return(res_df)
}

#Steps:
# 1. How do I find days of the week?
  # - I don't need to worry about this yet, I can just filter by one date and try this on the one date first
# 2. How do I add the transfer time window to the current format of time?
 # - Clean data first to mutate scheduled time to be in date time with format
 # "%Y-%m-%d %H:%M:%S"
 # - use the minute function to add or subtract the window in this script
# 3. How do I check for the possible transfers/am I checking the indexing right?
 # - use the filter! how you store it will decide how the indexing works (?)
# 4. How do I store the number of transfers?
 # - group by the variables of interest and then summarize, 
 # then calculate the number of transfers by finding the length of the filtered df
# 5. How do I compare transfers to the stop to transfers from the stop?
 # - add a param from = TRUE to default to showing the num transfers from this stop/route
 # this can be specified to from = FALSE to show the num transfers to this stop/route

# 6. Add functions and use lapply instead of loops! These can still be in the same script
# 7. Change the data cleaning to call the time col of interest Time so that way you
# this way you can specify if you want to look at the scheduled times or the actual arrival times in the data
# 8. Add a function called avg_arrival_time in a new script Estimation.R 
 # - function will find the avg arrival time for each route, stop, day, time over the course of the month
 # - this output/res can be used as the Time col for the num transfers input
# 9. Plotting/Comparing/using this to answer a question
 # - check out the updated df with lat and long data


#later issues:
  #How do I plot this
  #How do I add in the estimated/average arrival times

#NOTES: 
# Am I using too many for loops? --> can change away from for loops if it is taking too long,
#but I don't need to start out w lapply or anything like that for the purposes of the final

#CURRENT LEADING ISSUES:
#Ready to think about how this is answering a question now that I can find the number of transfers for 
#each stop and time for the given route/day

#possible next steps:
# break the current code into more functions and use lapply 
# plot the number of transfers in a visual way
# find the average rates for each day of the week