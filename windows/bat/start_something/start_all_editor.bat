@echo off
chcp 65001 >nul
color 0A
mode 80,25
title Open with Software

:main
cls
echo.
echo Choose the software to open a file:
echo.
echo [1] Excel
echo [2] Notepad
echo [3] PowerPoint
echo [4] Vim
echo [5] Visual Studio Code
echo [6] Word
echo [7] Exit
echo.
set /p choice=Enter your choice (1-7):
if "%choice%"=="" goto main
if "%choice%"=="1" goto excel
if "%choice%"=="2" goto notepad
if "%choice%"=="3" goto powerpoint
if "%choice%"=="4" goto vim
if "%choice%"=="5" goto vscode
if "%choice%"=="6" goto word
if "%choice%"=="7" exit /b

:excel
for /f "tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\EXCEL.EXE" /ve 2^>nul') do set excelPath=%%a
if exist "%excelPath%" (
    set /p filename=Enter the filename to edit by Excel: 
    if "%filename%"=="" (
        echo You must enter a filename.
        pause
        goto main
    )
    "%excelPath%" "%filename%"
    if %ERRORLEVEL% == 0 (
        echo Excel has been opened successfully.
    ) else (
        echo There was an error running Excel.
    )
) else (
    echo 没找到Excel，请检查是否已安装Excel。
)
pause
goto main

:notepad
set notepadPath=%SystemRoot%\system32\notepad.exe
if exist "%notepadPath%" (
    set /p filename=Enter the filename to edit by Notepad: 
    if not defined filename (
        echo You must enter a filename.
        pause
        goto main
    )
    %notepadPath% "%filename%"
    if %ERRORLEVEL% == 0 (
        echo Notepad has been closed successfully.
    ) else (
        echo There was an error running Notepad.
    )
) else (
    echo 没找到记事本，请检查是否已安装记事本。
)
pause
goto main

:powerpoint
for /f "tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\POWERPNT.EXE" /ve 2^>nul') do set powerpointPath=%%a
if exist "%powerpointPath%" (
    set /p filename=Enter the filename to edit by PowerPoint: 
    if "%filename%"=="" (
        echo You must enter a filename.
        pause
        goto main
    )
    "%powerpointPath%" "%filename%"
    if %ERRORLEVEL% == 0 (
        echo PowerPoint has been opened successfully.
    ) else (
        echo There was an error running PowerPoint.
    )
) else (
    echo 没找到PowerPoint，请检查是否已安装PowerPoint。
)
pause
goto main

:vim
set vimPath=%ProgramFiles%\Vim\vim80\vim.exe
if exist "%vimPath%" (
    set /p filename=Enter the filename to edit by Vim: 
    if not defined filename (
        echo You must enter a filename.
        pause
        goto main
    )
    %vimPath% "%filename%"
    if %ERRORLEVEL% == 0 (
        echo Vim has been closed successfully.
    ) else (
        echo There was an error running Vim.
    )
) else (
    echo 没找到Vim，请检查是否已安装Vim。
)
pause
goto main

:vscode
set vscodePath=%ProgramFiles%\Microsoft VS Code\Code.exe
if exist "%vscodePath%" (
    set /p filename=Enter the filename to edit by Visual Studio Code: 
    if not defined filename (
        echo You must enter a filename.
        pause
        goto main
    )
    "%vscodePath%" "%filename%"
    if %ERRORLEVEL% == 0 (
        echo Visual Studio Code has been closed successfully.
    ) else (
        echo There was an error running Visual Studio Code.
    )
) else (
    echo 没找到Visual Studio Code，请检查是否已安装Visual Studio Code。
)
pause
goto main

:word
for /f "tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WINWORD.EXE" /ve 2^>nul') do set wordPath=%%a
if exist "%wordPath%" (
    set /p filename=Enter the filename to edit by Word: 
    if "%filename%"=="" (
        echo You must enter a filename.
        pause
        goto main
    )
    "%wordPath%" "%filename%"
    if %ERRORLEVEL% == 0 (
        echo Word has been opened successfully.
    ) else (
        echo There was an error running Word.
    )
) else (
    echo 没找到Word，请检查是否已安装Word。
)
pause
goto main