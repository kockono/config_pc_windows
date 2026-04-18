Write-Host "`n[4] Instalando paquetes WinGet..." -ForegroundColor Yellow

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "  Actualizando PowerShell..." -ForegroundColor Gray
    try { winget install --id Microsoft.PowerShell -e --source winget --accept-package-agreements --accept-source-agreements 2>$null } catch {}
    Write-Host "  PowerShell OK" -ForegroundColor Green
} else {
    Write-Host "  OMITIDO: winget no disponible en este sistema." -ForegroundColor DarkYellow
}
