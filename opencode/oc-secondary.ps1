if (-not (Test-Path "$HOME\.local\share\opencode\auth-secondary.json")) {
  Write-Host "No existe auth-secondary.json" -ForegroundColor Red
  exit 1
}

Copy-Item "$HOME\.local\share\opencode\auth-secondary.json" "$HOME\.local\share\opencode\auth.json" -Force
Write-Host "Cuenta activa: secundaria" -ForegroundColor Green
opencode
