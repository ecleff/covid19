# maps
library(dplyr)
library(jsonlite)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(tidyr)
library(RCurl)
library(curl)
library(httr)
library(readr)
library(rio)
library(RgoogleMaps)
library(RColorBrewer)
x <- getURL('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/03-20-2020.csv')
mapdata <- read.csv(text = x)

library(ggmap)

map <- get_map(c(-97.14667, 31.5493), zoom=2, maptype="roadmap")
map1 <- ggmap(map, extent="panel") + geom_point(data=mapdata, aes(x=Longitude, y=Latitude, 
                                                                  size=Confirmed, 
                                                                  color=Deaths))+
  scale_color_gradient(low = "lightpink1", high = "deeppink1")

map1


mapdata$radius <- NA
mapdata$radius[mapdata$Confirmed > 100] <- (mapdata$Confirmed/100)
mapdata$radius[mapdata$Confirmed < 100 ] <- mapdata$Confirmed/10

library(leaflet)
library(devtools)
#devtools::install_github("rstudio/leaflet.providers")
library(leaflet.providers)
#devtools::install_github("jaredhuling/jcolors")
library(jcolors)
library(rgdal)
library(sf)

mypal <- colorNumeric("YlOrRd", domain=mapdata$Deaths, na.color=NA, alpha=FALSE)

cvmap <-  
  leaflet(mapdata) %>% 
  setView(lng = -12.4964, lat = 41.9028, zoom = 2)%>% 
  addProviderTiles(providers$Esri.WorldImagery) %>%  
  addCircleMarkers(~Longitude, ~Latitude, 
                   popup = ~paste("Deaths: ",as.character(Deaths),
                                                         "(Region: ", Country.Region, ")"), 
                   radius=~sqrt(Confirmed)/10, color = ~mypal(Deaths),fillOpacity = 1,
                   labelOptions = labelOptions(noHide = F,
                                               direction = 'auto',
                                               showCoverageOnHover=TRUE,
                                               riseOnHover=TRUE), 
  popupOptions(zoomToBoundsOnClick=TRUE, interactive=TRUE, closeOnClick=TRUE, autoPan=TRUE)) %>% 
    addLegend(
      position = 'bottomleft',
      values= ~Deaths,
      pal = mypal,
      title='Deaths by COVID-19',
      group="circles"
    )
  
cvmap


