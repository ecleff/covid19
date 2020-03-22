# interactive line graphs
library(dplyr)
library(jsonlite)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(tidyr)


data <- fromJSON("https://pomber.github.io/covid19/timeseries.json")


# merging country data
Japan <- data$Japan
Japan$date <- as.POSIXct(Japan$date, format="%Y-%m-%d")
Japan$country <- NA
Japan$country <- "Japan"

Thailand <- data$Thailand
Thailand$country <- NA
Thailand$country <- "Thailand"
Thailand$date <- as.POSIXct(Thailand$date, format="%Y-%m-%d")

India <- data$India 
India$country <- NA
India$country <- "India"
India$date <- as.POSIXct(India$date, format="%Y-%m-%d")

merged <- rbind(India, Thailand, Japan)

overall_recovered <- plot_ly(merged,
                             type='scatter',
                             mode='markers',
                             x=~date,
                             y=~recovered,
                             name=~country, color=~country, size=~confirmed,
                             text = ~paste('% Recovered: ', trunc((recovered/confirmed)*100))
)
overall_recovered <- overall_recovered %>% layout(showLegend=TRUE)
overall_recovered

overall_deaths <- plot_ly(merged,
                          type='scatter',
                          mode='markers',
                          x=~date,
                          y=~deaths,
                          name=~country, color=~country, size=~confirmed,
                          text = ~paste('% Died: ', trunc((deaths/confirmed)*100))
) 

overall_deaths <- overall_deaths %>% layout(showLegend=TRUE)
overall_deaths

