library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("#jhudash Refugee Match App"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    # Simple integer interval
    sliderInput("compatibility", "Weight on Compatibility :", 
                min=0, max=1, value=0.3,step=0.1),
    
    # Decimal interval with step value
    sliderInput("cost", "Weight on Cost:", 
                min = 0, max = 1, value = 0.3, step= 0.1),
    
    # Specification of range within an interval
    sliderInput("capacity", "Weight on Capacity:",
                min = 0, max = 1, value = 0.3, step=0.1),
    
    uiOutput("test")
  ),
  
  # Show a table summarizing the values entered
  mainPanel(
    leafletOutput("mymap"),
    p()
  )
))