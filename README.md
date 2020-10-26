# Data analysis of the EEA "CO2 emissions from passenger cars" dataset

every year the EEA is releasing the "Monitoring of CO2 emissions from passenger cars – Regulation (EU) 2019/631" dataset.<sup>[1](#myfootnote1)</sup>   
It contains detailed data of each new car registered in the EU. The database starts with the year 2012 and has grown to be over 37 million datarows (and over 8GB of data). To make analysis easier and faster we introduce a method to aggregate the dataset. In this repository we document the aggregation steps. If you want to work with the current aggregated dataset (Provisional 2019), you can use the "aggregated-classified.sqlite" SQLite database provided within this repository. If you want to aggregate it yourself, you need to download the original datasets from the EEA website<sup>[1](#myfootnote1)</sup> and continue with the following steps:

## 1. Combination
All the CSV datasets need to be importet into a local SQLite database
- the datacolumns of the newest dataset are used as a template, while importing older datasets it is important to map the corresponding columns, as the naming scheme wasn't consistant over the years. Most importantly this has to be done with the emissions fields.
- after this step you should have a table named "all" consisting of all >37 mil. datarows

## 2. Aggregation: 
All rows with the same unique value combination of: year, Country, Mk(manufacturer), Cn(model) and Ft (Fueltype) are aggregated. After this step the database consists of only 237.776 rows.
- the aggregation has to be done multiple times to be able to do the average calculation of motorpower, weight and emissions correctly. The reason for this is, that not all, sometime more than half of a specific unique key combination have values in the corresponding data fields. To do the average calculation correctly we need to only aggregate and calculate over rows where the specified data field is not empty while keeping track of the "number of cars with data/total number of cars" number, named "_coverage". After the calculations we once again aggregate all the tables. The details to those calculations can be found within the file "aggreagte.sql"

## 3. Classification: 
Now the aggregated tables is going to be classified. Much of our analysis is based on specific car groups. Often the pooling process of those groups isn't trivial and needs a lot of fine tuning. Hence we introduce 3 classifcation groups: 
- class1: manufacturer pools
- class2: car type groups (such as SUV / normal)
- class3: car modell groups (i.e. S-Class Mercedes

The detailed steps of the classification can be found in "classify.sql"


<a name="myfootnote1">1</a>: Monitoring of CO2 emissions from passenger cars – Regulation (EU) 2019/631: [https://www.eea.europa.eu/data-and-maps/data/co2-cars-emission-18](https://www.eea.europa.eu/data-and-maps/data/co2-cars-emission-18)

