#source(Plotting)

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

route_transfers <- function(df_by_day, route_num, window_transfer = 15, from = TRUE, day){
  #set up the results df
  res_df <- df_by_day %>%
    filter(Route == route_num) %>%
    select(c(Route, Stop, Stop.Sequence, Time, StopLat, StopLng)) %>%
    mutate(num_transfers = 0)
  
  #subset the route on the given day
  route_df <- df_by_day[df_by_day$Route == route_num, ]
  
  #if the route does not run on this day
  if(length(route_df$Route) == 0){
    res_df <- df_by_day %>%
      filter(Route == route_num) %>%
      select(c(Route, Stop, Stop.Sequence, Time, StopLat, StopLng)) %>%
      mutate(num_transfers = 0)
    res <- plotting_transfers(res_df, day, route_num, from_or_to = "From")
  }else{
    #for each stop on the specified route (other than the first stop where people won't transfer from)
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
                               (Time == cur_run$Time[1]) ~ num_temp_transfers,
                             TRUE ~ num_transfers))
      }
    }
    #call the plotting function on the results data frame
    res <- plotting_transfers(res_df, day, route_num, from_or_to = "From")
  }
  #return the results plot
  return(res)
}

# 10. create and store results that answer my question
# 11. Update comments (ESPECIALLY ROXYGEN)

#Potential Steps:
#1. one plot per route with dots in 7 colors for the 7 days of the week 
# - could create a plot for route 10 (confirmed minimal stops) 
# a plot for route 11 (confirmed medium/high number of stops)
# and a plot for route 66 (confirmed most stops currently)
# - cons: overlapping colors might make it hard to see frequency per day/muddy the restults
# / currently, the opacity shows roughly how many times the bus stops at the given stop, 
#and we would lose that looking at one route over multiple days on one plot

#2 one plot per day of the week (7 plots) with three different colored dots per route (run routes 10, 11, and 66)
# - cons: harder to implement? still muddied plot with the different colors 
# - pros: easier to compare routes and see more transfer hub patterns

#CURRENT LEADING ISSUES:
#how to store results and answer the initial question
