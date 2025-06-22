## 📊 Análisis de Delitos en la Ciudad Autónoma de Buenos Aires (2019-2023)

### 🎯 Objetivo
Este repositorio de Github documenta el **análisis integral** de los delitos reportados en la Ciudad Autónoma de Buenos Aires en el período 2019-2023o como parte del **Trabajo Final** para la materia *Ciencia de Datos para Economía y Negocios* de la Facultad de Ciencias Económicas (UBA). 

Incluye el proceso completo desde EDA hasta modelos predictivos, con visualizaciones interactivas y presentación ejecutiva.

## 📑 Fuente de Datos
La información utilizada para la realización de este trabajo fue obtenida a través del portal de datos públicos de la **Subsecretaría de Investigación y Estadística Criminal** del **Ministerio de Seguridad de la Ciudad Autónoma de Buenos Aires**:

🔗 [Portal Buenos Aires Data - Delitos](https://data.buenosaires.gob.ar/dataset/delitos)  

📆 Período cubierto: Enero 2019 - Diciembre 2023

## 📐 Estructura del Dataset
| Campo          | Tipo     | Descripción |
|----------------|----------|-------------|
| **id_mapa**    | integer  | ID único del registro |
| **anio**       | date     | Año del evento |
| **mes**        | string   | Mes del evento |
| **dia**        | string   | Día de la semana |
| **fecha**      | date     | Fecha completa (YYYY-MM-DD) |
| **franja**     | integer  | Hora del día (0-23) |
| **tipo_delito1**| string  | Tipo principal (Robo/Hurto) |
| **subtipo_delito**| string | Variante específica |
| **uso_arma**   | boolean  | ¿Se usó arma? (SI/NO) |
| **uso_moto**   | boolean  | ¿Se usó moto? (SI/NO) |
| **barrio**     | string   | Barrio de ocurrencia |
| **comuna**     | integer  | Comuna (1-15) |
| **latitud**    | string   | Coordenada latitudinal |
| **longitud**   | string   | Coordenada longitudinal |
| **cantidad**   | integer  | Conteo de eventos (normalmente 1) |


## 🗂️ Estructura del repositorio

- 📄 **Presentación final**: Resumen visual en formato PPTX/PDF.

- 📂 **Datos**: Bases originales y procesadas (CSV, JSON o formatos compatibles).

- 📊 **Análisis Exploratorio (EDA)**: Jupyter Notebooks o scripts (Python/R) con limpieza, estadísticas descriptivas y gráficos.

- 🤖 **Modelos**: Implementación de algoritmos (clustering, series temporales, etc.).

- 📈 **Visualizaciones**: Gráficos interactivos (Plotly, Tableau) o estáticos (Matplotlib, Seaborn).

- 📝 **Informe técnico**: Conclusiones, metodología y hallazgos (opcional en Markdown/PDF).

## 🛠️ Herramientas utilizadas

- **Lenguajes**: Python (pandas, scikit-learn) o R (tidyverse, caret).

- **Visualización**: Power BI/Tableau (opcional), Plotly, Folium (mapas).

- **Control de versiones**: Git + GitHub.

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
📝 Registro: 892.796  
📧 Contacto: [tomasalberganti@gmail.com]()  
🏛️ FCE-UBA - Ciencia de Datos para Economía y Negocios

## 📌 Cómo Utilizar
1. Clonar repositorio
2. Instalar dependencias: `pip install -r requirements.txt`
3. Ejecutar notebooks en orden numérico
4. Consultar [guía rápida](/docs/quickstart.md) para visualizaciones


## 🔍 ¿Cómo navegar el repositorio?

- Los códigos están organizados en carpetas por etapa:`/raw` , `/input` , `/output` y `/scripts`.

- La **presentación final** en formato PDF se encuentra en `/presentation`.

## 📑 Acceso directo a la documentación principal

- [Base de datos original](/raw)
  
- [Base de datos procesada](/input)
  
- [Resultados generados](/output)

- [Scripts de procesamiento](/scripts)

- [Presentación final](/presentation)
