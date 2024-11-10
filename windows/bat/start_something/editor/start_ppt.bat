@echo off
set /p filename=Enter the filename to edit by Powerpoint: 
if "%filename%"=="" (
    echo You must enter a filename.
    pause
    exit /b
)
"C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE" "%filename%"
if %ERRORLEVEL% == 0 (
    echo Powerpoint has been opened successfully.
) else (
    echo There was an error running Powerpoint.
)
pause