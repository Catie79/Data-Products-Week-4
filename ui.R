#
# Appliction to display costs of procedures in Washington state, allowing users to find the cheapest location for a procedure
#USES DUMMY DATA
# All data in this application is aggregated, randomized, and totally fake, please do not try to find a health care provider with this information
# Strictly for demonstration purposes

library(shiny)
library(leaflet)

Dummy_Geo_Data <- read.csv(file = "data/DummyGeoData.csv")

# Define UI for application that draws a map of healthcare providers
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sample Health Providers"),
  
  # Sidebar with a dropdown for procedures 
  sidebarLayout(
    sidebarPanel(
      textOutput("document"),
      selectInput(inputId = "Procedure",
                  label = "Choose a procedure:",
                  choices = Dummy_Geo_Data$Procedure_Desc),
      actionButton("do", "Refresh")
    ),
    
    # Show map and text of results
    mainPanel(
      leafletOutput("m"),
      span(textOutput ("text"),style = "font-weight: bold"),
      tableOutput ("t")
    )
  )
))
