## Trabajo Final de "Ciencia de Datos para Economía y Negocios"
## Facultad de Ciencias Económicas - Universidad de Buenos Aires
# Alumno: Tomas Alberganti
# Número de Registro: 892.796
# Profesor: Nicolas Sidicaro


# ==============================================================================
# III. ANÁLISIS EXPLORATORIO (EDA)
# ==============================================================================

# 1. Descarga de librerias requeridas -----------------------------------------------------

library(tidyverse)
library(lubridate)
library(ggplot2)
library(plotly)
library(leaflet)
library(leaflet.extras)
library(sf)
library(glue)
library(ggmap)
library(hexbin)
library(knitr)
library(scales)
library(summarytools)

# --------------------------------------------
# ANÁLISIS PARA EL MINISTERIO DE SEGURIDAD
# --------------------------------------------

# 1. Instalación y carga de paquetes ----
if(!require(pacman)) install.packages("pacman")
pacman::p_load(
  # EDA y manipulación
  tidyverse, lubridate, skimr, janitor,
  # Visualización avanzada
  ggthemes, gghighlight, patchwork, viridis,
  # Mapas profesionales
  sf, leaflet, leaflet.extras, tmap, 
  # Tablas formateadas
  gt, gtsummary,
  # Análisis espacial
  spdep, cartography
)

# 3. Gráfico 1: Evolución temporal (profesional) ----
g1 <- delitos %>%
  count(anio, mes) %>%
  ggplot(aes(x = mes, y = n, group = anio, color = factor(anio))) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_color_viridis(discrete = TRUE, end = 0.9) +
  labs(
    title = "EVOLUCIÓN MENSUAL DE DELITOS (2019-2023)",
    subtitle = "Tendencia interanual comparada",
    x = NULL,
    y = "Cantidad de delitos",
    color = "Año"
  ) +
  theme_economist() +
  theme(
    text = element_text(family = "Arial Narrow"),
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  )


# 4. Gráfico 2: Distribución por tipo de delito (treemap) ----
if(!require(treemapify)) install.packages("treemapify")
library(treemapify)

g2 <- delitos %>%
  count(tipo_delito1, name = "total") %>%
  mutate(porcentaje = total/sum(total)) %>%
  ggplot(aes(area = total, fill = porcentaje, 
             label = paste0(tipo_delito1, "\n", round(porcentaje*100,1), "%"))) +
  geom_treemap() +
  geom_treemap_text(colour = "white", place = "centre", grow = TRUE) +
  scale_fill_viridis(option = "magma", direction = -1) +
  labs(
    title = "DISTRIBUCIÓN POR TIPO DE DELITO",
    fill = "Porcentaje"
  ) +
  theme(legend.position = "bottom")

# 5. Gráfico 3: Heatmap día-hora ----
g3 <- delitos %>%
  count(dia, franja) %>%
  ggplot(aes(x = franja, y = dia, fill = n)) +
  geom_tile(color = "white", linewidth = 0.2) +
  scale_fill_gradientn(colors = viridis::magma(256), 
                       labels = scales::comma) +
  labs(
    title = "ACTIVIDAD DELICTIVA POR DÍA Y HORA",
    x = "Hora del día",
    y = NULL,
    fill = "N° de delitos"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(face = "bold")
  )

# 6. Gráfico 4: Uso de armas por comuna (barras horizontales) ----
g4 <- delitos %>%
  group_by(comuna) %>%
  summarise(
    total = n(),
    con_arma = sum(uso_arma == "SI"),
    tasa = con_arma/total
  ) %>%
  ggplot(aes(x = reorder(comuna, tasa), y = tasa, fill = tasa)) +
  geom_col(width = 0.8) +
  geom_text(aes(label = scales::percent(tasa, accuracy = 1)), 
            hjust = -0.2, size = 3.5) +
  scale_fill_viridis(option = "plasma", direction = -1) +
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.1))) +
  coord_flip() +
  labs(
    title = "TASA DE USO DE ARMAS POR COMUNA",
    x = NULL,
    y = "% de delitos con arma",
    fill = "Tasa"
  ) +
  theme_clean() +
  theme(legend.position = "none")

# 7. Mapa 1: Calor de delitos (Leaflet interactivo) ----
# Precargar shapefile de comunas de CABA
comunas_caba <- st_read("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/comunas/comunas.geojson")

# Calcular densidad por comuna
delitos_comuna <- delitos %>%
  count(comuna, name = "total") %>%
  mutate(comuna = as.character(comuna))

comunas_caba <- comunas_caba %>%
  left_join(delitos_comuna, by = c("COMUNAS" = "comuna"))

# Paleta profesional
pal <- colorNumeric("viridis", domain = comunas_caba$total, alpha = 0.7)

mapa_calor <- leaflet(comunas_caba) %>%
  addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addPolygons(
    fillColor = ~pal(total),
    weight = 1,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 3,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.9,
      bringToFront = TRUE),
    label = ~paste("Comuna", COMUNAS, ":", total, "delitos"),
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) %>%
  addLegend(
    pal = pal,
    values = ~total,
    opacity = 0.7,
    title = "Total de delitos",
    position = "bottomright") %>%
  setView(lng = -58.4333, lat = -34.6133, zoom = 12)

# 8. Mapa 2: Tipos de delito por comuna (facetado) ----
delitos_tipo_comuna <- delitos %>%
  count(comuna, tipo_delito1, name = "total") %>%
  group_by(comuna) %>%
  mutate(porcentaje = total/sum(total)) %>%
  ungroup()

comunas_caba <- comunas_caba %>%
  left_join(delitos_tipo_comuna, by = c("COMUNAS" = "comuna"))

g5 <- tm_shape(comunas_caba) +
  tm_polygons("porcentaje", 
              palette = "viridis",
              style = "quantile",
              n = 5,
              title = "Porcentaje") +
  tm_facets(by = "tipo_delito", ncol = 2) +
  tm_layout(
    main.title = "DISTRIBUCIÓN GEOGRÁFICA POR TIPO DE DELITO",
    main.title.position = "center",
    legend.outside = TRUE,
    frame = FALSE)

# 9. Tabla 1: Resumen estadístico profesional ----
tabla_resumen <- delitos %>%
  tbl_summary(
    include = c("tipo_delito1", "comuna", "franja", "uso_arma", "uso_moto"),
    by = anio,
    type = list(c(uso_arma, uso_moto) ~ "dichotomous"),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    missing = "no"
  ) %>%
  modify_header(label ~ "**Variable**") %>%
  modify_caption("**Tabla 1. Resumen estadístico por año**") %>%
  bold_labels() %>%
  as_gt() %>%
  gt::tab_options(
    table.font.names = "Arial Narrow",
    table.width = "100%"
  )

# 10. Gráfico 6: Serie temporal con eventos clave ----
# Datos de eventos (ej: cuarentena COVID)
eventos <- tibble(
  fecha = as.Date(c("2020-03-20", "2021-01-01", "2022-06-01")),
  evento = c("Inicio Cuarentena", "Nuevo Plan Seguridad", "Refuerzo Patrullajes"),
  y_pos = c(1200, 1500, 1800)
)

g6 <- delitos %>%
  count(fecha) %>%
  ggplot(aes(x = fecha, y = n)) +
  geom_line(color = "#2c7fb8", linewidth = 1) +
  geom_smooth(method = "loess", span = 0.1, color = "#e34a33", se = FALSE) +
  geom_vline(data = eventos, aes(xintercept = fecha), 
             linetype = "dashed", color = "#636363") +
  geom_label(data = eventos, aes(x = fecha, y = y_pos, label = evento),
             family = "Arial Narrow", size = 3) +
  labs(
    title = "EVOLUCIÓN DIARIA CON EVENTOS RELEVANTES",
    subtitle = "Línea roja: tendencia suavizada (LOESS)",
    x = NULL,
    y = "Delitos por día"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Arial Narrow"),
    plot.title = element_text(face = "bold")
  )

# 11. Exportación de resultados ----
# Gráficos estáticos
walk2(list(g1, g2, g3, g4), 
      paste0("grafico_", 1:5, ".png"),
      ~ggsave(.y, .x, width = 12, height = 8, dpi = 300))

# Mapa interactivo
htmlwidgets::saveWidget(mapa_calor, "mapa_calor_delitos.html")

# Tabla
gtsave(tabla_resumen, "tabla_resumen.png")

# --------------------------------------------
# PRESENTACIÓN LISTA PARA ALTOS FUNCIONARIOS
# --------------------------------------------
g1 <- delitos %>%
  # Filtrar y preparar datos
  filter(anio >= 2019 & anio <= 2023) %>%
  mutate(anio = factor(anio)) %>%
  count(anio) %>%
  
  # Crear visualización
  ggplot(aes(
    x = anio,
    y = n,
    group = 1  # Esto conecta los puntos con una línea
  )) +
  
  # Línea evolutiva
  geom_line(
    linewidth = 1.8,
    color = "#1F77B4",  # Color azul profesional
    lineend = "round"
  ) +
  
  # Configuración de ejes
  scale_y_continuous(
    breaks = pretty_breaks(n = 6),  # 6 números en eje Y
    labels = comma_format(),
    expand = expansion(mult = c(0.05, 0.15))) +  # 15% de espacio arriba
      
      # Etiquetas y estilo
      labs(
        title = "EVOLUCIÓN ANUAL DE DELITOS (2019-2023)",
        subtitle = "Tendencia interanual comparada",
        x = "Año",
        y = "Cantidad de delitos",
        caption = "Fuente: Datos oficiales"
      ) +
      
      # Tema profesional
      theme_economist() +  # Estilo económico profesional
      theme(
        text = element_text(family = "Arial Narrow"),
        plot.title = element_text(
          face = "bold",
          size = 16,
          hjust = 0.5,
          margin = margin(b = 10)
        ),
        plot.subtitle = element_text(
          hjust = 0.5,
          size = 12,
          color = "gray50",
          margin = margin(b = 20)
        ),
        axis.text = element_text(size = 11),
        axis.title = element_text(size = 12),
        panel.grid.major.x = element_blank(),
        plot.margin = margin(20, 20, 20, 20)
      )
    