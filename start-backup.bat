@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: Titre de la fenêtre
title Backup is running...

:: Couleur et message d'accueil
color 0A
echo [INFO] Start backup script...

:: Appelle PowerShell avec le bon script, sans fenêtre bloquante
::if exist "Z:\PIRENEA_DATA" (
:: echo [INFO] NAS mounted
::) else (
:: powershell net use Z: "\\nas-pirenea.irap.omp.eu\PIRENEA_DAT"
:: echo [INFO] NAS mounted
::)
if not exist "Z:\PIRENEA_DATA" (
 powershell net use Z: "\\nas-pirenea.irap.omp.eu\PIRENEA_DATA"
)
:: goto ok
::powershell net use Z: "\\nas-pirenea.irap.omp.eu\PIRENEA_DATA"
::goto mounted
:::ok
::echo [INFO] NAS mounted !
::mounted
::powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%~dp0backup_gui_log_timestamp.ps1"

::powershell net use Z: "\\nas-pirenea.irap.omp.eu\PIRENEA_DATA"
:: Appelle PowerShell avec le bon script, sans fenêtre bloquante
if exist "Z:\PIRENEA_DATA" (
 echo [INFO] NAS mounted
 powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%~dp0backup_gui_log_timestamp.ps1"
 echo [OK] Backup successful. Press a key to Exit.
) else (
 echo [ERROR] Backup failed. NAS NOT mounted.
 pause > nul
)

echo.
echo [OK] Backup successful. Press a key to Exit.
:: pause >nul