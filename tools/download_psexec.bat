@echo off

:: 
:: Copyright (C) 2024 Marc Lecha Blesa
::
:: Este programa es software libre; puedes redistribuirlo y/o modificarlo
:: bajo los términos de la Licencia Pública General de GNU según se publicó
:: por la Free Software Foundation; ya sea la versión 3 de la Licencia, o
:: (a tu elección) cualquier versión posterior.
::
:: Este programa se distribuye con la esperanza de que sea útil,
:: pero SIN NINGUNA GARANTÍA; sin siquiera la garantía implícita de
:: COMERCIABILIDAD o ADECUACIÓN A UN PROPÓSITO PARTICULAR.
:: Consulta la Licencia Pública General de GNU para más detalles.
::
:: Debes haber recibido una copia de la Licencia Pública General de GNU
:: junto con este programa; si no, consulta <https://www.gnu.org/licenses/>.
::

set "PSEXEC_URL=https://download.sysinternals.com/files/PSTools.zip"
set "ZIP_NAME=PSTools.zip"
set "PS_EXEC_FILE=PsExec64.exe"  
set "TOOLS_PATH=%~dp0" 
set "DOWNLOADER_PATH=%TOOLS_PATH%\downloader"
set "DOWNLOADER_PATH_PSEXEC=%DOWNLOADER_PATH%\%PS_EXEC_FILE%" 
set "PSEXEC_PATH=%TOOLS_PATH%\%PS_EXEC_FILE%"  
set "ZIP_PATH=%DOWNLOADER_PATH%\%ZIP_NAME%"  

REM Crear el directorio "downloader" si no existe
if not exist "%DOWNLOADER_PATH%" (
    mkdir "%DOWNLOADER_PATH%"
)

REM Comprobar si el archivo ZIP ya existe
if exist "%ZIP_PATH%" (
    echo El archivo PSTools.zip ya existe en %DOWNLOADER_PATH%. No se descargará de nuevo.
) else (
    echo Descargando PsExec...
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%PSEXEC_URL%', '%ZIP_PATH%')"
)

echo Extrayendo...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%DOWNLOADER_PATH%' -Force"

REM Mover PsExec64.exe a la carpeta de herramientas
if not exist "%DOWNLOADER_PATH_PSEXEC%" (
    echo Error: No se encontró PsExec64.exe después de la extracción.
    pause 
    exit /b
)

move /Y "%DOWNLOADER_PATH_PSEXEC%" "%PSEXEC_PATH%">nul 2>&1
echo PsExec64.exe movido a %PSEXEC_PATH%

REM Preguntar si se desea eliminar el archivo ZIP
choice /m "¿Deseas borrar el archivo ZIP descargado (S/N)?" /c:sn /n
if %errorlevel% == 1 (
    del /Q "%DOWNLOADER_PATH%\"
) else (
    echo El archivo ZIP NO ha sido borrado.
    REM Eliminar todos los archivos extraídos, pero mantener el ZIP
    for /F "delims=" %%F in ('dir /B "%DOWNLOADER_PATH%"') do (
        if /I not "%%F"=="%ZIP_NAME%" (
            del /Q "%DOWNLOADER_PATH%\%%F"
        )
    )
)

echo PsExec descargado y movido a %PSEXEC_PATH%.
echo Proceso completado.

if defined CALL_INDICATOR (
    exit /b
)
pause
exit

