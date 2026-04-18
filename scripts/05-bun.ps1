Write-Host "`n[5] Verificando Bun..." -ForegroundColor Yellow

if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Bun..." -ForegroundColor Gray
    Invoke-RestMethod -Uri "https://bun.sh/install.ps1" | Invoke-Expression
    $env:PATH += ";$env:USERPROFILE\.bun\bin"
    Write-Host "  Bun instalado OK." -ForegroundColor Green
} else {
    Write-Host "  Bun ya instalado: $((Get-Command bun).Source)" -ForegroundColor Green
}
