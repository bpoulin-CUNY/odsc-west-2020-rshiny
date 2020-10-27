## app.R ##
library(shinydashboard)
library(shiny)
library(leaflet)
library(tidyverse)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
ui <- dashboardPage(
  dashboardHeader(title = "Income Distribution"),
  dashboardSidebar(selectInput('city', 'Cities', c("Amherst", "Boston", 
                                                   "Lowell", "Pittsfield", "Springfield", "Worcester"), selectize=FALSE)
                   ),
  dashboardBody(
    fluidRow(
      h2('Distribution of Income Around Massachusetts Cities'),
      column(12,leafletOutput('income', width = "100%")),
    )
  )
)


server <- function(input, output, session){
  
  data <- readRDS('acs5-income.rds')

  cities_data <- read.csv("ma-cities.csv")
 filtered_cities <-reactive({
   cities_data[cities_data$City==input$city,]
 })

  output$income<-renderLeaflet({
    pal <- colorQuantile(palette = "YlOrRd", domain = data$income,n = 6, na.color = NA)
    data %>% 
      st_transform(crs = "+init=epsg:4326") %>%
      leaflet(height = "100%") %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      setView(lng = -72, lat = 42, zoom = 07.5)%>%
      addPolygons(popup = ~ (paste("<html>Tract:", tract, "<br>","Median Household Income: $", income, "</html>")),
                  stroke = TRUE,
                  smoothFactor = 0,
                  fillOpacity = 0.9,
                  color = 'dimgray',
                  weight =.3,
                  opacity = 1,
                  fillColor = ~ pal(income)) %>%
      addLegend("topright",
                pal = pal,
                values = ~income,
                title = "Median Household Income",
                opacity=1)})
  
  observe({

    proxy<-leafletProxy("income", data = filtered_cities()) 
    
    proxy%>%
      removeMarker(layerId='cities') %>%
      addCircles(lng = ~Lon,
                 lat = ~Lat,
                 radius = ~Population/15,
                 weight = 3,
                 color = "#388E8E",
                 fillColor = "#388E8E",
                 fillOpacity = 0.3,
                 popup = ~paste0("<html>City: ", City, "<br> Population: ", Population, "</html>"),
                 layerId = 'cities')
  })
  
  
}







shinyApp(ui, server)


