# Terms:
-- "Southwest" - Southwest Airlines Co.
-- "AA" - American Airlines Inc.
-- "Delta" - Delta Air Lines Inc.

# Question 1:
-- The managers of the Invictus Mutual Fund want to know some basic details about the data. 
-- Use fully commented SQL queries to address each of the following questions:

# How many flights were there in 2018 and 2019 separately?
SELECT YEAR(FlightDate) as Year, COUNT(*) as Total_Flights_That_Year   # show the year
FROM FLIGHTS															# from the flights table
WHERE YEAR(FlightDate) <= 2019 AND YEAR(FlightDate) >= 2018				# for the years 2018 & 2019
GROUP BY YEAR(FlightDate);                                        		# aggregate by year

# Answer: In 2018 there were 3,218,653 flights.  In 2019 there were 3,302,708 flights.


# In total, how many flights were cancelled or departed late over both years?
SELECT COUNT(*) 					# count all rows
FROM flights						# from the flights table
WHERE (
	YEAR(FlightDate) <= 2019 		# for 2019
	AND YEAR(FlightDate) >= 2018	# and 2018
	AND DepDelay > 0				# and that were late
    ) 
OR Cancelled = 1;					# or that were cancelled

# Answer: 2,633,237 flights departed late or were cancelled in 2018 and 2019.


# Show the number of flights that were cancelled broken down by the reason for cancellation.
SELECT COUNT(*) AS Number_of_Canceled_Flights, CancellationReason 	# count the total number of all rows
FROM flights 														# from the flights table
GROUP BY CancellationReason											# aggregate / group the cancellation reasons
HAVING CancellationReason IS NOT NULL								# filter out the null values
ORDER BY Number_of_Canceled_Flights DESC;


# For each month in 2019, report both the total number of flights and percentage of flights cancelled.     

SELECT                                                                              # show
	MONTH(FlightDate) AS 'Month',													# month
    COUNT(*) AS Total_Number_of_Flights,                                        	# total count
	(SUM(Cancelled) / COUNT(*)) * 100 AS Percentage_of_Cancelled_Monthly_Flights,   # percentage of cancelled flights each month
    COUNT(*) - SUM(Cancelled) AS Total_Number_of_Uncancelled_Flights				# total number of uncancelled flights
FROM FLIGHTS																		# from the flights table
WHERE YEAR(FlightDate) = 2019														# in 2019
GROUP BY MONTH(FlightDate)                                        					# aggregate by month
ORDER BY MONTH(FlightDate) ASC;                                      				# sort by month

# Question: Based on your results, what might you say about the cyclic nature of airline revenue?
# Answer: Based on the results, the total number of flights taken (total flights - cancellations) remains somewhat consistent throughout the year. 
-- There is a dip in flights in the new year, and a slight rise in the latter North American summer months. 
-- Cancellations, however, generally reduce gradually throughout the calendar year.

# Question 2
-- Create two new tables, one for each year (2018 and 2019) 
-- showing the total miles traveled and number of flights broken down by airline.

CREATE TABLE 2019_Flights AS
SELECT COUNT(*) AS Total_Number_of_Flights_2019, SUM(Distance) AS Total_Miles_Travelled_2019, AirlineName	# show total number, total distance traveled, and airline name
FROM flights																								# from the flights table
WHERE YEAR(FlightDate) = 2019                                                                               # where the year is 2019
GROUP BY AirlineName                                                                             			# group distinct airline names
ORDER BY AirlineName;

CREATE TABLE 2018_Flights AS
SELECT COUNT(*) AS Total_Number_of_Flights_2018, SUM(Distance) AS Total_Miles_Travelled_2018, AirlineName	# show: count all rows, the sum of the distance columns, and the airline name
FROM flights																								# from the flights table
WHERE YEAR(FlightDate) = 2018																				# from 2018
GROUP BY AirlineName																						# aggregate distinct airlinenames
ORDER BY AirlineName;


#  Using your new tables, find the year-over-year percent change in total flights and miles traveled for each airline.

SELECT 																		# show me
	2019_Flights.AirlineName,												# the AirlineName from the *newly created* 2019_flights table
	Total_Number_of_Flights_2018,                                           # see line 71
    Total_Number_of_Flights_2019,                                         	# see line 64
    ROUND((Total_Number_of_Flights_2019 - Total_Number_of_Flights_2018) / Total_Number_of_Flights_2018 * 100, 3) AS Year_Over_Year_Percentage_Flights_Change, # get the year-over-year percentage change for number of flights
	Total_Miles_Travelled_2018,                                             # see line 75
    Total_Miles_Travelled_2019,                                             # see line 68
    ROUND((Total_Miles_Travelled_2019 - Total_Miles_Travelled_2018) / Total_Miles_Travelled_2018 * 100, 3) AS Year_Over_Year_Percentage_Distance_Change # get the year-over-year percentage change for distance travelled
    FROM 2019_Flights
    INNER JOIN 2018_Flights                                         		# inner join, so that all rows from all tables are preserv... Wait.. Is "Inner Join" right here?!?
    ON 2018_Flights.AirlineName = 2019_Flights.AirlineName;					# inner join the two tables on the Airline Name


-- Use fully commented SQL queries to address the questions above. 
        
# Question: What investment guidance would you give to the fund managers based on your results?
-- Answer:  Southwest is the market share leader and is continuing to grow, 
-- albeit at a slower pace than their two main rival airlines AA and Delta.  
-- If current trends hold Southwest will remain the market leader for roughly 7 more years.
-- AA has increased their total number of flights without increasing their total distance travelled by an equal pace, 
-- suggesting a focus on shorter routes.  We suggest investigating the impact on profitability that shorter routes may have on an airline
-- (and, specifically, AA), as their change in approach may be a potential investment (or divestment) opportunity.  


# Question 3
-- Another critical piece of information is what airports the three airlines utilize most commonly.

# What are the names of the 10 most popular destination airports overall? 
-- For this question, generate a SQL query that first joins flights and airports then does the necessary aggregation.

SELECT AirportName AS Airport_Name, COUNT(*) AS Total_Number_of_Destination_Aiport_Flights  # show airport name, total number
FROM flights                                                                                # from the flights table
LEFT JOIN airports                                                                          # join the airports table
	ON airports.airportid = flights.destairportid
GROUP BY Airport_Name                                                                       # aggregate by airport name
ORDER BY COUNT(*) DESC
LIMIT 10;

# the names of the 10 most popular airports overall are Hartsfield-Jackson Atlanta International, Dallas/Fort Worth International, Phoenix Sky Harbor International,
-- Los Angeles International,  Charlotte Douglas International, Harry Reid International, Denver International, Baltimore/Washington International Thurgood Marshall,
-- Minneapolis-St Paul International, Chicago Midway International

-- Answer the same question but using a subquery to aggregate & limit the flight data 
-- before your join with the airport information, hence optimizing your query runtime.

SELECT AirportName AS Airport_Name, COUNT(*) AS Total_Number_of_Destination_Aiport_Flights # show ariport name, total number
FROM 
	(SELECT DestAirportID				                                                   # aggregate only the destination airports from the flight table
    FROM flights) AS f
LEFT JOIN
	(SELECT AirportID, AirportName                                                         # aggregate only the airportID and the AirportName from the airports table
    FROM airports) AS a
	ON a.AirportID = f.DestAirportID													   # join the airports and flights table
GROUP BY Airport_Name													   				   # aggregate by airport name
ORDER BY COUNT(*) DESC
LIMIT 10;

# Question:  If done correctly, the results of these two queries are the same, 
-- but their runtime is not. In your SQL script, comment on the runtime: which is faster and why? 
# Answer:  The runtimes for the NON pre-aggregated data (line 116) was 12.3 seconds and for the pre-aggregated data (line 131) 
-- was 12.5 seconds.  It was my impression that the pre-aggregated data would be faster, but it is not.


# Question 4
-- The fund managers are interested in operating costs for each airline. 
-- We don't have actual cost or revenue information available, but we may be able to infer a general overview 
-- of how each airline's costs compare by looking at data that reflects equipment and fuel costs.

-- A flight's tail number is the actual number affixed to the fuselage of an aircraft, much like a car license plate. 
-- As such, each plane has a unique tail number and the number of unique tail numbers for each airline should 
-- approximate how many planes the airline operates in total. 

# Using this information, determine the number of unique aircrafts each airline operated in total over 2018-2019.

SELECT AirlineName AS Airline_Name, COUNT(DISTINCT Tail_Number) AS Assumed_Number_of_Operational_Aircraft # show the airline name, total unique tail numbers
FROM flights                                                                                			  # from the flights table
WHERE YEAR(FlightDate) = 2018 OR YEAR(FlightDate) = 2019                                        		  # from the years 2018 and 2019
GROUP BY AirlineName                                                                                	  # aggregate by airline name
ORDER BY Assumed_Number_of_Operational_Aircraft DESC;

# Answer:  AA ran 993 aircraft, Delta ran 988 aircraft, and Southwest ran 754 aircraft in the years 2018 and 2019.


# Similarly, the total miles traveled by each airline gives an idea of total fuel costs and the 
-- distance traveled per plane gives an approximation of total equipment costs. What is the average distance traveled per aircraft for each of the three airlines?

SELECT AirlineName AS Airline_Name, SUM(Distance) AS Total_Miles_Flown # show the airline name, total miles
FROM flights                                         				   # from the flights table
WHERE YEAR(FlightDate) = 2018 OR YEAR(FlightDate) = 2019			   # in 2018 and 2019
GROUP BY AirlineName                                        		   # aggregate by airline name
ORDER BY Total_Miles_Flown DESC;

# Answer: Southwest flew 2.024 billion miles, AA flew 1.871 billion miles, and Delta flew 1.731 billion miles in 2018 and 2019.
 
# Question: compare the three airlines with respect to your findings: how do these results impact your estimates of each airline's finances?
# Answer: Southwest operates roughly 24% fewer aircraft than AA or Delta.  Yet Southwest flies 8% and 17% more miles than AA and Delta (respectively).
	-- Southwest is therefore likely to have a higher fuel expense, while AA and Delta's operating costs are weighted more towards aircraft maintenance.



# Question 5:
-- Finally, the fund managers would like you to investigate the three airlines and major airports 
-- in terms of on-time performance as well. 

-- For each of the following questions, consider early departures and arrivals 
-- (negative values) as on-time (0 delay) in your calculations.

# Next, we will look into on-time performance more granularly in relation to the time of departure. 
-- We can break up the departure times into three categories as follows:
CASE
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
    ELSE "4-night"
END AS "time_of_day"

-- Find the average departure delay for each time-of-day across the whole data set. 

SELECT AVG(DepDelay) AS Average_Departure_Delay,						# show average departure delay
CASE                                                                    # segment by departure period
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN 'Morning (7-11)'
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN 'Afternoon (12-16)'
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN 'Evening (17-21)'
    ELSE 'Night (all other times)'
END AS Time_of_Day                                                      
FROM flights                                                           # from the flights table                                   
WHERE DepDelay > 0                                                     # that have delayed flights
GROUP BY Time_of_Day                                                   # aggregate by departure period
ORDER BY Average_Departure_Delay DESC;

# Question: Can you explain the pattern you see?
# Answer:  Evening flights (35.9 mins) are significantly more delayed on average than 
-- afternoon flights (29.9 mins), night flights (29.5 mins) or morning flights (25.8 mins).
-- I can hypothesize that delays earlier in the day would have knock-on effects, causing evening flights to be 
-- impacted by preceeding delays that day.  This, however, is just a hypothesis.  

# Now, find the average departure delay for each airport and time-of-day combination.
        
SELECT AVG(DepDelay) AS Average_Departure_Delay, airports.AirportName AS Airport_Name, # take the average departure dealy
CASE                                                                                  # separate these into 4 segments of flights
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN 'Morning (7-11)'
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN 'Afternoon (12-16)'
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN 'Evening (17-21)'
    ELSE 'Night (all other times)'
END AS Time_of_Day
FROM flights																			# from the flights table
	LEFT JOIN airports                                                                  # left-join the table
	ON airports.airportID = flights.OriginAirportID										# join the tables on the airportID from the airline table and the OriginAirprotID from the flight table
WHERE DepDelay > 0																		# for flights that were delayed
GROUP BY Airport_Name, Time_of_Day;														# segment these into the airport name, and the time of day

# Next, limit your average departure delay analysis to morning delays and airports with at least 10,000 flights.

SELECT AVG(flights.DepDelay) AS Average_Departure_Delay, 				# show the average departure delay
       airports.AirportName AS Airport_Name								# show the airport name
FROM flights                                        					# from the flights table
INNER JOIN airports ON airports.airportID = flights.OriginAirportID		# join the airports and flights table
INNER JOIN (
    SELECT OriginAirportID, COUNT(*) AS Total_Flights
    FROM flights
    GROUP BY OriginAirportID
    HAVING COUNT(*) > 10000												# filter for only those OriginAirportID's that have 10,000+ flights
) AS AirportFlightCounts ON AirportFlightCounts.OriginAirportID = flights.OriginAirportID
WHERE flights.DepDelay > 0												# where flights are delayed
  AND HOUR(flights.CRSDepTime) BETWEEN 7 AND 11							# that departed in the morning
GROUP BY airports.AirportName											# aggregate by the airport name
ORDER BY Average_Departure_Delay DESC;

# Answer:  Luiz Munoz Marin Internation had the highest average departure delays at 48.775.


# By extending the query from the previous question, name the top-10 airports 
-- (with >10000 flights) with the highest average morning delay. 

WITH AirportFlightCounts AS (                                         # Pre-filter out the cities with fewer than 10000 departures
    SELECT OriginAirportID, COUNT(*) AS Total_Flights
    FROM flights
    GROUP BY OriginAirportID
    HAVING COUNT(*) > 10000
)
SELECT AVG(flights.DepDelay) AS Average_Departure_Delay, airports.AirportName AS Airport_Name, airports.city  # Show the average departure delay, airport name, and city name
FROM flights                                                                                  				  # from the flights table
INNER JOIN airports ON airports.airportID = flights.OriginAirportID											  # join the airports and flights table
INNER JOIN AirportFlightCounts ON AirportFlightCounts.OriginAirportID = flights.OriginAirportID				  # join the pre aggregated data
WHERE flights.DepDelay > 0                                                                                	  # for flights that had a delay
  AND HOUR(flights.CRSDepTime) BETWEEN 7 AND 11                                                               # for the morning departure time
GROUP BY airports.AirportName, airports.city                                        						  # aggregate by the airport name, and city name
ORDER BY Average_Departure_Delay DESC;

# Question: In what cities are these airports located?
# Answer: San Juan, Newar, and Houston have the highest average departure delays.




