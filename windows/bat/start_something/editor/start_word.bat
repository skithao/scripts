@echo off
set /p filename=Enter the filename to edit by Word: 
if "%filename%"=="" (
    echo You must enter a filename.
    pause
    exit /b
)
"C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" "%filename%"
if %ERRORLEVEL% == 0 (
    echo Word has been opened successfully.
) else (
    echo There was an error running Word.
)
pause