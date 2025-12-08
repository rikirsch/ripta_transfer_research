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




transfers_at_stop <- function(){
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
    return(res_df) #maybe just return one line of the df and then can run this function with lapply
    #over every row in one of the df/not have it actually find the full transf df,
    #should double check what this code is currently doing it might already jsut be finding the one row I think
  }
}