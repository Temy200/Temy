# Temy

Este repositorio incluye un script por lotes (`scripts/mover_carpetas.bat`) que automatiza el traslado de carpetas desde una ruta del disco `D:` hacia una carpeta en el escritorio. El script mueve una carpeta por hora durante ocho horas, renombra cada carpeta con la fecha y hora del traslado, y genera una copia adicional con el mismo nombre en una subcarpeta de respaldo.

## Uso rápido
1. Ajusta las variables `SOURCE`, `DESTINATION` y `COPIES` dentro del script para que coincidan con tus rutas.
2. Guarda el archivo con extensión `.bat` y ejecútalo con privilegios suficientes para mover carpetas entre discos.
3. Mantén la ventana abierta: el script esperará una hora (`timeout /t 3600`) entre cada traslado hasta completar ocho carpetas o quedarse sin carpetas en el origen.

> **Nota:** El script utiliza PowerShell para generar marcas de tiempo. Asegúrate de tener PowerShell disponible en el sistema donde lo ejecutes.
