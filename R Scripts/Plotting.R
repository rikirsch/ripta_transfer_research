#'Plotting Transfers by Route
#'@description Plotting the number of transfers for a route, placement of 
#'the dots are based on latitude and longitude, size of the dot is based on 
#'number of possible transfers, and the color of the dot is based on the
#'route number
#'@param res_df dataframe, one day of RIPTA arrival data, includes a column
#' with the number of possible transfers for the given observations,
#' is the results of route_transfers() from the find_num_transfers.R script
#'@param day chr, day of the week or date to plot the transfers for
#'@param route_number vector(int), route(s) to calculate the number of possible
#'transfers for
#'@param from_or_to chr, "From" or "To" if plotting the possible transfers from
#'or to the given stop
#'@return plot of the number of transfers at each stop along route (s) on the 
#'specified date/day of the week, highlighting the relationship between transfer
#'hubs and space and frequency of stops and transfers from opacity and size
plotting_transfers <- function(res_df, day, route_number, from_or_to){
  #To fill discrete, must factor
  res_df$Route <- as.factor(res_df$Route)
  
  #create the plot
  res_plot <- ggplot(res_df) +
    #add the geometric properties, alpha to have more translucent points
    #to see number of times a route comes to that stop through opacity,
    #color depends on route number, and size depends on the number of transfers
    #Due to the flexibility of the code, I am not setting the colors directly
    geom_point(aes(StopLng, StopLat, size = num_transfers, color = Route), alpha = 0.25) +
    
    #Update the name of the size legend
    scale_size_continuous(name = "Number of Transfers") +
    
    #update the x and y axis titles and add a title
    labs(title = paste("Number of Possible RIPTA Transfers",
                       from_or_to, "Listed Routes on",
                       day, "at each Stop, based on"),
         x = "Longitude",
         y = "Latitude") +
    
    #update the theme and the text size
    theme_minimal() +
    theme(legend.title = element_text(size = 7),
          plot.title = element_text(size = 10))
  
  #return the plot
  return(res_plot)
}

