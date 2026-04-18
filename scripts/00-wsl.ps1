# Requires: $isAdmin
Write-Host "`n[0] Verificando WSL2..." -ForegroundColor Yellow

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
