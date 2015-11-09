library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel(""),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
      h3('Models'),
      h5('Three separate models were built, based on different considerations of 
         what would make for ideal refugee placement.'),
      h4('Compatibility:'),
      h5('Cultural and economic similarity to pre-war Syria, and geographic distance from Syria.'),
      h4('Cost:'),
      h5('Cost to host country of supporting a refugee. (Low cost corresponding to a higher ranking.)'),
      h4('Capacity'),
      h5('Economic capacity of host country to support incoming refugees.'),
    # Simple integer interval
    sliderInput("compatibility", "Weight on Compatibility :", 
                min=0, max=1, value=0.3,step=0.1),
    
    # Decimal interval with step value
    sliderInput("cost", "Weight on Cost:", 
                min = 0, max = 1, value = 0.3, step= 0.1),
    
    # Specification of range within an interval
    sliderInput("capacity", "Weight on Capacity:",
                min = 0, max = 1, value = 0.3, step=0.1),
    verbatimTextOutput("rank"),
    
    uiOutput("test")
  ),
  
  # Show a table summarizing the values entered
  mainPanel(
    h1("Ideal Syrian Refugee Placement"),
    h4("a project from Johns Hopkins Data Science Hackathon 2015"),
    h5('This app is an attempt to quantify the ideal placement for the refugees leaving
       Syria.  While we acknowledged that politics plays a large (possibly the largest)
        role in determining real refugee placement, our goal was to model the "ideal"
        situation--both for the refugee and host country--independent of political
        considerations.'), 
    h5('A variety of statistics were built into three different models: 
        Compatibility, Cost, and Capacity.  A short summary of each model is below.
        In the sidebar, you can choose how to weight each model, and then see the 
        recommendation of your combined, weighted model.  The majority of this data was from the UN 
        Human Rights Council, the World Bank, and the CIA World Fact Book.
       Analysis was done in September 2015 with the most recent data available.'),
    radioButtons('continent', "Pick Zoom:", c("World"=1, "Europe"=2, "The West"=3), inline=T),
    leafletOutput("mymap"),
    p(br()),
    h5("Documentation:"),
    p("View slideshow presentation on the ", a("development of the models",href="http://bit.ly/1k5FInc"), "."),
    p("View the ", a("Github repo",href="https://github.com/jtleek/jhudash-refugee"), " with the analysis code."),
    p()
  )
))