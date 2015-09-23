countries <- readOGR("https://raw.githubusercontent.com/datasets/geo-boundaries-world-110m/master/countries.geojson", "OGRGeoJSON")
map <- leaflet(countries)
pal <- colorNumeric(
  palette = "Blues",
  domain = countries$gdp_md_est
)

map %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~pal(gdp_md_est)
  )