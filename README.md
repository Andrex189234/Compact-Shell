  <a href="https://github.com/Andrex189234/Compact-Shell/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/Andrex189234/Compact-Shell?color=0088ff" />
  </a>
  <a href="https://github.com/Andrex189234/Compact-Shell/pulls">
    <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/Andrex189234/Compact-Shell?color=0088ff" />
  </a>

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
git clone https://github.com/Andrex189234/Compact-Shell.git
```

2. Create a folder named "Starting" in your Documents and paste all file
3. (Optional) Add to PATH to run the shell from any terminal:
4. Run shell.bat
5. Log with guest (password:guest)
6. Create a new user in user.cfg (user=password)
   
