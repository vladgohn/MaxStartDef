@echo off
setlocal EnableDelayedExpansion

set "MAXFILE_URL=https://github.com/vladgohn/MaxStartDef/raw/main/maxstart.max"
set "MAXFILE_NAME=maxstart.max"
set "TEMP_DIR=%TEMP%\maxstart_temp"
set "DOWNLOADED=0"

:MENU
cls
echo ----------------------------------------
echo     MaxStartDef Control Menu
echo ----------------------------------------
echo 1. Download maxstart.max
echo 2. Show detected 3ds Max scenes folders
echo 3. Copy maxstart.max to detected Max scenes
echo 4. Exit
echo ----------------------------------------
set /p CHOICE=Choose an option [1-4]: 

if "%CHOICE%"=="1" goto DOWNLOAD
if "%CHOICE%"=="2" goto SHOW_PATHS
if "%CHOICE%"=="3" goto COPY_FILE
if "%CHOICE%"=="4" goto END
goto MENU

:DOWNLOAD
echo Downloading maxstart.max...
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%" >nul 2>&1
powershell -Command "Invoke-WebRequest -Uri '%MAXFILE_URL%' -OutFile '%TEMP_DIR%\%MAXFILE_NAME%'" 2>nul

if exist "%TEMP_DIR%\%MAXFILE_NAME%" (
    echo Downloaded to: %TEMP_DIR%\%MAXFILE_NAME%
    set DOWNLOADED=1
) else (
    echo ERROR: Download failed.
)
pause >nul
goto MENU

:SHOW_PATHS
echo.
echo Scanning for 3ds Max scenes folders...
set FOUND=0
for /d %%M in ("C:\Program Files\Autodesk\3ds Max *") do (
    set "SCENE_DIR=%%M\scenes"
    if exist "!SCENE_DIR!" (
        echo [FOUND] !SCENE_DIR!
        set /a FOUND+=1
    ) else (
        echo [NOT FOUND] !SCENE_DIR!
    )
)
if !FOUND! EQU 0 echo No Max installations with scenes folder found.
pause >nul
goto MENU

:COPY_FILE
if !DOWNLOADED! EQU 0 (
    echo You need to download maxstart.max first! Choose option 1 in the menu.
    pause >nul
    goto MENU
)

echo Copying maxstart.max to all detected Max scenes folders...
set COPIED=0
for /d %%M in ("C:\Program Files\Autodesk\3ds Max *") do (
    set "SCENE_DIR=%%M\scenes"
    if exist "!SCENE_DIR!" (
        copy /Y "%TEMP_DIR%\%MAXFILE_NAME%" "!SCENE_DIR!\" >nul
        if exist "!SCENE_DIR!\%MAXFILE_NAME%" (
            echo Copied to: !SCENE_DIR!
            set /a COPIED=!COPIED!+1
        ) else (
            echo Failed to copy to: !SCENE_DIR!
        )
    )
)

if !COPIED! EQU 0 (
    echo No files copied. Either no scenes folders found or copy failed.
) else (
    echo Successfully copied to !COPIED! Max installation(s).
)
pause >nul
goto MENU

:END
echo Exiting.
pause >nul
endlocal
exit /b
