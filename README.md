# dotfiles — Windows Setup

Setup automatizado para entorno de desarrollo en Windows.  
Un solo script instala todo y configura los symlinks.

## Uso

```powershell
# Clonar el repo
git clone https://github.com/kockono/config_pc_windows.git dotfiles

# Ejecutar como Administrador
pwsh -ExecutionPolicy Bypass -File dotfiles\install.ps1
```

> ⚠️ **Requiere Administrador** para: WSL2, Chocolatey y RTK hook.  
> Si WSL2 no está instalado, el script lo instala y pide reiniciar. Volvé a correrlo después del reinicio.

---

## Pasos del script

| Paso | Qué hace | Requiere admin |
|------|----------|---------------|
| `[0/9]` | WSL2 + Ubuntu | ✅ |
| `[1/9]` | Rust + Cargo (via rustup) | ❌ |
| `[2/9]` | Chocolatey + paquetes | ✅ |
| `[3/9]` | WinGet — PowerShell | ❌ |
| `[4/9]` | Bun (binario nativo) | ❌ |
| `[5/9]` | Claude Code (binario nativo) | ❌ |
| `[6/9]` | Scoop | ❌ |
| `[7/9]` | Paquetes Scoop | ❌ |
| `[8/9]` | RTK hook para Claude Code | ✅ |
| `[9/9]` | Symlinks (nvim + .gitconfig) | ❌ |

---

## Paquetes instalados

### Chocolatey

#### Dev Tools
| Paquete | Descripción |
|---------|-------------|
| `git` | Control de versiones |
| `ripgrep` | Búsqueda de texto ultra rápida |
| `fd` | Alternativa moderna a `find` |
| `make` | Build tool |
| `curl` | HTTP client |
| `wget` | Descargador de archivos via HTTP/FTP |
| `corretto11jdk` | Java 11 LTS (Amazon Corretto) |
| `maven` | Build tool para Java |
| `awscli` | AWS Command Line Interface |
| `putty.install` | Cliente SSH |
| `autoruns` | Gestor de arranque de Windows |
| `dbeaver` | Cliente universal de bases de datos |
| `docker-desktop` | Contenedores Docker |
| `nvm` | Node Version Manager |

#### Editores / IDEs
| Paquete | Descripción |
|---------|-------------|
| `vscode` | Visual Studio Code |

#### Browsers
| Paquete | Descripción |
|---------|-------------|
| `brave` | Browser enfocado en privacidad |

#### Comunicación
| Paquete | Descripción |
|---------|-------------|
| `discord` | Chat para comunidades |
| `thunderbird` | Cliente de email |
| `anydesk` | Escritorio remoto |

#### Multimedia
| Paquete | Descripción |
|---------|-------------|
| `vlc.install` | Reproductor multimedia |
| `4k-youtube-to-mp3` | Descargador de audio |

#### Productividad
| Paquete | Descripción |
|---------|-------------|
| `obsidian` | Notas en Markdown / second brain |
| `powertoys` | Utilidades de productividad de Microsoft |
| `googledrive` | Sincronización con Google Drive |
| `adobereader` | Lector de PDFs |
| `winrar` | Compresor de archivos |
| `7zip` | Compresor open source |

#### Gaming
| Paquete | Descripción |
|---------|-------------|
| `steam` | Plataforma de juegos |

#### Automatización
| Paquete | Descripción |
|---------|-------------|
| `autohotkey` | Scripts de automatización para Windows |

#### Seguridad / Hacking
| Paquete | Descripción |
|---------|-------------|
| `nmap` | Scanner de red |
| `wireshark` | Análisis de paquetes de red |
| `burp-suite-free-edition` | Proxy HTTP para pentesting |

---

### WinGet
| Paquete | Descripción |
|---------|-------------|
| `Microsoft.PowerShell` | PowerShell 7+ (última versión) |

---

### Scoop

#### Editores / Terminal
| Paquete | Descripción |
|---------|-------------|
| `neovim` | Editor de texto |
| `lazygit` | TUI para Git |
| `opencode` | AI coding agent para terminal |

#### Dev Tools
| Paquete | Descripción |
|---------|-------------|
| `gh` | GitHub CLI |
| `jq` | Procesador de JSON en terminal |
| `mkcert` | Certificados SSL locales |
| `fzf` | Fuzzy finder para terminal |

#### Go Tools
| Paquete | Descripción |
|---------|-------------|
| `air` | Live reload para apps Go — recarga automática al guardar `.go` |

#### Python
| Paquete | Descripción |
|---------|-------------|
| `uv` | Gestor de paquetes Python ultra rápido (reemplaza pip + venv) |
| `pipx` | Instala tools Python de forma aislada |

#### Terminal Utilities
| Paquete | Descripción |
|---------|-------------|
| `bat` | `cat` con syntax highlighting |
| `delta` | Diff mejorado para git |
| `zoxide` | `cd` inteligente que recuerda tus directorios |

#### Node / JS
| Paquete | Descripción |
|---------|-------------|
| `pnpm` | Package manager rápido para Node |

#### Fuentes
| Paquete | Descripción |
|---------|-------------|
| `JetBrainsMono-NF` | JetBrainsMono Nerd Font — íconos para Neovim/terminal |

---

### Instaladores independientes

| Herramienta | Método | Descripción |
|-------------|--------|-------------|
| **Rust + Cargo** | `rustup` oficial | Lenguaje Rust y su gestor de paquetes |
| **Bun** | Script oficial `bun.sh/install.ps1` | Runtime JS/TS ultra rápido, reemplaza Node en muchos casos |
| **Claude Code** | Script oficial `claude.ai/install.ps1` | AI coding agent de Anthropic |
| **WSL2 + Ubuntu** | `wsl --install` | Windows Subsystem for Linux |

---

## Symlinks creados

| Symlink | Apunta a |
|---------|----------|
| `%LOCALAPPDATA%\nvim` | `dotfiles\nvim\` |
| `~\.gitconfig` | `dotfiles\git\.gitconfig` |

---

## RTK Hook (Claude Code)

Configura el hook `PreToolUse` para Claude Code en Windows usando PowerShell 7 (Option B — sin dependencias extra).

- Hook: `~\.claude\hooks\rtk-rewrite.ps1`
- Referencia: [github.com/rtk-ai/rtk/discussions/1212](https://github.com/rtk-ai/rtk/discussions/1212)
- Docs completas: [`refs/rtk-windows-hook.md`](refs/rtk-windows-hook.md)

---

## OpenCode multi-cuenta (Anthropic principal/secundaria)

Este repo incluye un setup para cambiar rápido entre 2 cuentas de OpenCode/Anthropic sin desloguearse manualmente.

- Config runtime: `~/.local/share/opencode/auth*.json`
- Scripts versionados: [`opencode/`](opencode/)
- Launcher global: `opc`

Uso:

```powershell
opc 1          # usar cuenta principal
opc 2          # usar cuenta secundaria
opc --save=1   # guardar sesión actual como principal
opc --save=2   # guardar sesión actual como secundaria
```

Instructivo completo:

- [`opencode/INSTRUCTIVO.md`](opencode/INSTRUCTIVO.md)

---

## Post-instalación

```powershell
# 1. Configurar fuente en tu terminal
#    → Warp: Settings > Appearance > Terminal font > "JetBrainsMono Nerd Font"

# 2. Abrir Neovim — instala plugins automáticamente
nvim

# 3. Verificar salud de Neovim
#    → dentro de nvim:
:checkhealth

# 4. Instalar RTK
cargo install rtk

# 5. Abrir OpenCode y conectar provider
opencode
# dentro de opencode:
/connect
```

---

## Estructura del repo

```
dotfiles/
├── install.ps1                       ← script maestro
├── README.md                         ← este archivo
├── git/
│   └── .gitconfig
├── nvim/
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── .stylua.toml
│   └── lua/
│       └── kickstart/
│           └── plugins/
│               └── neo-tree.lua
├── opencode/
│   ├── INSTRUCTIVO.md                ← guía para recuperar setup multi-cuenta
│   ├── oc-primary.ps1                ← activa cuenta principal
│   ├── oc-secondary.ps1              ← activa cuenta secundaria
│   └── oc-save-secondary.ps1         ← guarda sesión actual como secundaria
├── powershell/
│   └── opencode-aliases.ps1          ← función global `opc`
└── refs/
    └── rtk-windows-hook.md           ← workaround RTK en Windows
```
