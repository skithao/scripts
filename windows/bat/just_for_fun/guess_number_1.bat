@echo off
set /a number=%RANDOM% * 100 / 32768 + 1
set /p guess=Guess a number between 1 and 100: 
if %guess% EQU %number% (
    echo Correct!
) else (
    echo Incorrect! The number was %number%.
)
pause