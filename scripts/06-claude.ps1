Write-Host "`n[6] Verificando Claude Code..." -ForegroundColor Yellow

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Claude Code..." -ForegroundColor Gray
    Invoke-RestMethod -Uri "https://claude.ai/install.ps1" | Invoke-Expression
    Write-Host "  Claude Code instalado OK." -ForegroundColor Green
} else {
    Write-Host "  Claude Code ya instalado: $((Get-Command claude).Source)" -ForegroundColor Green
}
