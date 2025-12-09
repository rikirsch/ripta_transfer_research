RIPTA Transfer Research

This is my final project for PHP 1560: R for Data Analysis. The following Scripts and Results address the question:
Where and when are potential transfer hubs for the Rhode Island Public Transit Authorities bus routes? These results can help dictate where to allocate funding for transfer hubs beyond Kennedy Plaza. The repository can also be used to find where bus delays are causing the most missed transfers by comparing possible transfers with scheduled bus routes and average actual arrival times.

Calculations are made based on simulated RIPTA data from May 1 2024 - May 31 2024. 

To use the program, call clean_data from the script prepare_data.R. This function will clean the data with the given parameters and call route_transfer(), which will calculate the number of transfers possible going from the specified route(s) or going to the specified route(s). The route_transfer() function will call the plotting() function to visualize these possible transfers. To create the results stored in the Results folder of this repository, see the arguments used in script Test.R. 



Parameters to specify in clean_data():

full_data: 	dataframe, the full bus data that has been read in

type_of_time: string, "Scheduled.Time" or "Actual.Arrival.Time" , 
This decides what column will be used to calculate the number of transfers and whether the arrival time is based on the scheduled time or the observed arrival time in the data.
This adds room for applications of the programing in comparing scheduled arrival times to actual arrival times and the effects the difference between the two arrival times has on the interconnectivity of Rhode Island. It also can be used to show how consistent delays at specific stations may make transportation throughout the state more difficult for RIPTA users as they don't have as many options for buses to transfer to and are therefore more limited in where they can go.

day: chr, the day(s) that the number of transfers is calculated for, this may be a single date or day of the week
If looking at a day of the week, the arrival time will be updated to show the average arrival time for a certain stop in the stop sequence. This will only have an effect if using the Actual.Arrival.Time as the Scheduled.Time is the same for each day of the week throughout the month. 

route_number vector(int), the route(s) to calculate and plot the number of transfers for
The results look at simulated route 10, 29, and 11 because they have small, medium, and high number of stops respectively.

transfer_wait_time: int, the length of time in minutes to wait for a transfer, the default is 15 minutes.
This can be changed depending on how long people are willing to wait for a transfer. This parameter may also be used to assess quick transfers compared to longer wait transfers, and the wait time can be adjusted to study how improving conditions at bus stops and having users willing to wait for longer may impact ridership.

from_to: boolean, TRUE if looking for the number of transfers possible FROM the specified route(s), FALSE if looking for the number of transfers possible TO the specified route(s), default to TRUE. This can be used to compare within a route and see if it is easier to get to the route or go somewhere else from the route. 



Understanding the Results:

Results highlight the estimated number of transfers for routes 10, 29, and 11 for each day of the week. While all of these routes run Sunday - Friday, the results show how the number of transfers along these routes still change throughout the week and especially on the weekend as other routes are added or changed depending on the day of the week and the time of day. Route 10 is missing from the Saturday plot because route 10 does not run on Saturday. The plots show the impact this has on the other routes, with smaller points representing fewer possible transfers along the other routes. 



Limitations and Future Research:  
The following are questions that are beyond the scope of this project or this class, but they would be interesting to see in future research on the topic of bus transfers.

Currently, the average arrival rates are calculated by route, stop, stop.sequence, and hour, but this does not differentiate between a route that stops as the same location twice within an hour from two instances of the same stop on different days. Going forward, this could be addressed with a moving window around the scheduled time to find other instances of the stop on different days without over-consolidating and over-simplifying the routes.

Future updates can be applied to this program to better implement sapply and apply instead of for loops. This may improve the runtime of the program, especially when using routes with many stops.

In the future, the plotting feature may be updated to reflect the time of day with the most possible transfers. This was not used in this repository because it would detract from other features of the results that I wanted to highlight. Also, it would be difficult to assign the time of day with the most possible transfers if there are similarly large numbers of possible transfers once at the beginning of the day and once at the end of the day. More work must be done to reconfigure how the results are visualized to include the time of day in the plot. Perhaps a variation of a ridge line plot could be used.

On line 44 of find_num_transfers.R, the first stop is skipped when calculating the number of transfers because it is impossible to transfer from the first stop as riders must get on the bus before they get off. This was used in an earlier addition of the code that did not allow for calculating possible transfers to the specified stop; however, this does not account for calculations of transfers TO the specified route. For the calculations of transfers TO the specified route, the calculation should discount the last stop but include the first stop as riders cannot transfer to the last stop but may transfer to the first stop. This is a limitation of the current code and is part of why the results are only looking at transfers FROM the specified lines.

Due to the flexibility of the code, I am not setting the colors of each route directly. The benefits of this are that it allows for this program to run regardless of the route number in the system. For example, if RIPTA changes the route numbers or adds a new one, this program will still run. The limitation of this flexibility is that routes do not have a consistent color across the plots. For example, in the results plots, route 10 is generally red, but in the Saturday plot, route 11 is red. Please look closely at the legend of each plot for clarification on the the color representation.

How do the possible transfers align with the actual RIPTA ridership? Are people transferring at these hubs? Future research may be done to answer these questions by looking at RIPTA ridership data along with this repository. 
