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

  6. Add functions and use lapply instead of loops! These can still be in the same script
  -> This is giving me a lot of errors so I'm gonna continue on with the other steps for now and will do this as my
  last thing if necessary/there is time


 NOTES: 
  Am I using too many for loops? --> can change away from for loops if it is taking too long,
 but I don't need to start out w lapply or anything like that for the purposes of the final

 CURRENT LEADING ISSUES:
 can't get rid of the date from the date-time fully, but it has set all of them 
 to 1970 Jan 1 so there won't be issues when trying to determine if one time is within the range of another,
 It just might not look perfect in the results and that's ok but it won't impact my findings

 REAL ISSUE:
 Since I want to keep so many columns I'm using mutate, but this means it's not
 collapsing by date and so it's keeping over 62k obsv when I want it to keep 17k,
 this means the second function (transf calc) will take forever to run and be running over duplicated data
 NEXT STEP: need to figure out how to only keep on of each combo of stop/route/time
     I have mostly fixed this using summarize, but it got rid of too many obsv,
     I think this is because there are some routes that visit the same stop
      within an hr so it uses those to estimate the average arrival time
       This is a bug that I will note in my report and mention it as a limitation/
       future improvement to be made

 When I am plotting and using lat and long I will also need to fix the data cleaning func because
  it currently doesn't select the lat and long data to keep

 many errors when trying to switch from a for loop to sapply 
  -> putting this process on hold for now and continueing with other steps
  
  
  For Future Research:
  The following are steps that are beyond the scope of this project or this class but would be interesting to see in future research on the topic:
  - How can the code be simplified using sapply instead of for loops?
  - How can the graphs also represent the time of day where the most transfers are happening?
  - How can the average arrival rates be calculated without grouping by hour to preserve multiple trips to the same stop within an hour?
  	- Should these bounds be placed around the scheduled time instead?
  - Overlay an image of Rhode Island over the plot?

