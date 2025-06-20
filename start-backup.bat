@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: Titre de la fenêtre
title Backup is running...

:: Couleur et message d'accueil
color 0A
echo [INFO] Start backup script...

:: Appelle PowerShell avec le bon script, sans fenêtre bloquante
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%~dp0backup_gui_log.ps1"

echo.
echo [OK] Backup successful. Press a key to Exit.
:: pause >nul
