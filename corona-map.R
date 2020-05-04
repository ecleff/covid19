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
x <- getURL('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/05-03-2020.csv')
mapdata <- read.csv(text = x)

library(ggmap)
library(stringr)


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
  addProviderTiles(providers$CartoDB.DarkMatter) %>%  
  addCircleMarkers(~Long_, ~Lat, 
                   label = ~paste("Deaths: ",as.character(Deaths),
                                                         "(Region: ", Combined_Key, ")"), 
                   radius=~sqrt(Confirmed)/10, color = ~mypal(Deaths),fillOpacity = .7,
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

# Description:
# Title : Map - Deaths by COVID-19
# COVID-19 deaths by region as of April 2020.
# Data source: https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/05-03-2020.csv
# cvdeathtoll