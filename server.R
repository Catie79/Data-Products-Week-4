#
# 
#

library(shiny)
library(leaflet)
library(scales)



# Define server logic required to draw a map and define text for top 15 results
shinyServer <- function(input, output) {
  
  output$document <- renderText("Please select a procedure in the drop down and then press Refresh to see providers that can perform that procedure on the map.  There will also be a list of the top 15 providers by cost.  Savings is a comparison between the cost of the listed provider and the most expensive provider in the data set for the procedure.  Please note, all data in this application is FAKE and is for demo purposes only.")
  

  
  Dummy_Geo_Data <- read.csv(file = "data/DummyGeoData.csv")
  
  output$m <- renderLeaflet({
    
    m <- leaflet ()
    m <- addTiles(m)
    m <- addMarkers (m, lng = Dummy_Geo_Data$Longitude, lat = Dummy_Geo_Data$Latitude, popup = paste(Dummy_Geo_Data$Id,"$",Dummy_Geo_Data$Cost))
  })
  
  leafletOutput('m', height=900)
  
  proxy <- leafletProxy("m")
  
  output$t <- renderText({"Please filter results"})
  
  output$text <- renderText ({"Top 15 Results by Cost"})
  
# Filter based on input, triggers on Refresh button
  
  observeEvent(input$do,{
    
    #Filter down to procedure selected
    x <- input$Procedure
    Dummy_Health_Geo_filter <- Dummy_Geo_Data[ which(Dummy_Geo_Data$Procedure_Desc == x),]
    Dummy_Health_Geo_filter <- Dummy_Health_Geo_filter[order(Dummy_Health_Geo_filter$Cost),]
    
    #Calculate savings over most expensive location
    y <- max(Dummy_Health_Geo_filter$Cost)
    Dummy_Health_Geo_filter$Savings <- y - Dummy_Health_Geo_filter$Cost
    Dummy_Health_Geo_filter$Savings <- dollar(Dummy_Health_Geo_filter$Savings)
    Dummy_Health_Geo_filter$Cost <- dollar(Dummy_Health_Geo_filter$Cost)
      
    #update map
    clearMarkers(proxy)
    addMarkers (proxy, lng = Dummy_Health_Geo_filter$Longitude, lat = Dummy_Health_Geo_filter$Latitude, popup = paste(Dummy_Health_Geo_filter$Name,"$",Dummy_Health_Geo_filter$Cost))
    
    #update text
    output$t <- renderTable({head(Dummy_Health_Geo_filter, 15)})
    
  })
  
}
