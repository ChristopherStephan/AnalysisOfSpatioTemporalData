Analysis of Spatio-Temporal Data
=================================

Extreme value analysis of wind gusts over Germany

* __Weather_Station_Time_Series__ contains time series of historic and actual (March 2014) weather data
* __Weather_Station_Analysis__ contains the R scripts for each weather station to analyse return periods of extreme wind gusts. The script __windmax.R__ contains the scripts for plotting the time series.
* __download.sh__ merges the historic and actual weather time series of all the weather stations which KL ID are passed to the function
* __Stationsliste.csv__ contains the return periods of 25, 30, and 35 m/s for each station along side other data such as the geolocation of the station
* __Plots__ contains some plots of the extreme value analysis and the script for generating the maps

###Return Periods of wind gusts 35 m/s

![](https://raw.githubusercontent.com/ChristopherStephan/AnalysisOfSpatioTemporalData/master/Plots/retper35_final.png "Return Periods of wind gusts 35 m/s")


### Return Periods of wind gusts 35 m/s with weather station ID

![](https://raw.githubusercontent.com/ChristopherStephan/AnalysisOfSpatioTemporalData/master/Plots/retper35_labels_reds.png "Return Periods of wind gusts 35 m/s")



###Return Periods of wind gusts 30 m/s

![](https://raw.githubusercontent.com/ChristopherStephan/AnalysisOfSpatioTemporalData/master/Plots/retper30_final.png "Return Periods of wind gusts 30 m/s")


###Return Periods of wind gusts 25 m/s

![](https://raw.githubusercontent.com/ChristopherStephan/AnalysisOfSpatioTemporalData/master/Plots/retper25_final.png "Return Periods of wind gusts 25 m/s")
