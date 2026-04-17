Copy-Item "$HOME\.local\share\opencode\auth-primary.json" "$HOME\.local\share\opencode\auth.json" -Force
Write-Host "Cuenta activa: principal" -ForegroundColor Green
opencode
