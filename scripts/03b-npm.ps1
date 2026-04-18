# Requiere: Node instalado via nvm (03-node.ps1)
Write-Host "`n[3b] Instalando paquetes npm globales..." -ForegroundColor Yellow

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "  OMITIDO: npm no disponible. Verifica que nvm este activo." -ForegroundColor DarkYellow
    return
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

Write-Host "  Paquetes npm OK." -ForegroundColor Green
