@echo off
:: ============================================================================
:: Django Full Project Initializer (v2 - Corrected Layout)
::
:: This script will:
:: 1. Create a lab folder for a specific week.
:: 2. Change into that directory.
:: 3. Create a Python virtual environment ('myvenv').
:: 4. Install Django into the virtual environment.
:: 5. Create a new Django project using the 'startproject <name> .' pattern.
:: 6. Open a new, activated command prompt in the project's root directory.
:: ============================================================================

:: Sets the title of the command window
title Django Full Project Initializer

:main
:: Clears the screen for a clean start
cls
echo.
echo =======================================================
echo   Django Full Project Initializer (Corrected Layout)
echo =======================================================
echo.

:: --- STEP 1: Get Week Number & Create Lab Folder ---
set /p week_num="Enter the week number for the lab: "

:: Validation for week number
if "%week_num%"=="" (
    echo [ERROR] No week number entered. Please try again.
    echo. & pause & goto :main
)

set "lab_folder=%cd%\django-SSR-LabW%week_num%"

if exist "%lab_folder%" (
    echo [ERROR] The folder "django-SSR-LabW%week_num%" already exists in this directory!
    echo. & pause & goto :main
)

echo.
echo [1/5] Creating lab folder: "django-SSR-LabW%week_num%"
mkdir "%lab_folder%"
if not exist "%lab_folder%" (
    echo [FATAL ERROR] Could not create lab folder. Exiting.
    echo. & pause & exit
)

:: --- CHANGE INTO THE NEW DIRECTORY ---
:: This is the key change to simplify all subsequent paths.
cd /D "%lab_folder%"

:: --- STEP 2: Create Virtual Environment ---
echo [2/5] Creating virtual environment 'myvenv'... (This may take a moment)
:: We are now inside the lab folder, so we don't need the full path.
py -m venv myvenv >nul 2>nul

:: Verify that the virtual environment was created successfully
if not exist "myvenv\Scripts\activate.bat" (
    echo [FATAL ERROR] Failed to create virtual environment.
    echo Please ensure Python is installed and accessible via the 'py' command.
    cd ..
    rmdir /s /q "%lab_folder%"
    echo. & pause & exit
)

:: --- STEP 3: Install Django ---
echo [3/5] Installing Django into the virtual environment...
:: Execute pip from within the new venv to install Django.
myvenv\Scripts\pip.exe install django >nul

:: Verify Django was installed by checking for django-admin
if not exist "myvenv\Scripts\django-admin.exe" (
    echo [FATAL ERROR] Failed to install Django. Check your internet connection.
    cd ..
    rmdir /s /q "%lab_folder%"
    echo. & pause & exit
)

:: --- STEP 4: Get Project Name & Create Django Project ---
:get_project_name
echo.
set /p project_name="Enter your Django project name (e.g., config, core): "

if "%project_name%"=="" (
    echo [ERROR] Project name cannot be empty.
    goto :get_project_name
)

echo [4/5] Creating Django project '%project_name%' in the current directory...
:: This is the corrected command. Note the '.' at the end.
myvenv\Scripts\django-admin.exe startproject %project_name% . >nul

:: Verify the project was created by looking for manage.py in the CURRENT folder
if not exist "manage.py" (
    echo [FATAL ERROR] Failed to create Django project. The name '%project_name%' may be invalid.
    cd ..
    rmdir /s /q "%lab_folder%"
    echo. & pause & exit
)

:: --- STEP 5: Launch Activated Environment ---
echo [5/5] Launching new activated command prompt...
echo.
echo [SUCCESS] Your Django project is ready!
echo The new window will be inside "%lab_folder%"

:: Launch a NEW command prompt.
:: The starting directory is the current one (%cd%), where manage.py is.
:: The command to activate is now relative and simpler.
start "Django Lab - Week %week_num% (Project: %project_name%)" cmd /k "myvenv\Scripts\activate.bat"

:: The original script can now exit
exit