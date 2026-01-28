# CompactShell

**CompactShell** è una shell avanzata realizzata in **batch Windows**, con funzionalità tipo Linux, gestore di pacchetti, login multi-utente e plugin system.

---

## Funzionalità principali

- **Login multi-utente** con `users.cfg`  
- **Prompt dinamico** `[user@pc cwd]$`  
- **Gestione pacchetti** con Winget:
  - `pkg install <nome>`  
  - `pkg uninstall <nome>`  
  - `pkg search <nome>`  
  - `pkg upgrade <nome|all>`  
  - `pkg update all` (alias di upgrade all)  
- **Exec universale**: esegui file nella directory corrente o specificata  
- **Alias personalizzati** (`shell.cfg`)  
- **Storico comandi e autocompletamento**  
- **Plugin system** (`commands.d`)  
- **Modalità kiosk / lock shell** opzionale  
- Comandi di sistema: `reboot`, `shutdown`, `sleep`, `notify`, `logout`, `reopen`

---

## Installazione

1. Clona il repository:

```bash
git clone https://github.com/tuo-username/CompactShell.git

2.
