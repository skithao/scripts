@echo off
set /p filename=Enter the filename to edit by Vim: 
if not defined filename (
    echo You must enter a filename.
    pause
    exit /b
)
vim %filename%
if %ERRORLEVEL% == 0 (
    echo Vim has been closed successfully.
) else (
    echo There was an error running Vim.
)
pause