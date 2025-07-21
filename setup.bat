@echo off
setlocal

REM ── CONFIGURATION ──────────────────────────────────────────────────────────
set "TEMP_DIR=%TEMP%\maxstart_temp"
set "MAXFILE_URL=https://github.com/vladgohn/MaxStartDef/raw/main/maxstart.max"
set "MAXFILE_NAME=maxstart.max"

REM ── STEP 1: Create temp folder 🌟
echo [1/5] Creating temp folder...
mkdir "%TEMP_DIR%" 2>nul

REM ── STEP 2: Download maxstart.max
echo [2/5] Downloading %MAXFILE_NAME% from repo...
powershell -Command "Invoke-WebRequest -Uri '%MAXFILE_URL%' -OutFile '%TEMP_DIR%\%MAXFILE_NAME%'"
if not exist "%TEMP_DIR%\%MAXFILE_NAME%" (
    echo ❌ ERROR: Download failed. Exiting.
    rmdir /s /q "%TEMP_DIR%"
    exit /b 1
)

REM ── STEP 3: Locate and copy to each 3ds Max version
echo [3/5] Searching for installed 3ds Max versions...
set "COUNT=0"
for /d %%V in ("%LOCALAPPDATA%\Autodesk\3dsMax\*") do (
    for /d %%E in ("%%~fV\*\ENU\scenes") do (
        echo ➤ Copying to %%~fE
        copy /Y "%TEMP_DIR%\%MAXFILE_NAME%" "%%~fE\" >nul
        set /a COUNT+=1
    )
)

if %COUNT% EQU 0 (
    echo ⚠️ WARNING: No 3ds Max versions found under %LOCALAPPDATA%\Autodesk\3dsMax%
) else (
    echo ✅ Successfully copied to %COUNT% version(s).
)

REM ── STEP 4: Cleanup temp folder
echo [4/5] Cleaning up...
rmdir /s /q "%TEMP_DIR%"

REM ── STEP 5: Final confirmation ✔️
echo [5/5] All done! Press any key to exit.
pause >nul

endlocal
