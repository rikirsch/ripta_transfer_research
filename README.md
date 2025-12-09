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

from_to: boolean, TRUE if looking for the number of transfers possible FROM the specified route(s), FALSE if looking for the number of transfers possible TO the specified route(s), default to TRUE


Understanding the Results:



Limitations and Future Research: 
    
    - Plotting the 3 once the data is adjusted shouldn't be too hard, it's just updating color = Route, the harder part is updating the data
    
    - Splitting up the plotting like this with 3 rts shown on one plot for each day of the week (and then a second set of 7 plots for scheduled arrival time transfers of the 3 rts)
    will show how routes very from each other, show where the transfer distribution is, and will show how delays/actual time vs scheduled time impact transfers
     (comparing the first 7 to the second 7)
    
  6. Add functions and use lapply instead of loops! These can still be in the same script
  -> This is giving me a lot of errors so I'm gonna continue on with the other steps for now and will do this as my
  last thing if necessary/there is time


 NOTES: 
 - Am I using too many for loops? --> can change away from for loops if it is taking too long,
 but I don't need to start out w lapply or anything like that for the purposes of the final
 
 - can't get rid of the date from the date-time fully, but it has set all of them 
 to 1970 Jan 1 so there won't be issues when trying to determine if one time is within the range of another,
 It just might not look perfect in the results and that's ok but it won't impact my findings


 CURRENT LEADING ISSUES:
 Edge case bug: will return a blank df if any of the routes don't run on the specified day
  
  
  For Future Research:
  The following are steps that are beyond the scope of this project or this class but would be interesting to see in future research on the topic:
  - How can the code be simplified using sapply instead of for loops?
  - How can the graphs also represent the time of day where the most transfers are happening?
  - How can the average arrival rates be calculated without grouping by hour to preserve multiple trips to the same stop within an hour?
  	- Should these bounds be placed around the scheduled time instead?
  - Overlay an image of Rhode Island over the plot?
  #I want to group by every 20 minutes instead of every hour to try and account for some of the weird grouping that is happening

#in the future, don't want to check the last stop if transferring to and do want to check the first stop if transferring to
    #Due to the flexibility of the code, I am not setting the colors directly (ex: rt 11 is red in one plot but rt 10 is red in the next plot)

#utalize the function more when plotting and lapply over days of the week to get all of the results in fewer lines of code
