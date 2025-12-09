  ripta_transfer_research
PHP 1560 final project on the possibility of RIPTA transfers given the current routes.


 Steps:
  1. How do I find days of the week?
    - I don't need to worry about this yet, I can just filter by one date and try this on the one date first
  2. How do I add the transfer time window to the current format of time?
   - Clean data first to mutate scheduled time to be in date time with format
   "%Y-%m-%d %H:%M:%S"
   - use the minute function to add or subtract the window in this script
  3. How do I check for the possible transfers/am I checking the indexing right?
   - use the filter! how you store it will decide how the indexing works (?)
  4. How do I store the number of transfers?
   - group by the variables of interest and then summarize, 
   then calculate the number of transfers by finding the length of the filtered df
  5. How do I compare transfers to the stop to transfers from the stop?
   - add a param from = TRUE to default to showing the num transfers from this stop/route
   this can be specified to from = FALSE to show the num transfers to this stop/route
  7. Change the data cleaning to call the time col of interest Time so that way you
  this way you can specify if you want to look at the scheduled times or the actual arrival times in the data
   - needed to use the eval(as.name(type_of_time)) function but it works!
  8. Add a function called avg_arrival_time in a new script Estimation.R 
   - function will find the avg arrival time for each route, stop, day, time over the course of the month
   - this output/res can be used as the Time col for the num transfers input
   - THIS is not done in its own function, instead it is done in the prepare_data Script
   under the clean_data function

  9. Plotting/Comparing/using this to answer a question
   - check out the updated df with lat and long data
   * figure out how to plot multiple routes on one plot (outside of function)
   * Depending on how I go about doing that:
   	* Update Data Clean to run for each given input
		* Either filter to all given inputs at once or run it one at a time
	*Update Plotting to and route_transfers to run for multiple routes if using option 1 above (more loops?)
    *Test on Rt 10 and 11
    
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

