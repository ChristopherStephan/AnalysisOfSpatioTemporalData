require(POT) # perform stastical analyses of peaks over a threshold (POT)

weather.df <- read.csv("/home/christopher/git/AnalysisOfSpatioTemporalData/data/data/environment/weather-dwd-2667/weather-dwd-10488.csv")

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

# create a data frame that can be handeled by the "clust" function
wind.df.clust <- data.frame(time = weather.df$datum, obs = weather.df$wind_max)


# Threshold selection
# As this is a time series, independent events above a threshold must be selected. First, a relatively
# low threshold is passed to consider more events. Some of them are not extreme but regular events. This is
# necessary to select a reasonable threshold for the asymptotic approximation by a GPD. 
# tim.cond - A preliminary study (Wernli et al., 2002) showed that two maximum wind events 
# can be considered independent if they do not lie within a 3 day window.
# wind.df.max only retrieves independent values above threshold "u" by invoking clust() function
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

wind.df.clust.max.15 <- clust(na.omit(wind.df.clust), u=20, tim.cond = 3/365, clust.max = TRUE, plot = TRUE)

# We can now define the mean number of events per year “npy”
npy <- length(wind.df.clust.max.15[, "obs"])/(diff((range(as.numeric(wind.df.clust[, "time"]), na.rm = TRUE)))/356)

mle <- fitgpd(wind.df.clust.max.15[, "obs"], thresh = 20)
par(mfrow = c(2, 2))
plot(mle, npy = npy, which=4)

loc = 20

# Return the estimated return period for wind gusts up to 25 m/s
prob <- pgpd(25, loc = loc, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)

# Return the estimated return period for wind gusts up to 30 m/s
prob <- pgpd(30, loc = loc, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)

# Return the estimated return period for wind gusts up to 35 m/s
prob <- pgpd(35, loc = loc, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)

# Return the estimated return period for the maximum observed wind gusts 
prob <- pgpd(max(wind.df.clust.max.15[, "obs"]), loc = loc, scale = mle$param["scale"], shape=mle$param["shape"])
prob2rp(prob, npy = npy)
