# Requires: $dotfiles
Write-Host "`n[7] Configurando bin/opc.ps1..." -ForegroundColor Yellow

$binDir      = "$env:USERPROFILE\bin"
$opcScript   = "$binDir\opc.ps1"
$authDir     = "$HOME\.local\share\opencode"

if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null
    Write-Host "  Carpeta bin creada: $binDir" -ForegroundColor Gray
}

$opcContent = @"
`$dotfilesRoot = if (`$env:OPENCODE_DOTFILES) { `$env:OPENCODE_DOTFILES } else { '$($dotfiles -replace '\\','\\')' }
`$scriptPath   = '$($dotfiles -replace '\\','\\')\powershell\opencode-aliases.ps1'

if (-not (Test-Path `$scriptPath)) {
  Write-Host "No se encontro: `$scriptPath" -ForegroundColor Red
  exit 1
}

. `$scriptPath
opc @args
"@
[System.IO.File]::WriteAllText($opcScript, $opcContent, [System.Text.UTF8Encoding]::new($false))
Write-Host "  opc.ps1 escrito en: $opcScript" -ForegroundColor Gray

New-Item -ItemType Directory -Force -Path $authDir | Out-Null
if (-not (Test-Path "$authDir\auth-primary.json")) {
    [System.IO.File]::WriteAllText("$authDir\auth-primary.json", "{}", [System.Text.UTF8Encoding]::new($false))
    Write-Host "  auth-primary.json creado (placeholder)." -ForegroundColor DarkYellow
} else {
    Write-Host "  auth-primary.json ya existe." -ForegroundColor Green
}

if (-not (Test-Path "$authDir\auth-secondary.json")) {
    [System.IO.File]::WriteAllText("$authDir\auth-secondary.json", "{}", [System.Text.UTF8Encoding]::new($false))
    Write-Host "  auth-secondary.json creado (placeholder)." -ForegroundColor DarkYellow
} else {
    Write-Host "  auth-secondary.json ya existe." -ForegroundColor Green
}

$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$binDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$binDir", "User")
    $env:PATH += ";$binDir"
    Write-Host "  $binDir agregado al PATH del usuario." -ForegroundColor Green
} else {
    Write-Host "  $binDir ya esta en el PATH." -ForegroundColor Green
}

Write-Host "  bin/opc.ps1 listo." -ForegroundColor Green
