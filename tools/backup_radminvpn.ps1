<# 
Copyright (C) 2024 Marc Lecha Blesa

Este programa es software libre; puedes redistribuirlo y/o modificarlo
bajo los términos de la Licencia Pública General de GNU según se publicó
por la Free Software Foundation; ya sea la versión 3 de la Licencia, o
(a tu elección) cualquier versión posterior.

Este programa se distribuye con la esperanza de que sea útil,
pero SIN NINGUNA GARANTÍA; sin siquiera la garantía implícita de
COMERCIABILIDAD o ADECUACIÓN A UN PROPÓSITO PARTICULAR.
Consulta la Licencia Pública General de GNU para más detalles.

Debes haber recibido una copia de la Licencia Pública General de GNU
junto con este programa; si no, consulta <https://www.gnu.org/licenses/>.

Nota: Esta es una traducción de la GPL. En caso de discrepancia, 
la versión oficial en inglés prevalecerá.
#>

# Ruta completa al archivo de configuración
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\config.psd1"

# Importar el archivo de configuración
$config = Import-PowerShellDataFile -Path $configPath

# Verificar si el archivo de configuración existe
if (!(Test-Path -Path $configPath)) {
    Write-Error "El archivo de configuración 'config.psd1' no se encontró en la ruta: $configPath"
    Pause
    exit
}

# Asignar las variables desde la configuración
$registryPath = $config.registryPath
$backupPath = Join-Path -Path $PSScriptRoot -ChildPath $config.backupPath
$backupFilePath = "$($backupPath)\RadminVPN_Backup.reg"

# Crear carpeta de backups si no existe
if (!(Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath > $null
}

# Obtener permisos actuales
$acl = Get-Acl "Registry::$registryPath"
$originalOwner = $acl.Owner

# Tomar propiedad temporalmente
Write-Host "Tomando propiedad de la clave..."
$adminAccount = New-Object System.Security.Principal.NTAccount("Administradores")
$acl.SetOwner($adminAccount)
Set-Acl -Path "Registry::$registryPath" -AclObject $acl

# Exportar clave del registro
Write-Host "Exportando clave del registro..."
reg export $registryPath $backupFilePath /y

# Restaurar propiedad a NT AUTHORITY\SYSTEM
Write-Host "Restaurando propiedad original..."
$systemAccount = New-Object System.Security.Principal.NTAccount($originalOwner)
$acl.SetOwner($systemAccount)
Set-Acl -Path "Registry::$registryPath" -AclObject $acl


Write-Host "Backup completado. Archivo guardado en: $($config.$backupPath)"
Pause