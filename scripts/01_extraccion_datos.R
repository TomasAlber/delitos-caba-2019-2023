# Trabajo Final de "Ciencia de Datos para Economía y Negocios"
# Facultad de Ciencias Económicas - Universidad de Buenos Aires
# Alumnos: Tomas Alberganti - Catalina Furman
# Profesor: Nicolas Sidicaro

# ==============================================================================
# I. EXTRACCIÓN DE DATOS DE DELITOS DE CABA DESDE EL PORTAL DE DATOS PÚBLICOS
# ==============================================================================

library(httr)
library(readr)
library(purrr)
library(here)
library(dplyr)
library(stringr)

# 1. Configuración inicial -----------------------------------------------------------
# Crear la carpeta 'raw' si no existe (relativa al directorio del proyecto)
dir_raw <- here("raw")
if (!dir.exists(dir_raw)) {
  dir.create(dir_raw, recursive = TRUE)
  message("Se creó el directorio 'raw' para almacenar los datos")
}

# 2. URLs de los archivos CSV a descargar --------------------------------------------
urls <- list(
  "2019" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2019.csv",
  "2020" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2020.csv",
  "2021" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2021.csv",
  "2022" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2022.csv",
  "2023" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2023.csv"
)

# 3. Función para descargar y procesar archivos --------------------------------------
descargar_delitos_csv <- function(url, año, destino) {
  archivo_final <- file.path(destino, paste0("delitos_", año, ".csv"))
  
  tryCatch({
    # Descargar archivo directamente
    GET(url, write_disk(archivo_final, overwrite = TRUE))
    
    # Verificar que el archivo se descargó correctamente
    if (file.size(archivo_final) > 0) {
      message(paste0("Datos del ", año, " descargados correctamente en: ", archivo_final))
      return(TRUE)
    } else {
      file.remove(archivo_final)
      stop("Archivo descargado está vacío")
    }
  }, error = function(e) {
    message(paste0("Error al descargar datos del ", año, ": ", e$message))
    if (file.exists(archivo_final)) file.remove(archivo_final)
    return(FALSE)
  })
}

# 4. Ejecución de descargas ---------------------------------------------------------
resultados <- imap(urls, ~descargar_delitos_csv(.x, .y, dir_raw))

# 5. Verificación de resultados ------------------------------------------------------
cat("\nResumen de descargas:\n")
cat("--------------------\n")
walk2(names(resultados), resultados, ~cat(.x, ": ", ifelse(.y, "Éxito", "Falló"), "\n"))

# 6. Verificación de archivos descargados --------------------------------------------
archivos_descargados <- list.files(dir_raw, pattern = "delitos_\\d{4}\\.csv$", full.names = TRUE)
cat("\nArchivos descargados en '", dir_raw, "':\n", sep = "")
cat(paste("-", basename(archivos_descargados), collapse = "\n"), "\n")

# 7. Validación de estructura de los archivos ----------------------------------------
cat("\nValidando estructura de archivos...\n")

validar_estructura <- function(archivo) {
  tryCatch({
    # Usar read_csv para todos los archivos
    datos <- read_csv(archivo, n_max = 5, show_col_types = FALSE)
    cat("\nArchivo:", basename(archivo), "\n")
    cat("Registros:", nrow(datos), "\n")
    cat("Columnas:", ncol(datos), "\n")
    cat("Primeras columnas:", paste(names(datos)[1:5], collapse = ", "), "\n")
    return(TRUE)
  }, error = function(e) {
    cat("\nError al validar", basename(archivo), ":", e$message, "\n")
    return(FALSE)
  })
}

# Ejecutar validación para cada archivo
walk(archivos_descargados, validar_estructura)