# =============================================================
#  dotfiles/install-npm.ps1 — Paquetes globales npm
#  Uso: pwsh -ExecutionPolicy Bypass -File install-npm.ps1
#  Requiere: Node instalado via nvm (nvm use 20)
# =============================================================

Write-Host "`n=== NPM GLOBAL PACKAGES ===" -ForegroundColor Cyan

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "  ERROR: npm no disponible. Ejecuta 'nvm use 20' primero." -ForegroundColor Red
    exit 1
}

$npmPackages = @(
    # AI agents
    "@google/gemini-cli",
    "@openai/codex",
    "opencode-ai@1.4.7",
    # Dev tools
    "@angular/cli",
    "@capacitor/assets"
)

foreach ($pkg in $npmPackages) {
    Write-Host "  Instalando $pkg..." -ForegroundColor Gray
    npm i -g $pkg 2>$null
    Write-Host "    $pkg OK" -ForegroundColor Green
}

Write-Host "`n  Paquetes npm OK." -ForegroundColor Green
