# =============================================================
#  dotfiles/install.ps1 — Setup automatico para Windows
#  Uso: pwsh -ExecutionPolicy Bypass -File install.ps1
#  Nota: correr como Administrador para Chocolatey y RTK hook
# =============================================================

$dotfiles = $PSScriptRoot
$nvimTarget  = "$env:LOCALAPPDATA\nvim"
$gitTarget   = "$env:USERPROFILE"
$claudeHooks = "$env:USERPROFILE\.claude\hooks"
$claudeMd    = "$env:USERPROFILE\.claude\CLAUDE.md"

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host "`n=== DOTFILES INSTALL ===" -ForegroundColor Cyan
Write-Host "  Pasos: 0=WSL2  1=Rust  2=Choco  3=WinGet  4=Bun  5=Claude Code  6=Scoop  7=Paquetes  8=RTK  9=Symlinks  10=gentle-ai" -ForegroundColor DarkGray
if (-not $isAdmin) {
    Write-Host "  AVISO: No sos admin. WSL2, Chocolatey y RTK hook seran omitidos." -ForegroundColor DarkYellow
}

# -------------------------------------------------------------
# 0. WSL2 + Ubuntu (requiere admin + reinicio)
# -------------------------------------------------------------
Write-Host "`n[0/9] Verificando WSL2..." -ForegroundColor Yellow

if ($isAdmin) {
    $wslStatus = wsl --status 2>&1
    if ($wslStatus -match "Version\s*:\s*2" -or $wslStatus -match "Versi.n predeterminada\s*:\s*2") {
        Write-Host "  WSL2 ya instalado." -ForegroundColor Green
    } else {
        Write-Host "  Instalando WSL2 + Ubuntu..." -ForegroundColor Gray
        wsl --install 2>$null
        Write-Host "  WSL2 instalado. REINICIA la PC y vuelve a correr el script para continuar." -ForegroundColor Yellow
        exit 0
    }
} else {
    Write-Host "  OMITIDO (requiere admin)." -ForegroundColor DarkYellow
}

# -------------------------------------------------------------
# 1. Rust + Cargo (via rustup)
# -------------------------------------------------------------
Write-Host "`n[1/9] Verificando Rust + Cargo..." -ForegroundColor Yellow

if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando rustup..." -ForegroundColor Gray
    $rustupInstaller = "$env:TEMP\rustup-init.exe"
    Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile $rustupInstaller
    & $rustupInstaller -y --no-modify-path
    $env:PATH += ";$env:USERPROFILE\.cargo\bin"
    Write-Host "  Rust + Cargo instalados OK." -ForegroundColor Green
} else {
    Write-Host "  Cargo ya instalado: $((Get-Command cargo).Source)" -ForegroundColor Green
}

# -------------------------------------------------------------
# 1. Chocolatey + paquetes (requiere admin)
# -------------------------------------------------------------
Write-Host "`n[2/9] Verificando Chocolatey..." -ForegroundColor Yellow

if ($isAdmin) {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "  Instalando Chocolatey..." -ForegroundColor Gray
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "  Chocolatey instalado OK." -ForegroundColor Green
    } else {
        Write-Host "  Chocolatey ya instalado: $((Get-Command choco).Source)" -ForegroundColor Green
    }

    $chocoPackages = @(
        # Dev tools
        "git", "ripgrep", "fd", "make", "curl", "wget",
        "corretto11jdk", "maven", "awscli",  "golang", "python312",
        "putty.install", "autoruns", "dbeaver", "docker-cli",
        "docker-desktop", "nvm", "winget/cli", "terraform",
        # Editores / IDEs
        "vscode",
        # Browsers
        "brave",
        # Comunicacion
        "discord", "thunderbird", "anydesk",
        # Multimedia
        "vlc.install", "4k-youtube-to-mp3", "file-converter",
        # Productividad
        "obsidian", "powertoys", "googledrive",
        "adobereader", "winrar", "7zip", "office2019proplus"
        # Gaming
        "steam",
        # Automatizacion
        "autohotkey",
        # Seguridad / Hacking
        "nmap", "wireshark", "burp-suite-free-edition"
    )
    Write-Host "  Instalando paquetes Chocolatey..." -ForegroundColor Gray
    foreach ($pkg in $chocoPackages) {
        choco install $pkg -y --no-progress 2>$null
        Write-Host "    $pkg OK" -ForegroundColor Gray
    }
} else {
    Write-Host "  OMITIDO (requiere admin)." -ForegroundColor DarkYellow
}

# -------------------------------------------------------------
# 2. WinGet — paquetes del sistema
# -------------------------------------------------------------
Write-Host "`n[2/8] Instalando paquetes WinGet..." -ForegroundColor Yellow

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "  Actualizando PowerShell..." -ForegroundColor Gray
    winget install --id Microsoft.PowerShell -e --source winget --accept-package-agreements --accept-source-agreements 2>$null
    Write-Host "  PowerShell OK" -ForegroundColor Green
} else {
    Write-Host "  OMITIDO: winget no disponible en este sistema." -ForegroundColor DarkYellow
}

# -------------------------------------------------------------
# 3. Bun (via install script oficial)
# -------------------------------------------------------------
Write-Host "`n[3/8] Verificando Bun..." -ForegroundColor Yellow

if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Bun..." -ForegroundColor Gray
    # Instalador oficial de Bun para Windows (binario nativo, no requiere Node)
    Invoke-RestMethod -Uri "https://bun.sh/install.ps1" | Invoke-Expression
    $env:PATH += ";$env:USERPROFILE\.bun\bin"
    Write-Host "  Bun instalado OK." -ForegroundColor Green
} else {
    Write-Host "  Bun ya instalado: $((Get-Command bun).Source)" -ForegroundColor Green
}

# -------------------------------------------------------------
# 3. Claude Code (instalador oficial nativo para Windows)
# -------------------------------------------------------------
Write-Host "`n[4/8] Verificando Claude Code..." -ForegroundColor Yellow

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Claude Code..." -ForegroundColor Gray
    # Binario nativo — no requiere Node ni npm
    Invoke-RestMethod -Uri "https://claude.ai/install.ps1" | Invoke-Expression
    Write-Host "  Claude Code instalado OK." -ForegroundColor Green
} else {
    Write-Host "  Claude Code ya instalado: $((Get-Command claude).Source)" -ForegroundColor Green
}

# -------------------------------------------------------------
# 4b. bin/ — opc.ps1 (switch de cuentas OpenCode)
# -------------------------------------------------------------
Write-Host "`n[4b/8] Configurando bin/opc.ps1..." -ForegroundColor Yellow

$binDir      = "$env:USERPROFILE\bin"
$opcScript   = "$binDir\opc.ps1"
$aliasSource = "$dotfiles\powershell\opencode-aliases.ps1"
$authDir     = "$HOME\.local\share\opencode"

# Crear carpeta bin si no existe
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null
    Write-Host "  Carpeta bin creada: $binDir" -ForegroundColor Gray
}

# Escribir opc.ps1
$opcContent = @"
`$dotfilesRoot = if (`$env:OPENCODE_DOTFILES) { `$env:OPENCODE_DOTFILES } else { '$($dotfiles -replace '\\','\\')' }
`$scriptPath   = '$($dotfiles -replace '\\','\\')\powershell\opencode-aliases.ps1'

if (-not (Test-Path `$scriptPath)) {
  Write-Host "No se encontro: `$scriptPath" -ForegroundColor Red
  exit 1
}

. `$scriptPath
opc @args
"@
[System.IO.File]::WriteAllText($opcScript, $opcContent, [System.Text.UTF8Encoding]::new($false))
Write-Host "  opc.ps1 escrito en: $opcScript" -ForegroundColor Gray

# Crear auth-primary.json si no existe (placeholder vacío)
New-Item -ItemType Directory -Force -Path $authDir | Out-Null
if (-not (Test-Path "$authDir\auth-primary.json")) {
    [System.IO.File]::WriteAllText("$authDir\auth-primary.json", "{}", [System.Text.UTF8Encoding]::new($false))
    Write-Host "  auth-primary.json creado (placeholder). Reemplazalo con tu sesion real." -ForegroundColor DarkYellow
} else {
    Write-Host "  auth-primary.json ya existe." -ForegroundColor Green
}

# Crear auth-secondary.json si no existe (placeholder vacío)
if (-not (Test-Path "$authDir\auth-secondary.json")) {
    [System.IO.File]::WriteAllText("$authDir\auth-secondary.json", "{}", [System.Text.UTF8Encoding]::new($false))
    Write-Host "  auth-secondary.json creado (placeholder). Reemplazalo con tu sesion real." -ForegroundColor DarkYellow
} else {
    Write-Host "  auth-secondary.json ya existe." -ForegroundColor Green
}

# Agregar bin/ al PATH del usuario si no está
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$binDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$binDir", "User")
    $env:PATH += ";$binDir"
    Write-Host "  $binDir agregado al PATH del usuario." -ForegroundColor Green
} else {
    Write-Host "  $binDir ya esta en el PATH." -ForegroundColor Green
}

Write-Host "  bin/opc.ps1 listo. Usa: opc 1 | opc 2 | opc --save=1 | opc --save=2" -ForegroundColor Green

# -------------------------------------------------------------
# 4. Scoop
# -------------------------------------------------------------
Write-Host "`n[5/8] Verificando Scoop..." -ForegroundColor Yellow

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Scoop..." -ForegroundColor Gray
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "  Scoop ya instalado." -ForegroundColor Green
}

# -------------------------------------------------------------
# 5. Paquetes Scoop
# -------------------------------------------------------------
Write-Host "`n[6/8] Instalando paquetes Scoop..." -ForegroundColor Yellow

$buckets = @("main", "extras", "nerd-fonts")
foreach ($bucket in $buckets) {
    scoop bucket add $bucket 2>$null
}

$scoopPackages = @(
    # Editores / terminal
    "main/neovim",
    "main/lazygit",
    "main/opencode",
    # Dev tools
    "main/gh",
    "main/jq",
    "main/mkcert",
    "main/fzf",
    # Go tools
    "main/air",
    # Python
    "main/uv",
    "main/pipx",
    # Terminal utilities
    "main/bat",
    "main/delta",
    "main/zoxide",
    # Node / JS
    "main/pnpm",
    # Fuentes
    "nerd-fonts/JetBrainsMono-NF"
)

foreach ($pkg in $scoopPackages) {
    $name = $pkg.Split("/")[-1]
    Write-Host "  Instalando $name..." -ForegroundColor Gray
    scoop install $pkg 2>$null
}

Write-Host "  Paquetes Scoop OK." -ForegroundColor Green

# -------------------------------------------------------------
# 4. RTK hook — PowerShell (Option B, sin dependencias extra)
#    Referencia: github.com/rtk-ai/rtk/discussions/1212
# -------------------------------------------------------------
Write-Host "`n[7/8] Configurando RTK hook para Claude Code..." -ForegroundColor Yellow

if ($isAdmin) {
    New-Item -ItemType Directory -Force $claudeHooks | Out-Null

    $hookScript = @'
# RTK PreToolUse hook — Windows PowerShell
# Referencia: github.com/rtk-ai/rtk/discussions/1212
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$json = [Console]::In.ReadToEnd()

try {
    $data = $json | ConvertFrom-Json
} catch {
    exit 0
}

$cmd = $data.tool_input.command
if (-not $cmd) { exit 0 }

$rewritten = & rtk rewrite $cmd 2>$null
$exitCode  = $LASTEXITCODE

if ($exitCode -eq 0 -and $rewritten -and $rewritten -ne $cmd) {
    @{
        hookSpecificOutput = @{
            hookEventName      = "PreToolUse"
            permissionDecision = "allow"
            updatedInput       = @{ command = $rewritten }
        }
    } | ConvertTo-Json -Compress -Depth 5
} elseif ($exitCode -eq 3 -and $rewritten -and $rewritten -ne $cmd) {
    @{
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            updatedInput  = @{ command = $rewritten }
        }
    } | ConvertTo-Json -Compress -Depth 5
}

exit 0
'@

    $hookPath = "$claudeHooks\rtk-rewrite.ps1"
    [System.IO.File]::WriteAllText($hookPath, $hookScript, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  Hook escrito en: $hookPath" -ForegroundColor Gray

    # Patch settings.json
    $settingsPath = "$env:USERPROFILE\.claude\settings.json"
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
    } else {
        $settings = [PSCustomObject]@{}
    }

    $hookEntry = @{
        type    = "command"
        command = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$hookPath`""
        timeout = 5
    }

    $hookBlock = @{
        matcher = "Bash"
        hooks   = @($hookEntry)
    }

    if (-not $settings.hooks) {
        $settings | Add-Member -NotePropertyName "hooks" -NotePropertyValue @{}
    }
    if (-not $settings.hooks.PreToolUse) {
        $settings.hooks | Add-Member -NotePropertyName "PreToolUse" -NotePropertyValue @()
    }
    $settings.hooks.PreToolUse = @($hookBlock)

    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
    Write-Host "  settings.json actualizado OK." -ForegroundColor Green

    # Agregar @RTK.md a CLAUDE.md si no está
    if (-not (Test-Path $claudeMd) -or -not (Select-String -Path $claudeMd -Pattern "@RTK.md" -Quiet)) {
        Add-Content -Path $claudeMd -Value "`n@RTK.md" -Encoding UTF8
        Write-Host "  @RTK.md agregado a CLAUDE.md." -ForegroundColor Green
    } else {
        Write-Host "  CLAUDE.md ya tiene @RTK.md." -ForegroundColor Green
    }
} else {
    Write-Host "  OMITIDO (requiere admin)." -ForegroundColor DarkYellow
}

# -------------------------------------------------------------
# 5. Symlinks — Neovim
# -------------------------------------------------------------
Write-Host "`n[8/8] Creando symlinks..." -ForegroundColor Yellow

if (Test-Path $nvimTarget) {
    Write-Host "  Backup nvim existente -> nvim.bak" -ForegroundColor Gray
    Rename-Item $nvimTarget "$nvimTarget.bak" -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType SymbolicLink -Path $nvimTarget -Target "$dotfiles\nvim" -Force | Out-Null
Write-Host "  Symlink nvim OK -> $nvimTarget" -ForegroundColor Green

# -------------------------------------------------------------
# 6. Symlinks — Git
# -------------------------------------------------------------
Write-Host "`n  .gitconfig..." -ForegroundColor Yellow

$gitconfigTarget = "$gitTarget\.gitconfig"
if (Test-Path $gitconfigTarget) {
    Copy-Item $gitconfigTarget "$gitconfigTarget.bak" -Force
}

New-Item -ItemType SymbolicLink -Path $gitconfigTarget -Target "$dotfiles\git\.gitconfig" -Force | Out-Null
Write-Host "  Symlink .gitconfig OK" -ForegroundColor Green

# -------------------------------------------------------------
# 9. gentle-ai (via Scoop)
# -------------------------------------------------------------
Write-Host "`n[9/9] Verificando gentle-ai..." -ForegroundColor Yellow

if (-not (Get-Command gentle-ai -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando gentle-ai via Scoop..." -ForegroundColor Gray
    scoop bucket add gentleman https://github.com/Gentleman-Programming/scoop-bucket 2>$null
    scoop install gentle-ai 2>$null
    Write-Host "  gentle-ai instalado OK." -ForegroundColor Green
} else {
    Write-Host "  gentle-ai ya instalado: $((Get-Command gentle-ai).Source)" -ForegroundColor Green
}

# -------------------------------------------------------------
# Listo
# -------------------------------------------------------------
Write-Host "`n=== INSTALACION COMPLETA ===" -ForegroundColor Cyan
Write-Host "Proximos pasos:" -ForegroundColor White
Write-Host "  1. Configura 'JetBrainsMono Nerd Font' en tu terminal" -ForegroundColor Gray
Write-Host "  2. Abri Neovim — lazy.nvim instala plugins automaticamente" -ForegroundColor Gray
Write-Host "  3. Ejecuta :checkhealth en Neovim para verificar todo" -ForegroundColor Gray
Write-Host "  4. Instala RTK: cargo install rtk  (luego reinicia la terminal)" -ForegroundColor Gray
Write-Host "  5. Abre OpenCode con: opencode" -ForegroundColor Gray
Write-Host "  6. Conecta tu provider en OpenCode con: /connect" -ForegroundColor Gray
Write-Host "  6b. Guarda tu sesion principal con: opc --save=1" -ForegroundColor Gray
Write-Host "  6c. Guarda tu sesion secundaria con: opc --save=2" -ForegroundColor Gray
Write-Host "  6d. Para cambiar de cuenta: opc 1 | opc 2" -ForegroundColor Gray
Write-Host "  7. Configura gentle-ai con: gentle-ai" -ForegroundColor Gray
