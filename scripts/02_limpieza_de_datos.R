## Trabajo Final de "Ciencia de Datos para Economía y Negocios"
## Facultad de Ciencias Económicas - Universidad de Buenos Aires
# Alumno: Tomas Alberganti
# Número de Registro: 892.796

# Script para combinar archivos anuales de delitos en CABA (2019-2023)

# 1. Configuración inicial -----------------------------------------------------
library(tidyverse)
library(readr)

# Definir rutas
ruta_base <- "C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023"
ruta_raw <- file.path(ruta_base, "raw")
ruta_input <- file.path(ruta_base, "input")

# Crear directorio de salida si no existe
if (!dir.exists(ruta_input)) {
  dir.create(ruta_input, recursive = TRUE)
}

# 2. Listar y cargar archivos --------------------------------------------------
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

# 4. Combinar datos ------------------------------------------------------------
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

# 5. Verificación y guardado ---------------------------------------------------
cat("\nResumen de datos combinados:\n")
cat("--------------------------\n")
cat("Total de registros:", nrow(delitos_completo), "\n")
cat("Columnas:", names(delitos_completo), "\n")

# Mostrar estructura de los datos
cat("\nEstructura de los datos combinados:\n")
str(delitos_completo)

# Guardar archivo combinado
output_file <- file.path(ruta_input, "delitos_2019_2023.csv")
write_csv(delitos_completo, output_file)

cat("\nArchivo combinado guardado en:", output_file, "\n")

# 6. Validación final ----------------------------------------------------------
cat("\nValidación final:\n")
cat("Conteo de registros por archivo original:\n")
conteo_registros <- map_int(archivos, ~{
  if (file.exists(file.path(ruta_raw, .x))) {
    nrow(leer_y_estandarizar(.x))
  } else {
    0
  }
})
print(data.frame(Archivo = archivos, Registros = conteo_registros))
cat("Total registros esperados:", sum(conteo_registros), "\n")
cat("Total registros obtenidos:", nrow(delitos_completo), "\n")