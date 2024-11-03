@echo off
echo Enter the number of seconds before shutdown:
set /p time=
shutdown -s -t %time%
echo Your computer will shutdown in %time% seconds...