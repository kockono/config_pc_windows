# =============================================================
#  dotfiles/install.ps1 — Setup automatico para Windows
#  Uso: pwsh -ExecutionPolicy Bypass -File install.ps1
# =============================================================

$dotfiles = $PSScriptRoot
$nvimTarget = "$env:LOCALAPPDATA\nvim"
$gitTarget  = "$env:USERPROFILE"

Write-Host "`n=== DOTFILES INSTALL ===" -ForegroundColor Cyan

# -------------------------------------------------------------
# 1. Scoop
# -------------------------------------------------------------
Write-Host "`n[1/4] Verificando Scoop..." -ForegroundColor Yellow

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Scoop..." -ForegroundColor Gray
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "  Scoop ya instalado." -ForegroundColor Green
}

# -------------------------------------------------------------
# 2. Paquetes Scoop
# -------------------------------------------------------------
Write-Host "`n[2/4] Instalando paquetes..." -ForegroundColor Yellow

$buckets = @("main", "extras", "nerd-fonts")
foreach ($bucket in $buckets) {
    scoop bucket add $bucket 2>$null
}

$packages = @(
    "main/neovim",
    "main/git",
    "main/lazygit",
    "nerd-fonts/JetBrainsMono-NF"
)

foreach ($pkg in $packages) {
    $name = $pkg.Split("/")[-1]
    Write-Host "  Instalando $name..." -ForegroundColor Gray
    scoop install $pkg 2>$null
}

Write-Host "  Paquetes OK." -ForegroundColor Green

# -------------------------------------------------------------
# 3. Symlinks — Neovim
# -------------------------------------------------------------
Write-Host "`n[3/4] Creando symlinks de Neovim..." -ForegroundColor Yellow

if (Test-Path $nvimTarget) {
    Write-Host "  Backup de nvim existente -> nvim.bak" -ForegroundColor Gray
    Rename-Item $nvimTarget "$nvimTarget.bak" -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType SymbolicLink -Path $nvimTarget -Target "$dotfiles\nvim" -Force | Out-Null
Write-Host "  Symlink nvim OK -> $nvimTarget" -ForegroundColor Green

# -------------------------------------------------------------
# 4. Symlinks — Git
# -------------------------------------------------------------
Write-Host "`n[4/4] Creando symlink de .gitconfig..." -ForegroundColor Yellow

$gitconfigTarget = "$gitTarget\.gitconfig"
if (Test-Path $gitconfigTarget) {
    Copy-Item $gitconfigTarget "$gitconfigTarget.bak" -Force
}

New-Item -ItemType SymbolicLink -Path $gitconfigTarget -Target "$dotfiles\git\.gitconfig" -Force | Out-Null
Write-Host "  Symlink .gitconfig OK" -ForegroundColor Green

# -------------------------------------------------------------
# Listo
# -------------------------------------------------------------
Write-Host "`n=== INSTALACION COMPLETA ===" -ForegroundColor Cyan
Write-Host "Proximos pasos:" -ForegroundColor White
Write-Host "  1. Configura la fuente 'JetBrainsMono Nerd Font' en tu terminal" -ForegroundColor Gray
Write-Host "  2. Abri Neovim — lazy.nvim instala los plugins automaticamente" -ForegroundColor Gray
Write-Host "  3. Ejecuta :checkhealth en Neovim para verificar todo" -ForegroundColor Gray
