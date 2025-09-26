@echo off
REM Script para mover carpetas desde una ruta de origen en D: hacia
REM una carpeta del escritorio. Mueve una carpeta por hora durante 8 horas,
REM renombra las carpetas movidas con la fecha y hora, y crea una copia
REM adicional con el mismo nombre en una subcarpeta de copias.

setlocal EnableExtensions EnableDelayedExpansion

REM === Configuración ===
REM Ruta de origen: carpeta en D: con las carpetas a mover.
set "SOURCE=D:\\CarpetasPendientes"
REM Ruta de destino: carpeta en el escritorio del usuario actual.
set "DESTINATION=%USERPROFILE%\Desktop\CarpetasMovidas"
REM Carpeta para las copias de seguridad.
set "COPIES=%DESTINATION%\Copias"
REM Cantidad máxima de carpetas a mover (una por hora).
set "MAX_COUNT=8"

REM === Preparación de carpetas de destino ===
if not exist "%DESTINATION%" (
    mkdir "%DESTINATION%"
)
if not exist "%COPIES%" (
    mkdir "%COPIES%"
)

REM Contador de carpetas movidas en esta sesión
set /a "COUNT=0"

REM Iterar sobre cada carpeta en el origen
for /d %%F in ("%SOURCE%\*") do (
    if !COUNT! geq %MAX_COUNT% goto :END

    set "SRC_FOLDER=%%~fF"
    set "BASE_NAME=%%~nxF"
    set /a "COUNT+=1"

    call :MOVE_AND_COPY "!SRC_FOLDER!" "!BASE_NAME!" "!COUNT!"

    REM Esperar una hora antes de procesar la siguiente carpeta, excepto
    REM si ya alcanzamos el máximo establecido.
    if !COUNT! lss %MAX_COUNT% (
        timeout /t 3600 /nobreak >nul
    )
)

goto :END

:MOVE_AND_COPY
REM %1 = ruta completa de la carpeta origen
REM %2 = nombre base de la carpeta
REM %3 = número consecutivo durante esta ejecución
set "SRC_FOLDER=%~1"
set "BASE_NAME=%~2"
set "INDEX=%~3"

REM Obtener marca de tiempo formateada (requiere PowerShell)
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmm"`) do (
    set "STAMP=%%T"
)
set "DATE_STAMP=!STAMP:~0,8!"
set "TIME_STAMP=!STAMP:~9,4!"

set "NEW_NAME=!DATE_STAMP!_!TIME_STAMP!_!INDEX!_!BASE_NAME!"

REM Mover y renombrar la carpeta
move "%SRC_FOLDER%" "%DESTINATION%\!NEW_NAME!" >nul

REM Crear una copia de la carpeta movida
robocopy "%DESTINATION%\!NEW_NAME!" "%COPIES%\!NEW_NAME!" /MIR >nul

exit /b

:END
endlocal

