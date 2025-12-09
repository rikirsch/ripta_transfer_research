source("Plotting.R")

#' Calculate number of possible transfers on the given day for the given route
#'@description a function to find the number of transfers at each stop along a route
#'@param df_by_day dataframe, one day of RIPTA arrival data
#'@param route_num_vector vector(int), the route(s) of interest to
#' find the transfer data of
#'@param window_transfer double, the window of waiting for a transfer in minutes,
#'  default 15 minutes
#'@param from boolean, TRUE if calculating the number of buses you can transfer
#' to FROM this route, FALSE if calculating the number of buses you can use to 
#' transfer TO this route, 
#' default value is TRUE (number of buses you can get to FROM this stop)
#'@param day chr, date or day of the week that the transfer calculation is running on
#'@return res ggplot of transfer placement and count by route, based on res_df
#'from this function, res_df is a data frame with columns for Route, 
#'Stop, Stop.Sequence, Time, StopLat, and StopLng where StopLat and StopLng are
#'the latitude and longitude of the Stop respectively

route_transfers <- function(df_by_day, route_num_vector, window_transfer = 15, from = TRUE, day){
  #set up the results dataframe
  res_df <- df_by_day %>%
    #filter to the routes of interest
    filter(Route %in% route_num_vector) %>%
    select(c(Route, Stop, Stop.Sequence, Time, StopLat, StopLng)) %>%
    #start with no transfers for all stop, route, time combinations
    mutate(num_transfers = 0)
  
  #for each route in the route vector
  for(route_num in route_num_vector){
    #subset the route on the given day
    route_df <- df_by_day[df_by_day$Route == route_num, ]
    
    #if the route does not run on this day
    if(length(route_df$Route) == 0){
      #no changes
      res_df <- res_df
    }
    #if the route does run on this day
    else{
      #for each stop on the specified route (other than the first stop where people won't transfer from)
      #This does not fully address transfering TO this route, 
      #where someone could transfer to the first stop but not the last stop
      for(cur_stop in 2:length(route_df$Route)){ 
        cur_run <- route_df[cur_stop, ] #find the full current run
        
        #find the goal bus stop (station that you are looking to see if other routes come here)
        goal_stop <- route_df[cur_stop, ]$Stop
        
        #find the goal time (time you are looking to see if other routes come here)
        goal_time <- route_df[cur_stop, ]$Time
        
        #set the min and max time a bus can get to this stop to be considered a transfer
        #this will depend on if you are looking for the num transfers From or To this stop
        min_time <- ifelse(from, goal_time,
                           goal_time - minutes(window_transfer))
        max_time <- ifelse(from, goal_time + minutes(window_transfer),
                           goal_time)
        
        #for each route in the data
        for(r in unique(df_by_day$Route)){
          temp_df <- df_by_day %>%
            #if the stop is on a different route and at the goal_stop 
            #and the scheduled time on this route is within the specified window of
            #the goal_scheduled time, store these rows in a temporary data frame
            filter(Route != route_num,
                   Stop == goal_stop,
                   Time >= min_time,
                   Time <= max_time)
          
          #If the temporary data frame is null, then there are no transfers at this stop, time, and day
          if(is.null(temp_df$Route)){
            num_temp_transfers <- 0
          }
          
          #If there are transfers on this route, update the number of transfers
          #to the number of observations in the temporary data frame
          else{
            num_temp_transfers <- length(temp_df$Route)
          }
          
          #update the number of transfers in the results data frame (res_df)
          #for the given route, stop, and time (which is specified in cur_run)
          res_df <- res_df %>%
            mutate(num_transfers = 
                     case_when((Route == cur_run$Route[1]) &
                                 (Stop == cur_run$Stop[1]) &
                                 (Time == cur_run$Time[1]) ~ num_temp_transfers,
                               TRUE ~ num_transfers))
        }
      }
    }
    
    #store if checking for transfers from or to the established route as
    #characters for plotting
    from_now <- ifelse(from, "from", "to")

    #call the plotting function on the results data frame
    res <- plotting_transfers(res_df, day, route_num_vector, from_or_to = from_now)
  }
  #return the results plot
  return(res)
}

