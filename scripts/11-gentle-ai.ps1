Write-Host "`n[11] Verificando gentle-ai..." -ForegroundColor Yellow

if (-not (Get-Command gentle-ai -ErrorAction SilentlyContinue)) {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "  Instalando gentle-ai via Scoop..." -ForegroundColor Gray
        try { scoop bucket add gentleman https://github.com/Gentleman-Programming/scoop-bucket 2>$null } catch {}
        scoop install gentle-ai
    } elseif (Get-Command go -ErrorAction SilentlyContinue) {
        Write-Host "  Instalando gentle-ai via go install..." -ForegroundColor Gray
        go install github.com/gentleman-programming/gentle-ai/cmd/gentle-ai@latest
    } else {
        Write-Host "  Instalando gentle-ai via PowerShell script..." -ForegroundColor Gray
        irm https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.ps1 | iex
    }
    Write-Host "  gentle-ai instalado OK." -ForegroundColor Green
} else {
    Write-Host "  gentle-ai ya instalado: $((Get-Command gentle-ai).Source)" -ForegroundColor Green
}
