Write-Host "`n[3] Configurando Node 20 via nvm..." -ForegroundColor Yellow

if (Get-Command nvm -ErrorAction SilentlyContinue) {
    try { nvm install 20 2>$null } catch {}
    try { nvm use 20 2>$null } catch {}
    $env:PATH += ";$env:APPDATA\nvm"
    Write-Host "  Node 20 activo." -ForegroundColor Green
} else {
    Write-Host "  OMITIDO: nvm no encontrado (requiere admin + reinicio)." -ForegroundColor DarkYellow
}
