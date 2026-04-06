@echo off
setlocal EnableExtensions EnableDelayedExpansion
title EasyEDA2KiCad - LCSC Import

echo.
echo ===============================
echo   EasyEDA2KiCad Batch Import
echo ===============================
echo.

where easyeda2kicad >nul 2>nul
if errorlevel 1 (
    echo ERROR: easyeda2kicad was not found in PATH.
    echo.
    echo Install it first, for example:
    echo   pip install easyeda2kicad
    echo.
    echo Then reopen Command Prompt and run this file again.
    pause
    exit /b 1
)

set "LCSC_ID="
set /p LCSC_ID=Enter LCSC ID (example: C2040): 

if "%LCSC_ID%"=="" (
    echo ERROR: LCSC ID cannot be empty.
    pause
    exit /b 1
)

set "PROJECTDIR="
set /p PROJECTDIR=Enter project directory (example: C:\KiCad\MyProject): 

if "%PROJECTDIR%"=="" (
    echo ERROR: Project directory cannot be empty.
    pause
    exit /b 1
)

if not exist "%PROJECTDIR%" (
    echo ERROR: Project directory does not exist.
    pause
    exit /b 1
)

set "LIBNAME="
set /p LIBNAME=Enter library name (example: MyLib): 

if "%LIBNAME%"=="" (
    echo ERROR: Library name cannot be empty.
    pause
    exit /b 1
)

set "LIBDIR=%PROJECTDIR%\libs"
if not exist "%LIBDIR%" (
    mkdir "%LIBDIR%" 2>nul
)

set "OUTDIR=%LIBDIR%\%LIBNAME%"

echo.
echo Output will be created in:
echo   %OUTDIR%.kicad_sym
echo   %OUTDIR%.pretty
echo   %OUTDIR%.3dshapes
echo.

echo Running:
echo   easyeda2kicad --full --lcsc_id=%LCSC_ID% --output="%OUTDIR%"
echo.

easyeda2kicad --full --lcsc_id=%LCSC_ID% --output="%OUTDIR%"
set "ERR=%ERRORLEVEL%"

echo.
if "%ERR%"=="0" (
    echo Done.
    echo.
    echo Created:
    echo   %OUTDIR%.kicad_sym
    echo   %OUTDIR%.pretty
    echo   %OUTDIR%.3dshapes
) else (
    echo Failed with exit code %ERR%.
)

echo.
pause
exit /b %ERR%
