# import dependencies
require(zoo)
require(ggplot2)
require(splines)
require(MASS)
require(stats)
require(POT) # perform stastical analyses of peaks over a threshold (POT)
require(maps)
require(maptools)
require(RColorBrewer)
require(classInt)
require(gpclib)
require(mapdata)

# URL1="http://www.dwd.de/bvbw/generator/DWDWWW/Content/Oeffentlichkeit/KU/KU2/KU21/klimadaten/german/download/tageswerte/kl__10513__hist__txt,templateId=raw,property=publicationFile.zip/kl_10513_hist_txt.zip"
# URL2="http://www.dwd.de/bvbw/generator/DWDWWW/Content/Oeffentlichkeit/KU/KU2/KU21/klimadaten/german/download/tageswerte/kl__10513__akt__txt,templateId=raw,property=publicationFile.zip/kl_10513_akt_txt.zip"

weather.df <- read.csv("/home/christopher/git/AnalysisOfSpatioTemporalData/data/data/environment/weather-dwd-2667/weather-dwd-2667.csv")

colnames(weather.df) <- c("datum", "qual", "bedeckung", "relfeuchte", "dampfdruck", "ltemp", "ldruck", "wges",
                          "temp_boden", "ltemp_min", "ltemp_max", "wind_max", "ndschlag_typ", "ndschlag_hoehe", "sonne",
                          "schnee")
weather.df$datum <- as.Date(as.character(weather.df$datum), format="%Y%m%d")

# eleminate empty values
weather.df$bedeckung[weather.df$bedeckung == -999.0] <- NA
weather.df$relfeuchte[weather.df$relfeuchte == -999.0] <- NA
weather.df$dampfdruck[weather.df$dampfdruck == -999.0] <- NA
weather.df$ltemp[weather.df$ltemp == -999.0] <- NA
weather.df$ldruck[weather.df$ldruck == -999.0] <- NA
weather.df$wges[weather.df$wges == -999.0] <- NA
weather.df$temp_boden[weather.df$temp_boden == -999.0] <- NA
weather.df$ltemp_min[weather.df$ltemp_min == -999.0] <- NA
weather.df$ltemp_max[weather.df$ltemp_max == -999.0] <- NA
weather.df$wind_max[weather.df$wind_max == -999.0] <- NA
weather.df$ndschlag_typ[weather.df$ndschlag_typ == -999.0] <- NA
weather.df$ndschlag_hoehe[weather.df$ndschlag_hoehe == -999.0] <- NA
weather.df$sonne[weather.df$sonne == -999.0] <- NA
weather.df$schnee[weather.df$schnee == -999.0] <- NA

# smooth out the irregular roughness to see a clearer long term variability of daily maximum wind speed
lo <- loess(weather.df$wind_max ~ as.numeric(weather.df$datum), span=0.05)
plot(weather.df$datum, weather.df$wind_max, type="l", ylab="Speed (m/s)", xlab="Date", main="Maximum daily wind speed Cologne/Bonn 1957 - 2013")
ypredict <- predict(lo, data.frame(x=c(1:length(weather.df$datum))))
lines(weather.df$datum, ypredict, col="red")

# remove NA values to create a time series object
weather.df.rmna <- na.omit(weather.df)
# create temperature time series as ts object and analyse
weather.windmax.ts <- ts(weather.df.rmna$wind_max, frequency=365, start=c(1957, 243))
# decompose to investigate the trend and seasonal factors
windmax.decomp <- decompose(weather.windmax.ts)
plot(windmax.decomp)
plot(windmax.decomp$trend)
windmax.decomp.trend.df <- as.data.frame(matrix(windmax.decomp$trend))
windmax.decomp.trend.df$datum <- weather.df.rmna$datum

# smoothing trend indicates that no long term trend emerges
ggplot(data=windmax.decomp.trend.df, aes(x=datum, y = V1)) +
  geom_line(weight=0.5) +
  geom_smooth(method="lm", formula = y ~ ns(x, 15), size=0.5) +
  ggtitle("Trend of maximum daily wind speed Cologne/Bonn 1957 - 2013") +
  xlab("Date") +
  ylab("Speed (m/s)")


# Extreme winds over Europe are often associated with mesoscale and syn-
# optic scale cyclones (Wernli et al., 2002). Typically these systems have a lifetime of around 72
# hours or less. Since the time resolution of our data is as high as 24 hours, the wind gust peaks
# are expected to be somewhat dependent. 
# Since the daily maximum wind speed time series are strongly auto-correlated,
# select naively events above a threshold may lead to dependent events
# To overcome this declustering is done, which filters the dependent observations
# to obtain a set of threshold excesses that are approximately independent.
# This is done by defining an empirical rule to identify clusters of exceedances and identifying the
# cluster maxima; these maxima are called declustered peaks and are assumed to be independent.

# A function to identify clusters of exceedances of a time series.

# create a data frame that can be handeled by the "clust" function
wind.df.clust <- data.frame(time = weather.df$datum, obs = weather.df$wind_max)

# tim.cond - A preliminary study (Wernli et al., 2002) showed that two maximum wind events 
# can be considered independent if they do not lie within a 3 day window.
# clust.max - only cluster maxima
# wind.df.max only retrieves independent values above threshold "u" by invoking clust() function
wind.df.clust.max1 <- clust(na.omit(wind.df.clust), u=30, plot = TRUE)
wind.df.clust.max2 <- clust(na.omit(wind.df.clust), u=30, clust.max=TRUE, plot = TRUE)
wind.df.clust.max3 <- clust(wind.df.clust, u=30, tim.cond = 3/365, clust.max = TRUE, plot = TRUE)

obs <- wind.df.clust.max3[, "obs"]
pwmu <- fitgpd(obs, threshold=30, "pwmu")
pwmu
plot(pwmu)

# Threshold selection
# As this is a time series, we must selects independent events above a threshold. First, we fix a relatively
# low threshold to "extract" more events. Thus, some of them are not extreme but regular events. This is
# necessary to select a reasonable threshold for the asymptotic approximation by a GPD

wind.df.clust.max.5 <- clust(na.omit(wind.df.clust), u=5, tim.cond = 3/365, clust.max = TRUE, plot = FALSE)
par(mfrow = c(2, 2))
mrlplot(wind.df.clust.max.5[, "obs"])
abline(v = 20, col = "red")
diplot(wind.df.clust.max.5)
abline(v = 20, col = "red")
tcplot(wind.df.clust.max.5[, "obs"], which = 1)
abline(v = 20, col = "red")
tcplot(wind.df.clust.max.5[, "obs"], which = 2)
abline(v = 20, col = "red")

# The Mean residual life plot - top left panel- indicates that a threshold around 20 m/s should be adequate
# However, the selected threshold must be low enough to have enough events above it to reduce variance while
# not too low as it increase the bias. Thus, we can now “re-extract” events above the threshold 15 m/s,
# obtaining object wind.df.clust.max.15. This is necessary as sometimes wind.df.clust.max.15 is not equal to
# observations of wind.df.clust.max.5 greater than 15 m/s. We can now define the mean number of events per year “npy”.
# Note that an estimation of the extremal index is available.
wind.df.clust.max.15 <- clust(na.omit(wind.df.clust), u=20, tim.cond = 3/365, clust.max = TRUE, plot = TRUE)

# We can now define the mean number of events per year “npy”
npy <- length(wind.df.clust.max.15[, "obs"])/(diff((range(as.numeric(wind.df.clust[, "time"]), na.rm = TRUE)))/356)
                                               
mle <- fitgpd(wind.df.clust.max.15[, "obs"], thresh = 20)
par(mfrow = c(2, 2))
plot(mle, npy = npy, which=4)

# Return the estimated return period for wind gusts up to 25 m/s
prob <- pgpd(25, loc = 20, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)

# Return the estimated return period for wind gusts up to 30 m/s
prob <- pgpd(30, loc = 20, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)

# Return the estimated return period for wind gusts up to 35 m/s
prob <- pgpd(35, loc = 20, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)

# Return the estimated return period for the maximum observed wind gusts 
prob <- pgpd(max(wind.df.clust.max.15[, "obs"]), loc = 20, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)

# Define number of colours to be used in plot
nclr <- 4

# define the palette to be used
plotclr <- brewer.pal(nclr, "RdYlGn")

# Define colour intervals and colour code variable for plotting
class <- classIntervals(wind.df.clust.max.15[, "time"], nclr, style = "pretty")
colcode <- findColours(class, plotclr)

# Plot the map
map("world", region="germany", resolution=0)
title("Return period of wind gusts 25 m/s")
points(7.16, 50.86, pch = 16, col= colcode, cex = 2)

legend("right", legend = names(attr(colcode, "table")), fill = attr(colcode, "palette"), cex = 1, bty = "n")


