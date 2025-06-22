## Trabajo Final de "Ciencia de Datos para Economía y Negocios"
## Facultad de Ciencias Económicas - Universidad de Buenos Aires
# Alumno: Tomas Alberganti
# Número de Registro: 892.796
# Profesor: Nicolas Sidicaro

install.packages("summarytools")
# ==============================================================================
# III. ANÁLISIS EXPLORATORIO (EDA)
# ==============================================================================

# 1. Descarga de librerias requeridas -----------------------------------------------------
library(summarytools)

# 3.1 Resumen estadístico
summarytools::view(
  dfSummary(delitos_actualizado, graph.magnif = 0.8),
  file = "C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023/output/resumen_estadistico.html"
)

# 3.2 Evolución temporal
ggplot(delitos_actualizado, aes(x = fecha)) +
  geom_freqpoly(bins = 60, color = "steelblue") +
  labs(title = "Evolución de delitos (2019-2023)",
       x = "Fecha", y = "Cantidad de delitos") +
  theme_minimal()
ggsave("C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023/output/evolucion_temporal.png", width = 10, height = 6)

# 3.3 Distribución por tipo de delito
top_delitos <- delitos_actualizado %>%
  count(tipo_delito1, sort = TRUE) %>%
  top_n(10)

ggplot(top_delitos, aes(x = reorder(tipo_delito1, n), y = n)) +
  geom_col(fill = "tomato") +
  coord_flip() +
  labs(title = "Top 10 tipos de delitos",
       x = "", y = "Cantidad") +
  theme_minimal()
ggsave("C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023/output/top_delitos.png", width = 10, height = 6)

# 3.4 Mapa de calor de delitos
leaflet(delitos_actualizado %>% sample_n(5000)) %>%
  addTiles() %>%
  addHeatmap(lng = ~longitud, lat = ~latitud, intensity = 0.6, radius = 12) %>%
  saveWidget(file = "C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023/output/mapa_calor_delitos.html")

