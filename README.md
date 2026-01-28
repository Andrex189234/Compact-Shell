[![Andrea's GitHub stats](https://github-readme-stats.vercel.app/api?username=Andrex189234)](https://github.com/anuraghazra/github-readme-stats)

# CompactShell

**CompactShell** is an advanced shell built in **Windows batch**, featuring Linux-like functionality, a package manager, multi-user login, and a plugin system.

---

## Key Features

* **Multi-user login** with `users.cfg`
* **Dynamic prompt** `[user@pc cwd]$`
* **Package management** with Winget:

  * `pkg install <name>`
  * `pkg uninstall <name>`
  * `pkg search <name>`
  * `pkg upgrade <name|all>`
  * `pkg update all` (alias for upgrade all)
* **Universal exec**: run files in the current or specified directory
* **Custom aliases** (`shell.cfg`)
* **Command history and autocompletion**
* **Plugin system** (`commands.d`)
* Optional **kiosk / lock shell mode**
* System commands: `reboot`, `shutdown`, `sleep`, `notify`, `logout`, `reopen`

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/CompactShell.git
```

2. Create a folder named "Starting" in your Documents
3. (Optional) Add to PATH to run the shell from any terminal:

Add the folder to your system PATH
