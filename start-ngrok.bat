@echo off
echo ========================================
echo   Demarrage de NGROK pour Jenkins
echo ========================================
echo.
echo Assurez-vous que Jenkins est demarre sur le port 8080
echo.
pause
echo.
echo Demarrage de NGROK...
echo.
ngrok http 8080
pause

