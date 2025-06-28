## 📊 Análisis de Delitos en la Ciudad Autónoma de Buenos Aires (2019-2023)

### 🎯 Objetivo
Este repositorio de Github documenta el **análisis integral** de los delitos reportados en la Ciudad Autónoma de Buenos Aires entre 2019 y 2023 como parte del **Trabajo Final** para la materia *Ciencia de Datos para Economía y Negocios* de la **Facultad de Ciencias Económicas** de la **Universidad de Buenos Aires**. 

Este trabajo implementa un flujo completo de análisis, comenzando con la exploración y preparación de la base de datos que incluye limpieza, tratamiento de valores atípicos y transformación de variables. El análisis exploratorio se apoya en visualizaciones avanzadas para descubrir patrones temporales y distribuciones geográficas, mientras que el modelado predictivo emplea algoritmos de *Machine Learning* para series temporales, clasificación y clustering. Los resultados se presentan mediante dashboards interactivos y representaciones geoespaciales, junto con un documento final de presentación que incluye todo el abordaje de los análisis realizados.

## 📑 Fuente de Datos
La información utilizada para la realización de este trabajo fue obtenida a través del portal de datos públicos de la **Subsecretaría de Investigación y Estadística Criminal** del **Ministerio de Seguridad de la Ciudad Autónoma de Buenos Aires**:

🔗 [Portal Buenos Aires Data - Delitos](https://data.buenosaires.gob.ar/dataset/delitos)  

📆 Período de análisis: Enero 2019 - Diciembre 2023

## 📐 Estructura del Dataset
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

- 📄 **Presentación final**: Resumen visual en formato PPTX/PDF.

- 📂 **Datos**: Bases originales y procesadas (CSV, JSON o formatos compatibles).

- 📊 **Análisis Exploratorio (EDA)**: Jupyter Notebooks o scripts (Python/R) con limpieza, estadísticas descriptivas y gráficos.

- 🤖 **Modelos**: Implementación de algoritmos (clustering, series temporales, etc.).

- 📈 **Visualizaciones**: Gráficos interactivos (Plotly, Tableau) o estáticos (Matplotlib, Seaborn).

- 📝 **Informe técnico**: Conclusiones, metodología y hallazgos (opcional en Markdown/PDF).

## 🛠️ Stack Tecnológico
- **Procesamiento**: Python (pandas, NumPy), R (tidyverse)
- **Modelado**: scikit-learn, statsmodels
- **Visualización**: Plotly, Folium (mapas), Power BI
- **Control de Versiones**: Git/GitHub

## 🔍 Hallazgos Clave
1. Patrones temporales en frecuencia de delitos
2. Hotspots geográficos identificados
3. Modelos predictivos con 85%+ de precisión
4. Correlación entre variables contextuales

*(Detalles completos en [informe técnico](/reports/findings.md))*

## 🎓 Responsable
**Brandon Tomás Alberganti**  
📝 Nro. de Registro: 892.796  
📧 Contacto: [tomasalberganti@gmail.com](mailto:tomasalberganti@gmail.com)  
🏛️ Facultad de Ciencias Económicas - Universidad de Buenos Aires

## 🔍 Cómo Navegar el Repositorio

- Los materiales están organizados en carpetas a partir de la siguiente estructura:
  - `/raw`: Archivos de datos sin procesar.
  - `/input`: Archivos de datos procesados y listos para el análisis.
  - `/output`: Resultados generados (gráficos, estadísticas descriptivas y modelos de *Machine Learning*).
  - `/scripts`: Códigos utilizados en el trabajo.

- La **presentación final** en formato PDF se encuentra en `/presentation`.

## 📑 Accesos Directos

- [Extracción del Dataset](/raw)
  
- [Base de Datos Procesada](/input)
  
- [Análisis Exploratorio y Resultados Generados](/output)

- [Scripts de Procesamiento](/scripts)

- [Presentación Final](/presentation)
