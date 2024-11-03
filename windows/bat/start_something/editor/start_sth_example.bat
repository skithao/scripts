@echo off
set /p filename=Enter the filename to edit by **sth**: 
if not defined filename (
    echo You must enter a filename.
    pause
    exit /b
)
**sth** %filename%
if %ERRORLEVEL% == 0 (
    echo **sth** has been closed successfully.
) else (
    echo There was an error running **sth**.
)
pause