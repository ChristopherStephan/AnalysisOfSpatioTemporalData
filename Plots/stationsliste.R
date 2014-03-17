require(maps)
require(maptools)
require(RColorBrewer)
require(classInt)
require(gpclib)
require(mapdata)
require(grid)
library(ggmap)
library(mapproj)

stationsliste <- read.csv("/home/christopher/Documents/Studium/WS 2013-2014/Analysis of Spatio-Temporal Data/Mini-Project/Stationsliste2.csv")

colnames(stationsliste) <- c("stations_kennziffer", "klima_kennung", "ICAO_kennung", "stationsname", "stationshoehe_in_m", "lat", "lon",
                          "beginn_klimareihe", "retper25", "class25", "retper30", "class30", "retper35", "class35", "retpermax")

# Plot for return period of wind gusts with 25 m/s
range(stationsliste$retper25)

# Define number of colours to be used in plot
nclr <- 5

# Define colour intervals and colour code variable for plotting
class <- classIntervals(stationsliste$retper25, nclr, style = "jenks")



map <- get_map(location = "Germany" , zoom = 6, maptype="toner")
p <- ggmap(map)

p <- p + geom_point(data = stationsliste, aes(x = lon, y = lat, size=18, color=factor(class25), label=stations_kennziffer))
p <- p + scale_colour_brewer(palette="Set1", name="Years", labels = c("[0, 0.4]", "(0.4, 0.9]", "(0.9, 1.7]", "(1.7, 3.3]", "(3.3, 15]"))
p <- p + theme(legend.title = element_text(size = 10, face='bold'), legend.key.size = unit(1,'lines'))
p <- p + guides(colour = guide_legend(override.aes = list(size=6))) 
p <- p + scale_size(guide = 'none')
#p <- p + geom_text(data= stationsliste, aes(label=stationsliste$stations_kennziffer), hjust=0, vjust=0, size=5, colour="red")
p <- p + labs(list(title = "Return period (years) of wind gusts 25 m/s", x = "Longitude", y="Latitude"))
print(p)


# Plot for return period of wind gusts with 30 m/s

range(stationsliste$retper30)

# Define number of colours to be used in plot
nclr <- 5

# Define colour intervals and colour code variable for plotting
class <- classIntervals(stationsliste$retper30, nclr, style = "jenks")



map <- get_map(location = "Germany" , zoom = 6, maptype="toner")
p <- ggmap(map)

p <- p + geom_point(data = stationsliste, aes(x = lon, y = lat, size=18, color=factor(class30), label=stations_kennziffer))
p <- p + scale_colour_brewer(palette="Set1", name="Years", labels = c("[0, 2]", "(2, 5]", "(5, 9]", "(9, 21]", "(21, 40]"))
p <- p + theme(legend.title = element_text(size = 10, face='bold'), legend.key.size = unit(1,'lines'))
p <- p + guides(colour = guide_legend(override.aes = list(size=6))) 
p <- p + scale_size(guide = 'none')
#p <- p + geom_text(data= stationsliste, aes(label=stationsliste$stations_kennziffer), hjust=0, vjust=0, size=5, colour="red")
p <- p + labs(list(title = "Return period (years) of wind gusts 30 m/s", x = "Longitude", y="Latitude"))
print(p)



# Plot for return period of wind gusts with 35 m/s

# Define number of colours to be used in plot
nclr <- 7

# Define colour intervals and colour code variable for plotting
class <- classIntervals(stationsliste$retper35, nclr, style = "jenks")



map <- get_map(location = "Germany" , zoom = 6, maptype="toner")
p <- ggmap(map)

p <- p + geom_point(data = stationsliste, aes(x = lon, y = lat, size=18, color=factor(class35), label=stations_kennziffer))
p <- p + scale_colour_brewer(palette="Reds", name="Years", labels = c("[0, 10]", "(10, 25]", "(25, 41]", "(41, 63]", "(63, 90]", "(90, 200]", "(200, 225]"))
p <- p + theme(legend.title = element_text(size = 10, face='bold'), legend.key.size = unit(1,'lines'))
p <- p + guides(colour = guide_legend(override.aes = list(size=6))) 
p <- p + scale_size(guide = 'none')
#p <- p + geom_text(data= stationsliste, aes(label=stationsliste$stations_kennziffer), hjust=0, vjust=0, size=5, colour="red")
p <- p + labs(list(title = "Return period (years) of wind gusts 35 m/s", x = "Longitude", y="Latitude"))
print(p)

