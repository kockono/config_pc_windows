# Requires: $dotfiles, $nvimTarget, $gitTarget
Write-Host "`n[10] Creando symlinks..." -ForegroundColor Yellow

if (Test-Path $nvimTarget) {
    Write-Host "  Backup nvim existente -> nvim.bak" -ForegroundColor Gray
    Rename-Item $nvimTarget "$nvimTarget.bak" -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType SymbolicLink -Path $nvimTarget -Target "$dotfiles\nvim" -Force | Out-Null
Write-Host "  Symlink nvim OK -> $nvimTarget" -ForegroundColor Green

Write-Host "`n  .gitconfig..." -ForegroundColor Yellow
$gitconfigTarget = "$gitTarget\.gitconfig"
if (Test-Path $gitconfigTarget) {
    Copy-Item $gitconfigTarget "$gitconfigTarget.bak" -Force
}
New-Item -ItemType SymbolicLink -Path $gitconfigTarget -Target "$dotfiles\git\.gitconfig" -Force | Out-Null
Write-Host "  Symlink .gitconfig OK" -ForegroundColor Green
