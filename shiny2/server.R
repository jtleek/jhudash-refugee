
countries <- readOGR("data/ne_110m_admin_0_countries", layer="ne_110m_admin_0_countries")
#countries <- readOGR("https://raw.githubusercontent.com/datasets/geo-boundaries-world-110m/master/countries.geojson", "OGRGeoJSON")
countrynames = as.character(countries$sovereignt)

my_url = "https://docs.google.com/spreadsheets/d/1eRDlcwkT0hqqi-DNVU4dgJHxKRsLYY0VAqOMjxcD2r8/pubhtml"
my_gs = gs_url(my_url)
rankings <- gs_read(my_gs, ws="rankings")
rankings = rankings[-c(14,24),]
rankings$X[rankings$X=="United States"] = "United States of America"
rankings$X[rankings$X=="Luxemberg"] = "Luxembourg"
index= match(countrynames,rankings$X)

#function for picking zoom level
continent <- function(pick) {
    zoom <- numeric(3)
    if(pick==1) {
        #world
        zoom[1] <- 0 #-15.862904
        zoom[2] <- 50 #40.6895934
        zoom[3] <- 1
    } else if(pick==2) {
        # europe
        zoom[1] <- 15.300150
        zoom[2] <- 51.077689
        zoom[3] <- 3
    } else if(pick==3) {
        # The West
        zoom[1] <- -42.6695446
        zoom[2] <- 43.3657243
        zoom[3] <- 2
    }
    zoom
}

# function to show top10 list
winners <- function(rank) {
    scores <- data.frame(country=rankings$X[index][!is.na(rankings$X[index])], 
                         score=rank)
                         #score=rank[index][!is.na(rank[index])])
    scores <- scores[order(scores$score, decreasing=T),]
    scores <- scores[!duplicated(scores$country),]
    summary <- character()
###if you just want to show rank
    for (i in 1:nrow(scores)) {
        summary[i] <- paste(i, ": ", scores[i,1], "\n", sep="")
    }
###if you just want to show scores
#     for (i in 1:nrow(scores)) {
#         summary[i] <- paste(scores[i,1], ": ", scores[i,2], "\n", sep="")
#     }
###if you want to show rank and scores
# for (i in 1:nrow(scores)) {
#     summary[i] <- paste(i, ": ", scores[i,1], " (", round(scores[i,2]),")", "\n", sep="")
# }
    summary
}

# Define server logic for slider examples
shinyServer(function(input, output) {
  
  # Reactive expression to compose a data frame containing all of the values
  sliderValues <- reactive({
  
  output$test <- renderUI({
    sliderInput("test", "This is a test", min=0, max=(input$capacity + input$compatibility), step=0.1, value=1)
  })
  })
  
  rank <- reactive({input$capacity * rankings$capacity[index] + 
                        input$compatibility * rankings$compatibility[index] +
                        input$cost * rankings$cost[index]})
  
  #output$rank <- renderText({rank()[!is.na(rank())]})
  output$rank <- renderText({winners(rank()[!is.na(rank())])})
  
  output$mymap <- renderLeaflet({
    
    val = input$capacity * rankings$capacity[index] + 
      input$compatibility * rankings$compatibility[index] +
      input$cost * rankings$cost[index]
    
    val[is.na(val)] = 0
    
    pal <- colorNumeric(
      palette = "Blues",
      domain = val
    )
    
    zoomNum <- reactive({continent(input$continent)})      
    
    leaflet(countries) %>%
      addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                  color = ~pal(val)
      ) %>% setView(zoomNum()[1], 
                                    zoomNum()[2], zoom = zoomNum()[3])

  })
})