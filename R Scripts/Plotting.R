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
  res_plot <- ggplot(res_df) +
    geom_point(aes(StopLng, StopLat, size = num_transfers, color = Route), alpha = 0.25) +
    #scale_color_gradient(breaks = seq(0,10,2), low = "red", 
    #                    high = "green", "Number of Transfers") +
    labs(title = paste("Number of Possible RIPTA Transfers", from_or_to, "Route", route_number, "on", day, "at each Stop"),
         x = "Longitude",
         y = "Latitude",
         legend = "Number of Transfers") +
    theme_minimal() +
    theme(legend.title = element_text(size = 7),
          plot.title = element_text(size = 7))
  return(res_plot)
}

#Need to update the title to say all route numbers from the vector
#Need to update the points to be color = Route
#Need to update the legend title
#can I add an image of RI behind the plot? Would be helpful to also have county lines
