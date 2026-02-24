@echo off
echo Welcome to the setup of the Compact Shell!
set /p cmd=Select your language (it/en):
if /i "%cmd%"=="it" goto ITALIAN
if /i "%cmd%"=="en" goto ENGLISH

:ITALIAN
echo Hai selezionato la lingua italiana.
echo.
echo Il programma clonera ora il repository GitHub del Compact Shell. Attendere prego...
git clone https://github.com/Andrex189234/Compact-Shell.git C:\Users\%USERNAME%\Documents\Starting
cd C:\Users\%USERNAME%\Documents\Starting
echo.
echo Il programma creerà ora un collegamento sul desktop. Attendere prego...
copy "C:\Users\%USERNAME%\Documents\Starting\Italian.bat" "%USERPROFILE%\Desktop\Compact Shell - Italian.bat"
echo.
echo L'utente predefinito e "guest" e la password predefinita e "guest". Puoi modificare queste credenziali nel file "users.cfg" che si trova nella stessa directory di questo script di installazione.
echo Per creare un nuovo utente, aggiungi semplicemente una nuova riga nel file "users.cfg" con il formato "username=password". Ad esempio, per creare un utente chiamato "admin" con password "admin123", dovresti aggiungere la riga "admin=admin123" al file.
notepad "users.cfg"
set /p launch=Do you want to launch the Compact Shell? (y/n):
if /i "%launch%"=="y" start "" "C:\Users\%USERNAME%\Documents\Starting\Italian.bat"
if /i "%launch%"=="n" exit

:ENGLISH
echo You selected English.
echo The program will now clone the Compact Shell GitHub repository. Please wait...
git clone https://github.com/Andrex189234/Compact-Shell.git C:\Users\%USERNAME%\Documents\Starting
cd C:\Users\%USERNAME%\Documents\Starting
echo The program will now create a shortcut on your desktop. Please wait...
copy "C:\Users\%USERNAME%\Documents\Starting\English.bat" "%USERPROFILE%\Desktop\Compact Shell - English.bat"
echo The default user is "guest" and the default password is "guest". You can change these credentials in the "users.cfg" file located in the same directory as this setup script.
echo To create a new user, simply add a new line in the "users.cfg" file with the format "username=password". For example, to create a user named "admin" with the password "admin123", you would add the line "admin=admin123" to the file.
notepad "users.cfg"
set /p launch=Do you want to launch the Compact Shell? (y/n):
if /i "%launch%"=="y" start "" "C:\Users\%USERNAME%\Documents\Starting\English.bat"
if /i "%launch%"=="n" exit
