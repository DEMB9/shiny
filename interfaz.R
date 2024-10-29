# Cargar librerías necesarias
install.packages("shiny")
install.packages("leaflet")
library(shiny)
library(leaflet)

# Datos de ejemplo: ubicaciones de algunas ciudades
data <- data.frame(
  name = c("CIAT"),
  lat = c(3.502129),
  lng = c(-76.355842)
)

# Interfaz de usuario
ui <- fluidPage(
  titlePanel("Mapa Interactivo con Leaflet"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Este es un mapa interactivo con puntos de ciudades en América Latina."),
      
      # Permitir al usuario elegir el nivel de zoom
      sliderInput("zoom", "Nivel de Zoom:", 
                  min = 1, max = 18, value = 5)
    ),
    
    mainPanel(
      # Mapa interactivo
      leafletOutput("mapa")
    )
  )
)

# Lógica del servidor
server <- function(input, output, session) {
  
  # Generar el mapa
  output$mapa <- renderLeaflet({
    leaflet(data) %>%
      addTiles() %>%  # Agregar mapa base
      setView(lng = -72.0, lat = 4.0, zoom = input$zoom) %>%  # Configurar vista inicial
      addMarkers(~lng, ~lat, popup = ~name)  # Agregar marcadores con etiquetas
  })
  
  # Actualizar zoom en el mapa cuando cambia el input
  observe({
    leafletProxy("mapa") %>%
      setView(lng = -72.0, lat = 4.0, zoom = input$zoom)
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui = ui, server = server)
