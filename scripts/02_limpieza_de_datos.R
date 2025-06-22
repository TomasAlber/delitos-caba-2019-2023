## Trabajo Final de "Ciencia de Datos para Economía y Negocios"
## Facultad de Ciencias Económicas - Universidad de Buenos Aires
# Alumno: Tomas Alberganti
# Número de Registro: 892.796
# Profesor: Nicolas Sidicaro

### Script de limpieza de archivos previamente descargados
## En primer lugar, dado que hemos descargado la información del período 2019-2023 en cinco archivos distintos (uno por cada año), vamos a consolidar en un único archivo la información que comprende dicho período para trabajar con mayor facilidad.

# 1. Descarga de librerias requeridas -----------------------------------------------------
library(tidyverse)
library(readr)

# Definición de rutas
ruta_base <- "C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023"
ruta_raw <- file.path(ruta_base, "raw")
ruta_input <- file.path(ruta_base, "input")

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
delitos_completo <- map(archivos, ~{
  tryCatch(
    leer_y_estandarizar(.x),
    error = function(e) {
      message(paste("Error al procesar", .x, ":", e$message))
      NULL
    }
  )
}) %>%
  compact() %>%  # Eliminar elementos NULL (archivos con errores)
  reduce(bind_rows)  # Combinar todos los data frames

# 5. Guardado del dataset ---------------------------------------------------

output_file <- file.path(ruta_input, "delitos_2019_2023.csv")
write_csv(delitos_completo, output_file)


## En segundo lugar, vamos a estandarizar algunos formatos de nombres para que la información sea lo más homogénea posible y así poder contar con datos más precisos.

delitos <- read_csv(file.path(ruta_input, "delitos_2019_2023.csv"))

delitos_estandarizado <- delitos %>%
  # Corrección de nombres de días de la semana
  mutate(dia = case_when(
    dia == "LUN" ~ "LUNES",
    dia == "MAR" ~ "MARTES",
    dia == "MIE" ~ "MIERCOLES",
    dia == "JUE" ~ "JUEVES",
    dia == "VIE" ~ "VIERNES",
    dia == "SAB" ~ "SABADO",
    dia == "DOM" ~ "DOMINGO",
    TRUE ~ dia  # Mantener otros valores sin cambios
  )) %>%
  
  # Estandarización de nombres de barrios
  mutate(barrio = case_when(
    barrio == "NUÑEZ" ~ "NUNEZ",
    barrio == "CONTITUCIÓN" ~ "CONSTITUCION",
    barrio == "VILLA GENERAL MITRE" ~ "VILLA GRAL. MITRE",
    barrio == "VILLA ´PUEYRREDON" ~ "VILLA PUEYRREDON",
    barrio == "BOCA" ~ "LA BOCA",
    TRUE ~ barrio  # Mantener otros valores sin cambios
  )) %>%
  
  # Estandarización de números de comuna
  mutate(
    comuna = comuna %>%
      str_replace_all("CC-| NORTE| SUR", "") %>%
      str_trim() %>%
      as.integer()
  ) %>%
  
  # Modificación del formato de la columna franja a número
  mutate(
    franja = as.numeric(franja) 
  ) %>% 
  
  # Eliminación de datos con información erróneamente incompleta
  filter(
    !barrio %in% c("0", "NULL", "NO ESPECIFICADA", "SD", "Sin geo"),  # Valores específicos
    !is.na(barrio),                                  # Eliminar NA
    barrio != "",                                    # Eliminar strings vacíos
  ) %>% 
  
  # Eliminación de barrios que no corresponden a CABA
  filter(
    !barrio %in% c("AV BOEDO", "BERNAL", "BANFIELD OESTE", "CASEROS", 
    "DOCK SUD", "RODRIGO BUENO", "SANTA MARÍA", 
    "VILLA LUZURIAGA", "FLORIDA", "GREGORIO DE LAFERRERE")
    )

  # Creación de diccionario de las comunas con sus respectivos barrios
diccionario_comunas <- tribble(
  ~barrio, ~comuna_correcta,
  "AGRONOMIA", 15,
  "ALMAGRO", 5,
  "BALVANERA", 3,
  "BARRACAS", 4,
  "BELGRANO", 13,
  "BOEDO", 5,
  "CABALLITO", 6,
  "CHACARITA", 15,
  "COGHLAN", 12,
  "COLEGIALES", 13,
  "CONSTITUCION", 1,
  "FLORES", 7,
  "FLORESTA", 10,
  "LA BOCA", 4,
  "LINIERS", 9,
  "MATADEROS", 9,
  "MONSERRAT", 1,
  "MONTE CASTRO", 10,
  "NUEVA POMPEYA", 4,
  "NUNEZ", 13,
  "PALERMO", 14,
  "PARQUE AVELLANEDA", 9,
  "PARQUE CHACABUCO", 7,
  "PARQUE CHAS", 15,
  "PARQUE PATRICIOS", 4,
  "PATERNAL", 15,
  "PUERTO MADERO", 1,
  "RECOLETA", 2,
  "RETIRO", 1,
  "SAAVEDRA", 12,
  "SAN CRISTOBAL", 3,
  "SAN NICOLAS", 1,
  "SAN TELMO", 1,
  "VELEZ SARSFIELD", 10,
  "VERSALLES", 10,
  "VILLA CRESPO", 15,
  "VILLA DEL PARQUE", 11,
  "VILLA DEVOTO", 11,
  "VILLA GRAL. MITRE", 11,
  "VILLA LUGANO", 8,
  "VILLA LURO", 10,
  "VILLA ORTUZAR", 15,
  "VILLA PUEYRREDON", 12,
  "VILLA REAL", 10,
  "VILLA RIACHUELO", 8,
  "VILLA SANTA RITA", 11,
  "VILLA SOLDATI", 8,
  "VILLA URQUIZA", 12
)

  # Actualización de números de comuna
delitos_actualizado <- delitos_estandarizado %>%
  # Converción a mayúsculas para evitar problemas de case sensitivity
  mutate(barrio = str_to_upper(barrio)) %>%
  # Unificación con el diccionario
  left_join(diccionario_comunas, by = "barrio") %>%
  # Reemplazar la comuna original por la correcta
  mutate(comuna = ifelse(is.na(comuna_correcta), comuna, comuna_correcta)) %>%
  # Eliminar columna temporal
  select(-comuna_correcta)


# Guardar dataset transformado 
write_csv(delitos_actualizado, file.path(ruta_input, "delitos_2019_2023.csv"))



