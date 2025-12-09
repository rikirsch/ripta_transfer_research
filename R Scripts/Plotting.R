#'Plotting Transfers by Route
#'@description Plotting the number of transfers for a route, placement of 
#'the dots are based on latitude and longitude, size of the dot is based on average 
#'(average) number of transfers, and the color of the dot is based on the
#' point of day with most transfers
#'@param res_df dataframe, one day of RIPTA arrival data
#'@return plot of the number of transfers at each stop along a route on the 
#'specified day/day of the week, highlighting the time of day when there are the
#' most transfers possible at each stop and the average, average number of transfers
plotting_transfers <- function(res_df, day, route_number, from_or_to){
  
  #To include the Route names in the title
  #route_names <- as.character((route_number[1]:route_number[length(route_number)]))
  
  #To fill discrete, must factor
  res_df$Route <- as.factor(res_df$Route)
  
  #create the plot
  res_plot <- ggplot(res_df) +
    #add the geometric properties, alpha to have more translucent points
    #to see number of times a route comes to that stop through opacity
    #color depends on route number and size depends on the number of transfers
    #Due to the flexibility of the code, I am not setting the colors directly
    geom_point(aes(StopLng, StopLat, size = num_transfers, color = Route), alpha = 0.25) +
    
    #Update the name of the size legend
    scale_size_continuous(name = "Number of Transfers") +
    
    #update the x and y axis titles and add a title
    labs(title = paste("Number of Possible RIPTA Transfers", from_or_to, "Listed Routes on", day, "at each Stop, based on"),
         x = "Longitude",
         y = "Latitude") +
    
    theme_minimal() +
    theme(legend.title = element_text(size = 7),
          plot.title = element_text(size = 10))
  return(res_plot)
}

#Need to update the title to say all route numbers from the vector
#Need to update the points to be color = Route
#Need to update the legend title
#can I add an image of RI behind the plot? Would be helpful to also have county lines
