@echo off

setlocal EnableDelayedExpansion
title Compact Shell
color 0A
break off

rem ============================
rem Primo avvio
rem ============================
set FIRST_RUN=1


rem ============================
rem Sistema di login CompactShell
rem ============================

set USERS_FILE=C:\Users\%%USERNAME%%\Desktop\Starting\users.cfg
set LOGGED_IN=0
set ATTEMPTS=0
set MAX_ATTEMPTS=3

rem Se il file utenti non esiste, crealo con utente predefinito
if not exist "%USERS_FILE%" (
    echo guest=guest>%USERS_FILE%
)

:LOGIN
cls
echo ============================
echo     LOGIN COMPACT SHELL
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
    echo Accesso consentito. Benvenuto, !USERNAME!
    pause
    cls
    goto MENU
) else (
    set /a ATTEMPTS+=1
    echo Username o password errati! Tentativo !ATTEMPTS! di !MAX_ATTEMPTS!
    if !ATTEMPTS! geq !MAX_ATTEMPTS! (
        echo Troppi tentativi. La shell si chiude.
        exit
    )
    pause
    goto LOGIN
)


rem ============================
rem Caricamento alias da shell.cfg
rem ============================
if exist shell.cfg (
    for /f "usebackq tokens=1,* delims==" %%A in ("shell.cfg") do (
        if /i "%%A"=="alias" (
            set %%B
        )
    )
)

rem ============================
rem Storico comandi
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
rem Banner solo al primo avvio
if "!FIRST_RUN!"=="1" (
    cd C:/
    echo ============================
    echo      COMPACT SHELL
    echo ============================
    echo Sviluppato da andrex
    echo.
    set FIRST_RUN=0
)

rem Prompt dinamico
set USER=%USERNAME%
set HOST=%COMPUTERNAME%
set /p input=[%USER%@%HOST% %CD%]$ 

rem ============================
rem Salva comando nella history
echo %input% >> "%HISTORY_FILE%"

rem ============================
rem Parsing comando e parametri
rem ============================
set cmd=
set param=
for /f "tokens=1,2*" %%A in ("%input%") do (
    set cmd=%%A
    set param=%%B
    set param2=%%C
)

rem ============================
rem Controllo alias
rem ============================
for /f "tokens=1,* delims==" %%A in ('set') do (
    if /i "%%A"=="!cmd!" (
        set cmd=!%%A!
    )
)

rem ============================
rem Comandi base
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
rem Rete
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
rem Applicazioni
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
rem Exec avanzato
rem ============================
if /i "!cmd!"=="exec" goto EXEC
if /i "!cmd!"=="run" goto EXEC

rem ============================
rem Plugin
rem ============================
for /f "tokens=1,* delims==" %%P in ('set CMD_ 2^>nul') do (
    if /i "!cmd!"=="%%P:~4%%" call "%%Q"
)

echo.
echo Comando non riconosciuto.
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
echo --- GENERALI ---
echo  help                 Mostra questo messaggio
echo  exit                 Chiude la shell
echo  clear / cls          Pulisce lo schermo
echo.
echo --- SISTEMA ---
echo  pwd                  Directory corrente
echo  cd <path>             Cambia directory
echo  dir / ls             Lista file
echo  whoami               Utente corrente
echo  date                 Data
echo  time                 Ora
echo.
echo --- POWER ---
echo  reboot [sec]          Riavvia (default 5s)
echo  shutdown [sec]        Spegne (default 5s)
echo  cancel               Annulla spegnimento
echo  lock                 Blocca il PC
echo  logoff               Disconnetti utente
echo.
echo --- APPLICAZIONI ---
echo  pkg install <pacchetto>     Installa pacchetto con winget
echo  pkg uninstall <pacchetto>   Disinstalla pacchetto con winget
echo  cmd [-e]             Prompt dei comandi
echo  steam [-e]           Avvia Steam
echo  epic [-e]            Avvia Epic Games
echo  firefox [-e]         Avvia Firefox
echo  browser [-e]         Alias di firefox
echo  vm [-e]              Avvia VMware
echo  calc [-e]            Calcolatrice
echo  taskmgr [-e]         Task Manager
echo  explorer [-e]        Esplora File
echo  notepad [-e]         Blocco Note
echo.
echo --- RETE ---
echo  ip                   Mostra IP
echo  ping <host>          Ping host
echo  netstat              Connessioni di rete
echo  wifi                 Reti Wi-Fi
echo.
echo --- EXEC AVANZATO ---
echo  exec file             Esegue/apre file
echo  exec file -e          Esegue e chiude shell
echo  exec -w file          Attende chiusura
echo  exec -a file args     Passa argomenti
echo  exec *.exe            Wildcard
echo  run file              Alias di exec
echo.
goto MENU

rem ============================
rem Comandi base / sistema
rem ============================
:CLEAR
cls
goto MENU

:PWD
cd
goto MENU

:CD
rem Costruisce percorso completo con parametri multipli
set TARGET=
if "!param!"=="" (
    echo Uso: cd percorso
    goto MENU
) else (
    set TARGET=!param!
    if not "!param2!"=="" set TARGET=!TARGET! !param2!
)

rem Rimuove eventuali virgolette inutili
set TARGET=!TARGET:"=!

rem Cambia directory
cd /d "!TARGET!" 2>nul
if errorlevel 1 (
    echo Impossibile trovare il percorso specificato: !TARGET!
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
rem Rete
rem ============================
:IP
ipconfig
goto MENU

:PING
if "!param!"=="" (
    echo Uso: ping host
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
echo Riavvio tra !delay! secondi...
shutdown /r /t !delay!
exit

:SHUTDOWN
if "!param!"=="" (set delay=5) else (set delay=!param!)
echo Spegnimento tra !delay! secondi...
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
rem Applicazioni
rem ============================

:PKG
rem ============================
rem pkg command (isolated vars)
rem ============================

where winget >nul 2>&1
if errorlevel 1 (
    echo winget non trovato.
    goto MENU
)

rem prende tutto dopo "pkg "
set PKG_CMD=%input%
set PKG_CMD=%PKG_CMD:pkg =%

rem variabili LOCALI
set PKG_ACTION=
set PKG_TARGET=

for /f "tokens=1*" %%A in ("%PKG_CMD%") do (
    set PKG_ACTION=%%A
    set PKG_TARGET=%%B
)

if "!PKG_ACTION!"=="" (
    echo Uso:
    echo   pkg install nome
    echo   pkg uninstall nome
    echo   pkg search nome
    echo   pkg upgrade nome
    echo   pkg upgrade all
    goto MENU
)

rem ----------------------------
rem INSTALL
rem ----------------------------
if /i "!PKG_ACTION!"=="install" (
    if "!PKG_TARGET!"=="" (
        echo Devi specificare il nome del pacchetto.
        goto MENU
    )
    echo Installazione: !PKG_TARGET!
    winget install !PKG_TARGET! --accept-source-agreements --accept-package-agreements
    goto MENU
)

rem ----------------------------
rem UNINSTALL
rem ----------------------------
if /i "!PKG_ACTION!"=="uninstall" (
    if "!PKG_TARGET!"=="" (
        echo Devi specificare il nome del pacchetto.
        goto MENU
    )
    echo Disinstallazione: !PKG_TARGET!
    winget uninstall !PKG_TARGET! --accept-source-agreements --accept-package-agreements
    color 0A
    goto MENU
)

rem ----------------------------
rem SEARCH
rem ----------------------------
if /i "!PKG_ACTION!"=="search" (
    if "!PKG_TARGET!"=="" (
        echo Devi specificare il termine di ricerca.
        goto MENU
    )
    echo Ricerca: !PKG_TARGET!
    winget search !PKG_TARGET!
    color 0A
    goto MENU
)

rem ----------------------------
rem UPGRADE
rem ----------------------------
if /i "!PKG_ACTION!"=="upgrade" (
    if /i "!PKG_TARGET!"=="all" (
        echo Aggiornamento di tutti i pacchetti...
        winget upgrade --all --accept-source-agreements --accept-package-agreements
        color 0A
        goto MENU
    )

    if "!PKG_TARGET!"=="" (
        echo Devi specificare un pacchetto o 'all'.
        goto MENU
    )

    echo Aggiornamento pacchetto: !PKG_TARGET!
    winget upgrade !PKG_TARGET! --accept-source-agreements --accept-package-agreements
    color 0A
    goto MENU
)

echo Azione non valida.
goto MENU


echo Azione non valida.
echo Usa: install ^| uninstall ^| search
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
rem EXEC AVANZATO
rem ============================
:EXEC
rem ============================
rem inizializza flag
rem ============================
set wait=0
set exit_after=0
set args=

rem salva input originale
set CMDLINE=%input%

rem ============================
rem rileva flag -e e -w e rimuovili dalla linea
rem ============================
echo %CMDLINE% | findstr /i " -e " >nul && set exit_after=1
echo %CMDLINE% | findstr /i " -w " >nul && set wait=1

rem rimuovi tutti i flag dalla linea
set CMDLINE=%CMDLINE:exec =%
set CMDLINE=%CMDLINE:run =%
set CMDLINE=%CMDLINE:-e=%
set CMDLINE=%CMDLINE:-w=%

rem ============================
rem Estrai file e argomenti
rem ============================
for /f "tokens=1*" %%A in ("%CMDLINE%") do (
    set file=%%A
    set args=%%B
)

rem rimuove eventuali virgolette extra
set file=!file:"=!

if not exist "!file!" (
    echo File non trovato: !file!
    goto MENU
)

echo Avvio: "!file!" !args!

rem ============================
rem Esecuzione sicura
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
