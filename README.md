![image](https://github.com/user-attachments/assets/04c8e867-fbb8-4eb1-99ce-bab3792b03ae)## 📊 Análisis de Delitos en la Ciudad Autónoma de Buenos Aires (2019-2023)

### 🎯 Objetivo
Este repositorio de Github documenta el **análisis integral** de los delitos reportados en la Ciudad Autónoma de Buenos Aires entre 2019 y 2023 como parte del **Trabajo Final** para la materia *Ciencia de Datos para Economía y Negocios* de la **Facultad de Ciencias Económicas** de la **Universidad de Buenos Aires**. 

En primer lugar, este trabajo implementa un flujo completo de análisis, comenzando con la exploración y preparación de la base de datos que incluye limpieza, tratamiento de valores atípicos y transformación de variables. Por otro lado, el análisis exploratorio se apoya en visualizaciones avanzadas para descubrir patrones temporales y distribuciones geográficas, mientras que para la visualización de los resultados se presenta un *dashboard interactivo* en Power BI, el cual ofrece una representación visual de los datos para explorar los registros mediante filtros, segmentaciones y gráficos interactivos, facilitando la identificación de patrones y tendencias. Por último, el proyecto se acompaña con un documento final de presentación que incluye todo el abordaje de los análisis realizados.

## 📑 Fuente de Datos
La información utilizada para la realización de este trabajo fue obtenida a través del portal de datos públicos de la **Subsecretaría de Investigación y Estadística Criminal** del **Ministerio de Seguridad de la Ciudad Autónoma de Buenos Aires**:

🔗 [Portal Buenos Aires Data - Delitos](https://data.buenosaires.gob.ar/dataset/delitos)  

📆 Período de análisis: Enero 2019 - Diciembre 2023

## 🗃️ Estructura del Dataset
| Campo          | Tipo     | Descripción |
|----------------|----------|-------------|
| **id_mapa**    | integer  | Identificador único |
| **anio**       | date     | Año del evento |
| **mes**        | string   | Mes del evento |
| **dia**        | string   | Día de la semana en que ocurrió el evento |
| **fecha**      | date     | Fecha exacta del evento (YYYY-MM-DD) |
| **franja**     | integer  | Franja horario en la que ocurrió el evento (0-23) |
| **tipo**| string  | Clasificación del tipo de delito |
| **subtipo**| string | Subtipo del delito, más específico |
| **uso_arma**   | boolean  | Indicador de uso de arma (SI/NO) |
| **uso_moto**   | boolean  | Indicador de uso de moto en el evento (SI/NO) |
| **barrio**     | string   | Barrio de ocurrencia del evento |
| **comuna**     | integer  | Comuna de ocurrencia del evento (1-15) |
| ...            | ...      | ... |

*(Tabla completa en [Campos del recurso](https://data.buenosaires.gob.ar/dataset/delitos/resource/dbec0c29-1ada-40df-b13c-75cf3013ca42))*


## 🗂️ Estructura del Repositorio

- 📂 **Base de Datos**: Bases originales y procesadas (.csv).

- 📊 **Análisis Exploratorio (EDA)**: Scripts (R) con limpieza, estadísticas descriptivas y gráficos.

- 📈 **Visualizaciones**: Gráficos estáticos (R) e interactivos (Power BI).

- 📄 **Presentación final**: Presentación con conclusiones, metodología y hallazgos en formato PDF.

## 🛠️ Stack Tecnológico
- **Procesamiento**: R (*tidyverse, lubrydate, dplyr*)
- **Visualización**: R (*ggmpap, ggplot2*) y Power BI (*DAX, Powe Query*)
- **Control de Versiones**: Git/GitHub

## 🎓 Responsables del Proyecto
**Tomás Alberganti**  
📝 Nro. de Registro: 892.796  
📧 Contacto: [tomasalberganti@gmail.com](mailto:tomasalberganti@gmail.com)  

**Catalina Furman**  
📝 Nro. de Registro: 910.465  
📧 Contacto: [catafurman@gmail.com](mailto:catafurman@gmail.com)  


🏛️ Facultad de Ciencias Económicas - Universidad de Buenos Aires

## 🔍 Cómo Navegar el Repositorio

- Los materiales están organizados en carpetas que siguen la siguiente estructura:
  - `/raw`: Contiene la base de datos sin procesar que fue extraída del portal de datos públicos de CABA.
  - `/input`: Contiene base de datos procesada para la realización de los análisis de datos exploratorios y descriptivos.
  - `/output`: Contiene los resultados generados (*i.e.*, gráficos, estadísticas descriptivas y visualización en Power BI).
  - `/scripts`: Contiene los códigos utilizados en el proyecto, enumerados por órden de ejecución.
  - `/presentation`: Contiene la presentación final en formato PDF.

## 📑 Listado de Accesos Directos

- [Extracción del Dataset](/raw)
  
- [Base de Datos Procesada](/input)
  
- [Análisis Exploratorio y Resultados Generados](/output)

- [Scripts de Procesamiento](/scripts)

- [Presentación Final](/presentation)
