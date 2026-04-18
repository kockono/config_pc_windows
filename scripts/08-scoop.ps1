Write-Host "`n[8] Verificando Scoop..." -ForegroundColor Yellow

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "  Instalando Scoop..." -ForegroundColor Gray
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "  Scoop ya instalado." -ForegroundColor Green
}

Write-Host "`n[8b] Instalando paquetes Scoop..." -ForegroundColor Yellow

$buckets = @("main", "extras", "nerd-fonts")
foreach ($bucket in $buckets) {
    try { scoop bucket add $bucket 2>$null } catch {}
}

$scoopPackages = @(
    # Editores / terminal
    "main/neovim",
    "main/lazygit",
    "main/opencode",
    # Dev tools
    "main/gh",
    "main/jq",
    "main/mkcert",
    "main/fzf",
    # Go tools
    "main/air",
    # Python
    "main/uv",
    "main/pipx",
    # Terminal utilities
    "main/bat",
    "main/delta",
    "main/zoxide",
    # Node / JS
    "main/pnpm",
    # Fuentes
    "nerd-fonts/JetBrainsMono-NF"
)

foreach ($pkg in $scoopPackages) {
    $name = $pkg.Split("/")[-1]
    Write-Host "  Instalando $name..." -ForegroundColor Gray
    try { scoop install $pkg 2>$null } catch {}
}

Write-Host "  Paquetes Scoop OK." -ForegroundColor Green
