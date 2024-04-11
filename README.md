# SQL with an Air Traffic Dataset

**Table of Contents:**
- [Introduction, Project Overview](#introduction-project-overview)
- [Questions to Explore](#questions-to-explore)
- [Data](#data)
- [Notebooks](#notebooks)
- [Configuration](#configuration)




## Introduction, Project Overview

This project is to showcase my fluency with MySQL.

#### Goal:

The goal of this project is to:
1. Answer the questions provided using MySQL.


## Questions to Explore

#### **Question 1**
The managers of the Invictus Mutual Fund want to know some basic details about the data. Use fully commented SQL queries to address each of the following questions:
- **1.** How many flights were there in 2018 and 2019 separately?
- **2.** In total, how many flights were cancelled or departed late over both years?
- **3.** Show the number of flights that were cancelled broken down by the reason for cancellation.
- **4.** For each month in 2019, report both the total number of flights and percentage of flights cancelled. Based on your results, what might you say about the cyclic nature of airline revenue?

#### **Question 2**
- **1.** Create two new tables, one for each year (2018 and 2019) showing the total miles traveled and number of flights broken down by airline.
- **2.** Using your new tables, find the year-over-year percent change in total flights and miles traveled for each airline.
  
Use fully commented SQL queries to address the questions above. What investment guidance would you give to the fund managers based on your results?

#### **Question 3**
Another critical piece of information is what airports the three airlines utilize most commonly.
- **1.** What are the names of the 10 most popular destination airports overall? For this question, generate a SQL query that first joins flights and airports then does the necessary aggregation.
- **2.** Answer the same question but using a subquery to aggregate & limit the flight data before your join with the airport information, hence optimizing your query runtime.
  
If done correctly, the results of these two queries are the same, but their runtime is not. In your SQL script, comment on the runtime: which is faster and why?

#### **Question 4**
The fund managers are interested in operating costs for each airline. We don't have actual cost or revenue information available, but we may be able to infer a general overview of how each airline's costs compare by looking at data that reflects equipment and fuel costs.
- **1.** A flight's tail number is the actual number affixed to the fuselage of an aircraft, much like a car license plate. As such, each plane has a unique tail number and the number of unique tail numbers for each airline should approximate how many planes the airline operates in total. Using this information, determine the number of unique aircrafts each airline operated in total over 2018-2019.
- **2.** Similarly, the total miles traveled by each airline gives an idea of total fuel costs and the distance traveled per plane gives an approximation of total equipment costs. What is the average distance traveled per aircraft for each of the three airlines?

Compare the three airlines with respect to your findings: how do these results impact your estimates of each airline's finances?

#### **Question 5**
Finally, the fund managers would like you to investigate the three airlines and major airports in terms of on-time performance as well. For each of the following questions, consider early departures and arrivals (negative values) as on-time (0 delay) in your calculations.
- **1.** Next, we will look into on-time performance more granularly in relation to the time of departure. We can break up the departure times into three categories as follows:

```
CASE
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
    ELSE "4-night"
END AS "time_of_day"
```

Find the average departure delay for each time-of-day across the whole data set. Can you explain the pattern you see?

- **2.** Now, find the average departure delay for each airport and time-of-day combination.
- **3.** Next, limit your average departure delay analysis to morning delays and airports with at least 10,000 flights.
- **4.** By extending the query from the previous question, name the top-10 airports (with >10000 flights) with the highest average morning delay. In what cities are these airports located?



## Data: 

The data has been sourced from the open data portal at the [Bureau of Transportation Statistics](https://www.transtats.bts.gov/DatabaseInfo.asp?QO_VQ=EFD&DB_URL=).  It is available for download in SQL format [here](https://drive.google.com/file/d/1eAg_CWEChp9W1o4ebgp29oKrZyDArW7Y/view?usp=sharing).


### Data Dictionaries:

#### Airports table:

| COLUMN      | TYPE   | DESCRIPTION                     |
|-------------|--------|---------------------------------|
| AirportID   | int    | unique airport code (Primary Key) |
| AirportName | string | Full name of airport            |
| City        | string | Airport city                    |
| Country     | string | Airport country                 |
| State       | string | Airport state                   |
| Latitude    | float  | Latitude of airport             |
| Longitude   | float  | Longitude of airport            |


#### Flights table:


| COLUMN                           | TYPE   | DESCRIPTION                                                       |
|----------------------------------|--------|-------------------------------------------------------------------|
| FlightID                         | int    | Unique ID number for each flight (Primary Key)                    |
| FlightDate                       | date   | Date of flight departure                                          |
| ReportingAirline                 | string | DOT Unique Carrier Code                                           |
| TailNumber                       | string | FAA Tail number identifying flight                                |
| FlightNumberReportingAirline     | string | Public flight number                                              |
| OriginAirportID                  | int    | Origin / departure airport code                                   |
| DestAirportID                    | int    | Destination / arrival airport code                                |
| CRSDepTime                       | string | Scheduled local departure time                                    |
| DepTime                          | string | Actual local departure time                                       |
| DepDelay                         | int    | Difference in minutes between scheduled and actual departure time |
| TaxiOut                          | int    | Taxi out time, in minutes                                         |
| WheelsOff                        | string | Wheels off in local time                                          |
| WheelsOn                         | string | Wheels on in local time                                           |
| TaxiIn                           | int    | Taxi in time, in minutes                                          |
| CRSArrTime                       | string | Scheduled arrival time                                            |
| ArrTime                          | string | Actual arrival time                                               |
| ArrDelay                         | int    | Difference in minutes between scheduled and actual arrival        |
| Cancelled                        | int    | Cancelled indicator                                               |
| Diverted                         | int    | Diverted indicator                                                |
| AirTime                          | int    | Flight time (total time in the air) in minutes                    |
| Distance                         | float  | Distance between airports in miles                                |
| AirlineName                      | string | DOT full airline name                                             |
| CancellationReason               | string | Reason for cancellation                                           |



## Notebooks

This project is contained in a single .sql file. 



## Configuration

This work was performed on MySQL Workbench, Version 8.0.34 build 3263449 CE (64 bits).


If you have any questions about this project, I would love to speak with you!  Please don't hesitate to reach out:
Phone: +1 778 995 7801
Email: [Drewe.MacIver@gmail.com](mailto:drewe.maciver@gmail.com)
LinkedIn: [Drewe MacIver on LinkedIn](https://www.linkedin.com/in/drewe-maciver/)
Portfolio: [DreweItWithData.com](https://www.dreweitwithdata.com)
