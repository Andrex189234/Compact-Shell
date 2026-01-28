@echo off

setlocal EnableDelayedExpansion
title Compact Shell
color 0A
break off

rem ============================
rem First launch
rem ============================
set FIRST_RUN=1

rem ============================
rem CompactShell login system
rem ============================

set USERS_FILE=C:\Users\%%USERNAME%%\Documents\Starting\users.cfg
set LOGGED_IN=0
set ATTEMPTS=0
set MAX_ATTEMPTS=3

rem If the users file doesn't exist, create it with default user
if not exist "%USERS_FILE%" (
    echo guest=guest>%USERS_FILE%
)

:LOGIN
cls
echo ============================
echo     COMPACT SHELL LOGIN
echo ============================
echo.

set /p USERNAME=Username: 
set /p PASSWORD=Password: 

set FOUND=0

for /f "tokens=1,2 delims==" %%A in (%USERS_FILE%) do (
    if /i "%%A"=="!USERNAME!" if "%%B"=="!PASSWORD!" set FOUND=1
)

if "!FOUND!"=="1" (
    set LOGGED_IN=1
    echo Access granted. Welcome, !USERNAME!
    pause
    cls
    goto MENU
) else (
    set /a ATTEMPTS+=1
    echo Incorrect username or password! Attempt !ATTEMPTS! of !MAX_ATTEMPTS!
    if !ATTEMPTS! geq !MAX_ATTEMPTS! (
        echo Too many attempts. Shell will close.
        exit
    )
    pause
    goto LOGIN
)

rem ============================
rem Load aliases from shell.cfg
rem ============================
if exist shell.cfg (
    for /f "usebackq tokens=1,* delims==" %%A in ("shell.cfg") do (
        if /i "%%A"=="alias" (
            set %%B
        )
    )
)

rem ============================
rem Command history
rem ============================
set HISTORY_FILE=%TEMP%\shell_history.txt
if not exist "%HISTORY_FILE%" echo. > "%HISTORY_FILE%"

rem ============================
rem Plugin system
rem ============================
if exist commands.d (
    for %%F in (commands.d\*.bat) do (
        set CMD_%%~nF=%%F
    )
)

:MENU
rem Banner only on first launch
if "!FIRST_RUN!"=="1" (
    cd C:/
    echo ============================
    echo      COMPACT SHELL
    echo ============================
    echo Made by andrex
    echo.
    set FIRST_RUN=0
)

rem Dynamic prompt
set USER=%USERNAME%
set HOST=%COMPUTERNAME%
set /p input=[%USER%@%HOST% %CD%]$ 

rem ============================
rem Save command to history
echo %input% >> "%HISTORY_FILE%"

rem ============================
rem Parse command and parameters
rem ============================
set cmd=
set param=
for /f "tokens=1,2*" %%A in ("%input%") do (
    set cmd=%%A
    set param=%%B
    set param2=%%C
)

rem ============================
rem Check aliases
rem ============================
for /f "tokens=1,* delims==" %%A in ('set') do (
    if /i "%%A"=="!cmd!" (
        set cmd=!%%A!
    )
)

rem ============================
rem Base commands
rem ============================
if /i "!cmd!"=="exit" goto EXIT
if /i "!cmd!"=="help" goto HELP
if /i "!cmd!"=="clear" goto CLEAR
if /i "!cmd!"=="cls" goto CLEAR
if /i "!cmd!"=="pwd" goto PWD
if /i "!cmd!"=="cd" goto CD
if /i "!cmd!"=="ls" goto DIR
if /i "!cmd!"=="dir" goto DIR
if /i "!cmd!"=="whoami" goto WHOAMI
if /i "!cmd!"=="date" goto DATE
if /i "!cmd!"=="time" goto TIME
if /i "!cmd!"=="echo" goto ECHO
if /i "!cmd!"=="pause" goto PAUSE
if /i "!cmd!"=="sleep" goto SLEEP
if /i "!cmd!"=="pkg" goto PKG

rem ============================
rem Network
rem ============================
if /i "!cmd!"=="ip" goto IP
if /i "!cmd!"=="ping" goto PING
if /i "!cmd!"=="netstat" goto NETSTAT
if /i "!cmd!"=="wifi" goto WIFI

rem ============================
rem Power
rem ============================
if /i "!cmd!"=="reboot" goto REBOOT
if /i "!cmd!"=="shutdown" goto SHUTDOWN
if /i "!cmd!"=="cancel" goto CANCEL
if /i "!cmd!"=="lock" goto LOCK
if /i "!cmd!"=="logoff" goto LOGOFF

rem ============================
rem Applications
rem ============================
if /i "!cmd!"=="cmd" goto CMD
if /i "!cmd!"=="steam" goto STEAM
if /i "!cmd!"=="epic" goto EPIC
if /i "!cmd!"=="firefox" goto FIREFOX
if /i "!cmd!"=="browser" goto FIREFOX
if /i "!cmd!"=="vm" goto VM
if /i "!cmd!"=="calc" goto CALC
if /i "!cmd!"=="taskmgr" goto TASKMGR
if /i "!cmd!"=="explorer" goto EXPLORER
if /i "!cmd!"=="notepad" goto NOTEPAD

rem ============================
rem Advanced exec
rem ============================
if /i "!cmd!"=="exec" goto EXEC
if /i "!cmd!"=="run" goto EXEC

rem ============================
rem Plugins
rem ============================
for /f "tokens=1,* delims==" %%P in ('set CMD_ 2^>nul') do (
    if /i "!cmd!"=="%%P:~4%%" call "%%Q"
)

echo.
echo Command not recognized.
goto MENU

rem ============================
rem HELP
rem ============================
:HELP
echo ============================
echo        COMPACT SHELL
echo             HELP
echo ============================
echo.
echo --- GENERAL ---
echo  help                 Show this message
echo  exit                 Close the shell
echo  clear / cls          Clear the screen
echo.
echo --- SYSTEM ---
echo  pwd                  Current directory
echo  cd <path>             Change directory
echo  dir / ls             List files
echo  whoami               Current user
echo  date                 Date
echo  time                 Time
echo.
echo --- POWER ---
echo  reboot [sec]          Restart (default 5s)
echo  shutdown [sec]        Shutdown (default 5s)
echo  cancel               Cancel shutdown
echo  lock                 Lock PC
echo  logoff               Log off user
echo.
echo --- APPLICATIONS ---
echo  pkg install <package>     Install package with winget
echo  pkg uninstall <package>   Uninstall package with winget
echo  cmd [-e]             Command prompt
echo  steam [-e]           Launch Steam
echo  epic [-e]            Launch Epic Games
echo  firefox [-e]         Launch Firefox
echo  browser [-e]         Alias for firefox
echo  vm [-e]              Launch VMware
echo  calc [-e]            Calculator
echo  taskmgr [-e]         Task Manager
echo  explorer [-e]        File Explorer
echo  notepad [-e]         Notepad
echo.
echo --- NETWORK ---
echo  ip                   Show IP
echo  ping <host>          Ping host
echo  netstat              Network connections
echo  wifi                 Wi-Fi networks
echo.
echo --- ADVANCED EXEC ---
echo  exec file             Execute/open file
echo  exec file -e          Execute and close shell
echo  exec -w file          Wait for close
echo  exec -a file args     Pass arguments
echo  exec *.exe            Wildcard
echo  run file              Alias for exec
echo.
goto MENU

rem ============================
rem Base / system commands
rem ============================
:CLEAR
cls
goto MENU

:PWD
cd
goto MENU

:CD
rem Build full path with multiple parameters
set TARGET=
if "!param!"=="" (
    echo Usage: cd path
    goto MENU
) else (
    set TARGET=!param!
    if not "!param2!"=="" set TARGET=!TARGET! !param2!
)

rem Remove unnecessary quotes
set TARGET=!TARGET:"=!

rem Change directory
cd /d "!TARGET!" 2>nul
if errorlevel 1 (
    echo Path not found: !TARGET!
)
goto MENU

:DIR
dir
goto MENU

:WHOAMI
whoami
goto MENU

:DATE
date /t
goto MENU

:TIME
time /t
goto MENU

:ECHO
echo !input:~5!
goto MENU

:PAUSE
pause
goto MENU

:SLEEP
if "!param!"=="" (
    timeout /t 1 >nul
) else (
    timeout /t !param! >nul
)
goto MENU

rem ============================
rem Network
rem ============================
:IP
ipconfig
goto MENU

:PING
if "!param!"=="" (
    echo Usage: ping host
) else (
    ping !param!
)
goto MENU

:NETSTAT
netstat -an
goto MENU

:WIFI
netsh wlan show networks
goto MENU

rem ============================
rem Power
rem ============================
:REBOOT
if "!param!"=="" (set delay=5) else (set delay=!param!)
echo Restarting in !delay! seconds...
shutdown /r /t !delay!
exit

:SHUTDOWN
if "!param!"=="" (set delay=5) else (set delay=!param!)
echo Shutting down in !delay! seconds...
shutdown /s /t !delay!
exit

:CANCEL
shutdown /a
goto MENU

:LOCK
rundll32.exe user32.dll,LockWorkStation
goto MENU

:LOGOFF
shutdown /l
exit

rem ============================
rem Applications
rem ============================

:PKG
rem ============================
rem pkg command (isolated vars)
rem ============================

where winget >nul 2>&1
if errorlevel 1 (
    echo winget not found.
    goto MENU
)

rem take everything after "pkg "
set PKG_CMD=%input%
set PKG_CMD=%PKG_CMD:pkg =%

rem LOCAL variables
set PKG_ACTION=
set PKG_TARGET=

for /f "tokens=1*" %%A in ("%PKG_CMD%") do (
    set PKG_ACTION=%%A
    set PKG_TARGET=%%B
)

if "!PKG_ACTION!"=="" (
    echo Usage:
    echo   pkg install name
    echo   pkg uninstall name
    echo   pkg search name
    echo   pkg upgrade name
    echo   pkg upgrade all
    goto MENU
)

rem ----------------------------
rem INSTALL
rem ----------------------------
if /i "!PKG_ACTION!"=="install" (
    if "!PKG_TARGET!"=="" (
        echo You must specify the package name.
        goto MENU
    )
    echo Installing: !PKG_TARGET!
    winget install !PKG_TARGET! --accept-source-agreements --accept-package-agreements
    goto MENU
)

rem ----------------------------
rem UNINSTALL
rem ----------------------------
if /i "!PKG_ACTION!"=="uninstall" (
    if "!PKG_TARGET!"=="" (
        echo You must specify the package name.
        goto MENU
    )
    echo Uninstalling: !PKG_TARGET!
    winget uninstall !PKG_TARGET! --accept-source-agreements --accept-package-agreements
    color 0A
    goto MENU
)

rem ----------------------------
rem SEARCH
rem ----------------------------
if /i "!PKG_ACTION!"=="search" (
    if "!PKG_TARGET!"=="" (
        echo You must specify the search term.
        goto MENU
    )
    echo Searching: !PKG_TARGET!
    winget search !PKG_TARGET!
    color 0A
    goto MENU
)

rem ----------------------------
rem UPGRADE
rem ----------------------------
if /i "!PKG_ACTION!"=="upgrade" (
    if /i "!PKG_TARGET!"=="all" (
        echo Upgrading all packages...
        winget upgrade --all --accept-source-agreements --accept-package-agreements
        color 0A
        goto MENU
    )

    if "!PKG_TARGET!"=="" (
        echo You must specify a package or 'all'.
        goto MENU
    )

    echo Upgrading package: !PKG_TARGET!
    winget upgrade !PKG_TARGET! --accept-source-agreements --accept-package-agreements
    color 0A
    goto MENU
)

echo Invalid action.
goto MENU

:CMD
start cmd
call :CHECK_EXIT

:STEAM
start "" "C:\Program Files (x86)\Steam\Steam.exe"
call :CHECK_EXIT

:EPIC
start "" "C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"
call :CHECK_EXIT

:FIREFOX
start "" "C:\Program Files\Mozilla Firefox\firefox.exe"
call :CHECK_EXIT

:VM
start "" "C:\Program Files (x86)\VMware\VMware Workstation\vmware.exe"
call :CHECK_EXIT

:CALC
start calc
call :CHECK_EXIT

:TASKMGR
start taskmgr
call :CHECK_EXIT

:EXPLORER
start explorer
call :CHECK_EXIT

:NOTEPAD
start notepad
call :CHECK_EXIT

rem ============================
rem Advanced EXEC
rem ============================
:EXEC
rem ============================
rem initialize flags
rem ============================
set wait=0
set exit_after=0
set args=

rem save original input
set CMDLINE=%input%

rem ============================
rem detect -e and -w flags and remove them
rem ============================
echo %CMDLINE% | findstr /i " -e " >nul && set exit_after=1
echo %CMDLINE% | findstr /i " -w " >nul && set wait=1

rem remove all flags from line
set CMDLINE=%CMDLINE:exec =%
set CMDLINE=%CMDLINE:run =%
set CMDLINE=%CMDLINE:-e=%
set CMDLINE=%CMDLINE:-w=%

rem ============================
rem Extract file and arguments
rem ============================
for /f "tokens=1*" %%A in ("%CMDLINE%") do (
    set file=%%A
    set args=%%B
)

rem remove extra quotes
set file=!file:"=!

if not exist "!file!" (
    echo File not found: !file!
    goto MENU
)

echo Launching: "!file!" !args!

rem ============================
rem Safe execution
rem ============================
if "!wait!"=="1" (
    start /wait "" "!file!" !args!
) else (
    start "" "!file!" !args!
)

if "!exit_after!"=="1" exit
goto MENU

rem ============================
rem Check exit flag
rem ============================
:CHECK_EXIT
if /i "!param!"=="-e" (
    exit
) else (
    goto MENU
)

:EXIT
exit
