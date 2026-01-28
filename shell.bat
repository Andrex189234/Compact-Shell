@echo off
echo Starting compact shell...

set /p cmd=Do you want to change settings? (yes/no):
if /i "%cmd%"=="yes" goto NON_START
if /i "%cmd%"=="no" goto START
if /i "%cmd%"=="y" goto NON_START
if /i "%cmd%"=="n" goto START

:START
set /p cmd=Select language (it/en):
if /i "%cmd%"=="it" goto ITALIAN
if /i "%cmd%"=="en" goto ENGLISH


:ITALIAN
cls
call "C:\Users\andre\Documents\Starting\CompactShell_it.bat"
goto :eof

:ENGLISH
cls
call "C:\Users\andre\Documents\Starting\CompactShell_en.bat"
goto :eof

:NON_START
explorer C:\Users\%USERNAME%\Documents\Starting
echo if you get an error create a directory on the Documents called "Starting" and move these file