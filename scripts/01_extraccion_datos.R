# Trabajo Final de "Ciencia de Datos para Economía y Negocios"
# Facultad de Ciencias Económicas - Universidad de Buenos Aires
# Alumno: Tomas Alberganti
# Número de Registro: 892.796
# Profesor: Nicolas Sidicaro

# ==============================================================================
# I. EXTRACCION DE DATOS DE DELITOS DE CABA DESDE EL PORTAL DE DATOS PÚBLICOS
# ==============================================================================

library(httr)
library(readr)
library(purrr)
library(dplyr)
library(stringr)

# Definición de directorio de destino -----------------------------------------------------------
dir_raw <- "C:/Users/Tomas/Documents/GitHub/delitos-caba-2019-2023/raw"

# 2. URLs de los archivos CSV a descargar -------------------------------------------------
urls <- list(
  "2019" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2019.csv",
  "2020" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2020.csv",
  "2021" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2021.csv",
  "2022" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2022.csv",
  "2023" = "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-justicia-y-seguridad/delitos/delitos_2023.csv"
)

# 3. Función para descargar y procesar archivos -------------------------------------------
descargar_delitos_csv <- function(url, año, destino) {
  archivo_final <- file.path(destino, paste0("delitos_", año, ".csv"))
  
  tryCatch({
    # Descargar archivo directamente
    GET(url, write_disk(archivo_final, overwrite = TRUE))
    
    # Verificar que el archivo se descargó correctamente
    if (file.size(archivo_final) > 0) {
      message(paste0("Datos del ", año, " descargados correctamente: ", archivo_final))
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
# 4. Ejecución de descargas --------------------------------------------------------------------
resultados <- imap(urls, ~descargar_delitos_csv(.x, .y, dir_raw))

# 5. Verificación de resultados ------------------------------------------------------------------
cat("\nResumen de descargas:\n")
cat("--------------------\n")
walk2(names(resultados), resultados, ~cat(.x, ": ", ifelse(.y, "Éxito", "Falló"), "\n"))

# 6. Verificación de archivos descargados --------------------------------------------
archivos_descargados <- list.files(dir_raw, pattern = "delitos_\\d{4}\\.csv$", full.names = TRUE)
cat("\nArchivos descargados:\n")
cat(paste(archivos_descargados, collapse = "\n"), "\n")

# 7. Validación de estructura de los archivos ----------------------------------------
cat("\nValidando estructura de archivos...\n")

validar_estructura <- function(archivo) {
  tryCatch({
    # Usar read_csv para todos los archivos
    datos <- read_csv(archivo, n_max = 5)
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

resultados_validacion <- map_lgl(archivos_descargados, validar_estructura)