# **RadminVPN Backup Utility**

## **Descripción**

Esta herramienta permite generar copias de seguridad de las credenciales de **RadminVPN** almacenadas en el registro de Windows.

## **Dependencias**

- **PowerShell** (incluido en Windows).
- **PsExec64.exe** ([Descargar aquí](https://download.sysinternals.com/files/PSTools.zip)).

## **Instalación y Uso**

### **Cómo usar la herramienta**

1. Ejecuta el archivo `Run.cmd`. Durante la ejecución, se pedirá confirmar si deseas ejecutar la herramienta con privilegios de administrador.
   
2. Si el archivo `PsExec64.exe` no se encuentra en el directorio `tools`, la herramienta te preguntará si deseas descargarlo e instalarlo automáticamente.

3. Una vez que se ejecute con privilegios de administrador, la herramienta realizará una copia de seguridad de las credenciales de **RadminVPN** y las guardará en el directorio `backups`.

> **Nota:** La herramienta solo podrá crear copias de seguridad si las credenciales de **RadminVPN** están presentes en el registro de Windows.

> **Importante:** La herramienta requiere privilegios de administrador para funcionar correctamente. Si no se ejecuta como administrador, la herramienta se detendrá y pedirá permisos para hacerlo.

### **Archivo de configuración `config.psd1`**

La herramienta utiliza un archivo de configuración llamado `config.psd1` que contiene las variables necesarias para acceder a las credenciales de **RadminVPN**. Este archivo se encuentra en la raíz del proyecto y contiene las siguientes variables:

- `registryPath`: Ruta del registro de Windows donde se encuentran las credenciales de **RadminVPN**.
- `backupPath`: Ruta del directorio donde se guardarán las copias de seguridad de las credenciales.

Por defecto, las rutas son:

- Registro: `HKLM\SOFTWARE\WOW6432Node\Famatech\RadminVPN\`
- Directorio de copias de seguridad: `..\backups\`

> **Nota:** La ruta del registro debe existir antes de ejecutar la herramienta. Si no se encuentra, la herramienta no podrá funcionar.

### **Instalación de `PsExec64.exe`**

Si el archivo `PsExec64.exe` no está presente en el directorio `tools`, la herramienta intentará descargarlo automáticamente desde el paquete **PsTools** de Sysinternals.

#### **Instalación Manual de `PsExec64.exe`**

Si prefieres descargar e instalar **PsExec64.exe** manualmente, sigue estos pasos:

1. Descarga el paquete **PsTools** desde el sitio oficial de **Sysinternals**:
   - [sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/psexec)

2. Extrae el contenido del archivo ZIP descargado.

3. Copia el archivo `PsExec64.exe` al directorio `tools` de la herramienta.

## **Licencia**

Este proyecto está licenciado bajo la **Licencia Pública General de GNU v3**. Consulta el archivo `LICENSE` para más detalles.
