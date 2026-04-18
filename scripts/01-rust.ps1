Write-Host "`n[1] Verificando Rust + Cargo..." -ForegroundColor Yellow

if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando rustup..." -ForegroundColor Gray
    $rustupInstaller = "$env:TEMP\rustup-init.exe"
    Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile $rustupInstaller
    & $rustupInstaller -y --no-modify-path
    $env:PATH += ";$env:USERPROFILE\.cargo\bin"
    Write-Host "  Rust + Cargo instalados OK." -ForegroundColor Green
} else {
    Write-Host "  Cargo ya instalado: $((Get-Command cargo).Source)" -ForegroundColor Green
}
