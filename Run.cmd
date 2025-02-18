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

title RadminVPN Backup Utility
chcp 65001 >nul
set "SCRIPT_DIR=%~dp0"
set "PSEXEC_PATH=%SCRIPT_DIR%tools\PsExec64.exe"
set "SCRIPT_PATH=%SCRIPT_DIR%tools\backup_radminvpn.ps1"
set "SCRIPT_DOWNLOAD=%SCRIPT_DIR%tools\download_psexec.bat"

REM Verificar si PsExec existe
if not exist "%PSEXEC_PATH%" (
    call :DescargarPsExec
)

REM Verificar si el usuario tiene permisos de administrador
cacls "%systemroot%\system32\config\">nul 2>&1
if not %errorlevel% == 0 (call :msgAdmin)

REM Si PsExec existe, ejecutar el script de PowerShell
call :EjecutarPsExec

REM Verificar si PsExec se ejecutó correctamente
if %errorlevel% == 1 (
    echo Error: No se pudo ejecutar PsExec
    pause
)
exit

:DescargarPsExec
    echo Error: PsExec no encontrado en %PSEXEC_PATH%.
    echo.
    echo Puedes descargar PsExec desde: https://docs.microsoft.com/en-us/sysinternals/download/psexec
    echo.
    
    choice /m "¿Deseas descargar PsExec ahora? (S/N)" /c:sn /n
    
    REM Verificar si el usuario quiere descargar PsExec
    if not %errorlevel% == 1 (
        echo PsExec no está disponible. El proceso se detendrá.
        pause
        exit
    )

    echo Descargando PsExec...
    REM Llamar al script de descarga (ubicado en tools)
    set "CALL_INDICATOR=1"
    call %SCRIPT_DOWNLOAD%
    set "CALL_INDICATOR="
    
    REM Verificar si PsExec se descargó correctamente
    if not exist "%PSEXEC_PATH%" (
        echo Error: No se pudo descargar PsExec. Abortando...
        pause
        exit
    )
exit /b

:EjecutarPsExec
    "%PSEXEC_PATH%" -i -s powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%"
exit /b

:msgAdmin
    cls
    echo Esta herramienta necesita permisos de administrado para poder funcionar correctamente. 
    choice /m "¿Quieres ejecutarlo como administrador? (S/N)" /c:sn /n
    if %errorlevel% == 1 (goto :admin)
    echo.
    echo El proceso se detendrá.
    pause
exit


:admin
    echo Set admin = CreateObject("Shell.Application") > "%temp%\admin.vbs"
    echo admin.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\admin.vbs"
    "%temp%\admin.vbs"
    del "%temp%\admin.vbs"
exit