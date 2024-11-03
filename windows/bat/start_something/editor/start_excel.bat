@echo off
set /p filename=Enter the filename to edit by Excel: 
if "%filename%"=="" (
    echo You must enter a filename.
    pause
    exit /b
)
"C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" "%filename%"
if %ERRORLEVEL% == 0 (
    echo Excel has been opened successfully.
) else (
    echo There was an error running Excel.
)
pause