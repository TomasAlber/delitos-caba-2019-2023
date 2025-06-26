## Trabajo Final de "Ciencia de Datos para Economía y Negocios"
## Facultad de Ciencias Económicas - Universidad de Buenos Aires
# Alumno: Tomas Alberganti
# Número de Registro: 892.796
# Profesor: Nicolas Sidicaro

# ==============================================================================
# II. LIMPIEZA DE LA BASE DE DATOS
# ==============================================================================

## En primer lugar, dado que hemos descargado la información del período 2019-2023 en cinco archivos distintos (uno por cada año), vamos a consolidar en un único archivo la información que comprende dicho período para trabajar con mayor facilidad.

# 1. Descarga de librerias requeridas -----------------------------------------------------
library(tidyverse)
library(readr)
library(lubridate)

# Definición de rutas
ruta_base <- "C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023"
ruta_raw <- file.path(ruta_base, "raw")
ruta_input <- file.path(ruta_base, "input")
ruta_output <- file.path(ruta_base, "output")

# Crear directorio de salida si no existe
if (!dir.exists(ruta_input)) {
  dir.create(ruta_input, recursive = TRUE)
}

# 2. Carga de archivos --------------------------------------------------
archivos <- c(
  "delitos_2019.csv",
  "delitos_2020.csv",
  "delitos_2021.csv",
  "delitos_2022.csv",
  "delitos_2023.csv"
)

# Verificar que todos los archivos existan
archivos_existen <- file.exists(file.path(ruta_raw, archivos))

if (!all(archivos_existen)) {
  missing_files <- archivos[!archivos_existen]
  stop(paste("Faltan los siguientes archivos:", paste(missing_files, collapse = ", ")))
}

# 3. Función para leer y estandarizar columnas ---------------------------------
leer_y_estandarizar <- function(archivo) {
  # Leer archivo especificando tipos de columnas problemáticas
  datos <- read_csv(
    file.path(ruta_raw, archivo),
    col_types = cols(
      franja = col_character(),  # Forzar a carácter
      `id-mapa` = col_character(),  # Forzar a carácter
      .default = col_guess()  # Dejar que adivine el resto
    ),
    show_col_types = FALSE
  )
  
  # Estandarizar nombres de columnas
  datos <- datos %>%
    rename_with(~tolower(gsub("[^a-zA-Z0-9]", "_", .x))) %>%
    rename(
      id_mapa = matches("id_mapa|id.mapa"),
      tipo_delito = matches("tipo|tipo_delito"),
      subtipo_delito = matches("subtipo|subtipo_delito")
    )
  
  return(datos)
}

# 4. Combinación de datos ------------------------------------------------------------
# Leer y combinar todos los archivos con manejo de errores
delitos <- map(archivos, ~{
  tryCatch(
    leer_y_estandarizar(.x),
    error = function(e) {
      message(paste("Error al procesar", .x, ":", e$message))
      NULL
    }
  )
}) %>%
  compact() %>%  # Eliminar elementos NULL (archivos con errores)
  reduce(bind_rows) %>%  # Combinar todos los data frames
  mutate(
    fecha = as.Date(fecha),
    anio = year(fecha),
    mes = factor(mes, levels = c("ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO",
                                 "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE")),
    dia = factor(dia, levels = c("LUNES", "MARTES", "MIERCOLES", "JUEVES", 
                                 "VIERNES", "SABADO", "DOMINGO")),
    uso_arma = ifelse(uso_arma == "SI", TRUE, FALSE),
    uso_moto = ifelse(uso_moto == "SI", TRUE, FALSE),
    latitud = as.numeric(latitud),
    longitud = as.numeric(longitud)
  ) %>%
  filter(!is.na(latitud), !is.na(longitud))

# 5. Estandarización de la información -----------------------------------------

delitos <- delitos %>%
  # Estandarización de nombres de barrios
  mutate(barrio = case_when(
    barrio == "NUÑEZ" ~ "NUNEZ",
    barrio == "CONTITUCIÓN" ~ "CONSTITUCION",
    barrio == "VILLA GENERAL MITRE" ~ "VILLA GRAL. MITRE",
    barrio == "VILLA ´PUEYRREDON" ~ "VILLA PUEYRREDON",
    barrio == "BOCA" ~ "LA BOCA",
    TRUE ~ barrio  # Mantener otros valores sin cambios
  )) %>%
  
  # Eliminación de datos con información erróneamente incompleta
  filter(
    !barrio %in% c("0", "NULL", "NO ESPECIFICADA", "SD", "Sin geo"),  # Valores específicos
    !is.na(barrio),                                  # Eliminar NA
    barrio != "",                                    # Eliminar strings vacíos
  ) 

# 6. Guardado del dataset final ---------------------------------------------------
write_csv(delitos, file.path(ruta_input, "delitos_2019_2023.csv"))

