@echo off
set /p filename=Enter the filename to edit by notepad: 
if not defined filename (
    echo You must enter a filename.
    pause
    exit /b
)
notepad %filename%
if %ERRORLEVEL% == 0 (
    echo notepad has been closed successfully.
) else (
    echo There was an error running notepad.
)
pause