@echo off
set /p filename=Enter the filename to edit by vscode: 
if not defined filename (
    echo You must enter a filename.
    pause
    exit /b
)
D:\0-sunsky-DIY\Downloads\APPs\VScode\body\Code.exe %filename%
if %ERRORLEVEL% == 0 (
    echo vscode has been closed successfully.
) else (
    echo There was an error running vscode.
)
pause