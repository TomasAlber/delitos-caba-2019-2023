## 📌 Trabajo Final de Ciencia de Datos para Economía y Negocios
Este repositorio de Github almacena el **análisis integral** de la base de datos correspondiente a los delitos reportados en la Ciudad de Buenos Aires en el período 2019 y 2023 como parte del **Trabajo Final** de la materia **Ciencia de Datos para Economía y Negocios** de la Facultad de Ciencias Económicas de la Universidad de Buenos. 

Su objetivo es documentar el proceso completo, desde la exploración inicial hasta los resultados finales, incluyendo visualizaciones, modelos de Machine Learning y la presentación final.

## 🎓 Alumno a cargo
- **Nombre completo**: Brandon Tomás Alberganti

- **Número de registro**: 892.796

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

## 🔍 ¿Cómo navegar el repositorio?

- Los códigos están organizados en carpetas por etapa:`/raw` , `/input` , `/output` y `/scripts`.

- La **presentación final** en formato PDF se encuentra en `/presentation`.

## 📑 Acceso directo a la documentación principal

- [Base de datos original](/raw)
  
- [Base de datos procesada](/input)
  
- [Resultados generados](/output)

- [Scripts de procesamiento](/scripts)

- [Presentación final](/presentation)

## 📐 Estructura del dataset

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


## 📜 Fuente de Datos

La información utilizada para la realización de este trabajo fue obtenida a través del portal de datos públicos de la **Subsecretaría de Investigación y Estadística Criminal** del **Ministerio de Seguridad de la Ciudad Autónoma de Buenos Aires**. Los datos corresponden a los registros de delitos reportados entre los años 2019 y 2023.

🔗 **Enlace al sitio oficial para la descarga de la información**:  
[Buenos Aires Data - GCBA](https://data.buenosaires.gob.ar/dataset/delitos)
