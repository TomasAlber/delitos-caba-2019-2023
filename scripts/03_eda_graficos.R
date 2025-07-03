# ==============================================================================
# III. ANÁLISIS EXPLORATORIO (EDA)
# ==============================================================================

# Cargar librerías necesarias
library(tidyverse)
library(sf)
library(stringr)
library(scales)

# ================================
# Gráfico 1: Mapa de Calor por Barrios
# ================================

# Leer el shapefile del mapa de barrios (descargado de Buenos Aires Data)
mapa_barrios <- st_read("barrios/barrios.shp")

# Normalizar nombres de barrio en el shapefile
mapa_barrios <- mapa_barrios %>%
  mutate(nombre_clean = str_to_upper(nombre))

# Armar tabla de delitos por barrio con corrección de nombres
# Se corrigen manualmente los barrios con nombres distintos
delitos_barrio <- delitos %>%
  mutate(
    barrio_clean = case_when(
      barrio == "LA BOCA" ~ "BOCA",
      barrio == "NUNEZ" ~ "NUÑEZ",
      TRUE ~ str_to_upper(barrio)
    )
  ) %>%
  count(barrio_clean)

# Unir el mapa con los datos de delitos
mapa_barrios_datos <- left_join(mapa_barrios, delitos_barrio, 
                                by = c("nombre_clean" = "barrio_clean"))

# Crear el mapa de calor con ggplot2
ggplot(mapa_barrios_datos) +
  geom_sf(aes(fill = n)) +
  scale_fill_gradient(low = "white", high = "red") +
  labs(
    title = "Delitos por barrio (2019–2023)",
    fill = "Cantidad"
  ) +
  theme_minimal() +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

# Guardar el gráfico como imagen para la presentación
ggsave("output/mapa_calor_delitos.png", width = 10, height = 8)


# ================================
# Gráfico 2: Delitos por franja horaria
# ================================

delitos_franja <- delitos %>%
  filter(!franja %in% c("NULL", NA)) %>%
  mutate(
    hora = as.numeric(franja),
    franja_grupo = case_when(
      hora >= 0  & hora <= 3  ~ "0 a 3",
      hora >= 4  & hora <= 7  ~ "4 a 7",
      hora >= 8  & hora <= 11 ~ "8 a 11",
      hora >= 12 & hora <= 15 ~ "12 a 15",
      hora >= 16 & hora <= 19 ~ "16 a 19",
      hora >= 20 & hora <= 23 ~ "20 a 23"
    )
  ) %>%
  count(franja_grupo) %>%
  mutate(franja_grupo = factor(franja_grupo, levels = c(
    "0 a 3", "4 a 7", "8 a 11", "12 a 15", "16 a 19", "20 a 23"
  )))

grafico_franja <- ggplot(delitos_franja, aes(x = franja_grupo, y = n)) +
  geom_col(fill = "steelblue") +
  geom_text(
    aes(label = scales::comma(n)),
    vjust = 1.5, color = "white", size = 3.5
  ) +
  scale_y_continuous(
    breaks = seq(0, 140000, by = 20000),
    labels = label_comma()
  ) +
  labs(
    title = "Cantidad de delitos por franja horaria (2019–2023)",
    x = "Franja horaria",
    y = "Cantidad de delitos"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

print(grafico_franja)

# Guardar el gráfico como imagen para la presentación
ggsave("output/delitos_por_franja.png", width = 8, height = 6)

# ================================
# Gráfico 3: Delitos por año
# ================================

grafico_anio <- ggplot(delitos_anio, aes(x = anio, y = n)) +
  geom_col(fill = "steelblue") +
  geom_text(
    aes(label = scales::comma(n)),
    vjust = 1.5,          # ← valor positivo = dentro de la barra
    color = "white",      # texto blanco para mejor contraste
    size = 3.5
  ) +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Cantidad de delitos por año",
    x = "Año",
    y = "Cantidad de delitos"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

print(grafico_anio)

# Guardar el gráfico como imagen para la presentación
ggsave("output/delitos_por_anio.png", grafico_anio, width = 8, height = 6)

# ================================
# Gráfico 4: Delitos por día de la semana
# ================================

delitos_dia <- delitos %>%
  count(dia) %>%
  mutate(
    dia = factor(dia, levels = c(
      "LUNES", "MARTES", "MIERCOLES", "JUEVES",
      "VIERNES", "SABADO", "DOMINGO"
    ))
  )

ggplot(delitos_dia, aes(x = dia, y = n, group = 1)) +
  geom_line(color = "steelblue", size = 1.2) +        
  geom_point(color = "steelblue", size = 3) +         
  scale_y_continuous(
    breaks = seq(0, 120000, by = 10000),              
    labels = label_comma()
  ) +
  labs(
    title = "Delitos por día de la semana (2019–2023)",
    x = "Día de la semana",
    y = "Cantidad de delitos"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

# Guardar el gráfico como imagen para la presentación
ggsave("output/delitos_por_dia_linea.png", width = 8, height = 6)

# ================================
# Gráfico 5: Delitos por mes
# ================================

ggplot(delitos_mes, aes(x = mes, y = n, group = 1)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_point(color = "steelblue", size = 3) +
  geom_text(
    aes(label = scales::comma(n)),
    vjust = -0.6, size = 3.5
  ) +
  scale_y_continuous(
    breaks = seq(0, 60000, by = 20000),
    labels = scales::label_number(big.mark = ".", decimal.mark = ","),
    expand = expansion(mult = c(0, 0.08))  # ← Agrega margen arriba sin vaciar el gráfico
  ) +
  labs(
    title = "Delitos por mes (total acumulado 2019–2023)",
    x = "Mes",
    y = "Cantidad de delitos"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_text(size = 11),
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

# Guardar el gráfico como imagen para la presentación
ggsave("output/delitos_por_mes_linea.png", width = 9, height = 7)

# ================================
# Gráfico 6: Delitos por tipo
# ================================

delitos_tipo <- delitos %>%
  count(tipo_delito1, sort = TRUE)

ggplot(delitos_tipo, aes(x = tipo_delito1, y = n)) +
  geom_col(fill = "steelblue", width = 0.7) +
  geom_text(
    aes(label = scales::comma(n)),
    vjust = -0.6, size = 3.5
  ) +
  scale_y_continuous(
    breaks = seq(0, 260000, by = 20000),
    labels = scales::label_comma(),
    expand = expansion(mult = c(0, 0.1))  # esto sí FUNCIONA
  ) +
  labs(
    title = "Cantidad de delitos por tipo (2019–2023)",
    x = "Tipo de delito",
    y = "Cantidad de delitos"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

# Guardar el gráfico como imagen para la presentación
ggsave("output/delitos_por_tipo_etiquetas.png", width = 9, height = 6)

# ================================
# Gráfico 7: Tipos de Robo
# ================================

# Filtrar solo robos y clasificar modalidad según uso de arma y moto
robos_modalidad <- delitos %>%
  filter(tipo_delito1 == "Robo") %>%
  mutate(
    modalidad = case_when(
      uso_arma & uso_moto ~ "Con arma y moto",
      uso_arma & !uso_moto ~ "Solo arma",
      !uso_arma & uso_moto ~ "Solo moto",
      !uso_arma & !uso_moto ~ "Sin arma ni moto",
      .default = "Desconocido"
    )
  ) %>%
  count(modalidad) %>%
  mutate(
    porcentaje = round(100 * n / sum(n), 1),
    modalidad = fct_reorder(modalidad, n)
  )

grafico_modalidad_robos <- ggplot(robos_modalidad, aes(x = modalidad, y = porcentaje)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = paste0(porcentaje, "%")), vjust = -0.5, size = 4) +
  ylim(0, 100) +
  labs(
    title = "Modalidad de robos según uso de arma y moto (2019–2023)",
    x = "Modalidad",
    y = "Porcentaje sobre total de robos"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 20, hjust = 1)
  )

# Guardar el gráfico como imagen para la presentación
print(grafico_modalidad_robos)
ggsave("output/modalidad_robos_arma_moto.png", grafico_modalidad_robos, width = 9, height = 6)

# ================================
# Gráfico 8: Mapa de Calor por día y hora
# ================================

delitos <- delitos %>%
  filter(!franja %in% c("NULL", NA)) %>%
  mutate(
    hora = as.numeric(franja),
    franja_grupo = case_when(
      hora >= 0  & hora <= 3  ~ "0 a 3",
      hora >= 4  & hora <= 7  ~ "4 a 7",
      hora >= 8  & hora <= 11 ~ "8 a 11",
      hora >= 12 & hora <= 15 ~ "12 a 15",
      hora >= 16 & hora <= 19 ~ "16 a 19",
      hora >= 20 & hora <= 23 ~ "20 a 23",
      .default = NA
    ),
    franja_grupo = factor(franja_grupo, levels = c(
      "0 a 3", "4 a 7", "8 a 11", "12 a 15", "16 a 19", "20 a 23"
    )),
    
    dia = factor(dia, levels = c(
      "LUNES", "MARTES", "MIERCOLES", "JUEVES",
      "VIERNES", "SABADO", "DOMINGO"
    ))
  )

grafico_heatmap <- ggplot(delitos %>% count(dia, franja_grupo), 
                          aes(x = franja_grupo, y = dia, fill = n)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "red") +
  labs(
    title = "Delitos por día y franja horaria (2019–2023)",
    x = "Franja horaria",
    y = "Día de la semana",
    fill = "Cantidad"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

# Guardar el gráfico como imagen para la presentación
print(grafico_heatmap)
ggsave("output/heatmap_dia_franja.png", grafico_heatmap, width = 9, height = 6)
