

#' Calculate number of possible transfers on the given day for the given route
#'@description 
#'@param df_by_day_arg dataframe, one day of RIPTA arrival data
#'@param res_df_arg dataframe, results dataframe that will store the number of
#' possible transfers at the given stop, route, and day, 
#' one row of it will be updated and the entire dataframe will be returned
#'@return res_df_arg dataframe with an updated row for the given stop and route
transfers_at_stop <- function(df_by_day_arg,
                              res_df_arg,
                              min_time_now,
                              max_time_now, 
                              cur_run_arg, 
                              goal_stop_arg, 
                              goal_scheduled_time_arg, 
                              route_num_arg){
  temp_df <- df_by_day_arg %>%
    #if the stop is on a different route and at the goal_stop 
    #and the scheduled time on this route is within the specified window of
    #the goal_scheduled time, store these rows in a temporary data frame
    filter(Route != route_num_arg,
           Stop == goal_stop_arg,
           Scheduled.Time >= min_time_now,
           Scheduled.Time <= max_time_now)
  
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
  res_df_arg <- res_df_arg %>%
    mutate(num_transfers = 
             case_when((Route == cur_run_arg$Route[1]) &
                         (Stop == cur_run_arg$Stop[1]) &
                         (Scheduled.Time == cur_run_arg$Scheduled.Time[1]) ~ num_temp_transfers,
                       TRUE ~ num_transfers))
  return(res_df_arg) 
}


#Modular Coding with Multiple Functions!!!!!!

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

route_transfers_2 <- function(df_by_day, route_num, window_transfer = 15, from = TRUE){
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
    
    route_list <- unique(df_by_day$Route)
    res_df <- sapply(route_list, 
                     transfers_at_stop, 
                     df_by_day_arg = df_by_day,
                     res_df_arg = res_df,
                     min_time_now = min_time,
                     max_time_now = max_time, 
                     cur_run_arg = cur_run, 
                     goal_stop_arg = goal_stop, 
                     goal_scheduled_time_arg = goal_scheduled_time, 
                     route_num_arg = route_num)
    #for each route in the data
    #for(r in unique(df_by_day$Route)){
    #   temp_df <- df_by_day %>%
    #     #if the stop is on a different route and at the goal_stop 
    #     #and the scheduled time on this route is within the specified window of
    #     #the goal_scheduled time, store these rows in a temporary data frame
    #     filter(Route != route_num,
    #            Stop == goal_stop,
    #            Scheduled.Time >= min_time,
    #            Scheduled.Time <= max_time)
    #   
    #   #If the temporary data frame is null, then there are no transfers at this stop, time, and day
    #   if(is.null(temp_df$Route)){
    #     num_temp_transfers <- 0
    #   }
    #   
    #   #update the number of transfers to the number of observations in the temporary data frame
    #   else{
    #     num_temp_transfers <- length(temp_df$Route)
    #   }
    #   
    #   #update the number of transfers for the given route, stop, and time 
    #   #(which is specified in cur_run)
    #   res_df <- res_df %>%
    #     mutate(num_transfers = 
    #              case_when((Route == cur_run$Route[1]) &
    #                          (Stop == cur_run$Stop[1]) &
    #                          (Scheduled.Time == cur_run$Scheduled.Time[1]) ~ num_temp_transfers,
    #                        TRUE ~ num_transfers))
    # }
  }
  return(res_df)
}

