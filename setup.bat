@echo off
setlocal

set "TEMP_DIR=%TEMP%\maxstart_temp"
set "MAXFILE_URL=https://github.com/vladgohn/MaxStartDef/raw/main/maxstart.max"
set "MAXFILE_NAME=maxstart.max"
set "COUNT=0"

echo [1/4] 🌟 Creating temp folder...
mkdir "%TEMP_DIR%" >nul 2>&1

echo [2/4] ⬇️ Downloading %MAXFILE_NAME% from repo...
powershell -Command "Invoke-WebRequest -Uri '%MAXFILE_URL%' -OutFile '%TEMP_DIR%\%MAXFILE_NAME%'"
if not exist "%TEMP_DIR%\%MAXFILE_NAME%" (
    echo ❌ ERROR: Download failed. Exiting.
    rmdir /s /q "%TEMP_DIR%"
    pause
    exit /b 1
)

echo [3/4] 🔍 Searching for installed 3ds Max versions...
for /d %%V in ("%LOCALAPPDATA%\Autodesk\3dsMax\*") do (
    for /d %%E in ("%%~fV\*\ENU\scenes") do (
        echo    ➜ Copying to: %%~fE
        copy /Y "%TEMP_DIR%\%MAXFILE_NAME%" "%%~fE\" >nul
        set /a COUNT+=1
    )
)

if %COUNT% EQU 0 (
    echo ⚠️  No 3ds Max versions found under %LOCALAPPDATA%\Autodesk\3dsMax\
) else (
    echo ✅ Successfully copied to %COUNT% version(s) of 3ds Max.
)

echo [4/4] 🧹 Cleaning up temp files...
rmdir /s /q "%TEMP_DIR%"

echo.
echo 🎉 Done! You can start 3ds Max to see your new default scene.
echo.
pause

endlocal
