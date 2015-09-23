library(shiny)

## Load the data we need
library(rvest)
library(googlesheets)
library(dplyr)
library(rgdal)

countries <- readOGR("https://raw.githubusercontent.com/datasets/geo-boundaries-world-110m/master/countries.geojson", "OGRGeoJSON")
countrynames = as.character(countries$sovereignt)

my_url = "https://docs.google.com/spreadsheets/d/1eRDlcwkT0hqqi-DNVU4dgJHxKRsLYY0VAqOMjxcD2r8/pubhtml"
my_gs = gs_url(my_url)
rankings <- gs_read(my_gs, ws="rankings")
rankings = rankings[-c(14,24),]
rankings$X[rankings$X=="United States"] = "United States of America"
rankings$X[rankings$X=="Luxemberg"] = "Luxembourg"
index= match(countrynames,rankings$X)

# Define server logic for slider examples
shinyServer(function(input, output) {
  
  # Reactive expression to compose a data frame containing all of the values
  sliderValues <- reactive({
  
  output$test <- renderUI({
    sliderInput("test", "This is a test", min=0, max=(input$capacity + input$compatibility), step=0.1, value=1)
  })
  })
  
  output$mymap <- renderLeaflet({
    
    val = input$capacity * rankings$capacity[index] + 
      input$compatibility * rankings$compatibility[index] +
      input$cost * rankings$cost[index]
    
    val[is.na(val)] = 0
    
    pal <- colorNumeric(
      palette = "Blues",
      domain = val
    )
                
    leaflet(countries) %>%
      addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                  color = ~pal(val)
      )
  })
})