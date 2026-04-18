# =============================================================
#  dotfiles/install.ps1 — Orquestador de setup para Windows
#  Uso: pwsh -ExecutionPolicy Bypass -File install.ps1
#  Nota: correr como Administrador para Chocolatey y RTK hook
# =============================================================

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

# Variables compartidas con todos los sub-scripts (dot-source comparte scope)
$dotfiles    = $PSScriptRoot
$nvimTarget  = "$env:LOCALAPPDATA\nvim"
$gitTarget   = "$env:USERPROFILE"
$claudeHooks = "$env:USERPROFILE\.claude\hooks"
$claudeMd    = "$env:USERPROFILE\.claude\CLAUDE.md"

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host "`n=== DOTFILES INSTALL ===" -ForegroundColor Cyan
Write-Host "  Pasos:" -ForegroundColor DarkGray
Write-Host "    00-wsl              01-rust             02-chocolatey" -ForegroundColor DarkGray
Write-Host "    03-node             03b-npm             04-winget" -ForegroundColor DarkGray
Write-Host "    05-bun              06-claude           07-opencode-accounts" -ForegroundColor DarkGray
Write-Host "    08-scoop            09-rtk              10-symlinks" -ForegroundColor DarkGray
Write-Host "    11-gentle-ai" -ForegroundColor DarkGray
if (-not $isAdmin) {
    Write-Host "  AVISO: No sos admin. WSL2, Chocolatey y RTK hook seran omitidos." -ForegroundColor DarkYellow
}

# Ejecutar cada paso en orden
$scripts = Get-ChildItem "$PSScriptRoot\scripts\*.ps1" | Sort-Object Name
foreach ($script in $scripts) {
    . $script.FullName
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
