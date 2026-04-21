# Requires: $isAdmin
Write-Host "`n[2] Verificando Chocolatey..." -ForegroundColor Yellow

if ($isAdmin) {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "  Instalando Chocolatey..." -ForegroundColor Gray
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "  Chocolatey instalado OK." -ForegroundColor Green
    } else {
        Write-Host "  Chocolatey ya instalado: $((Get-Command choco).Source)" -ForegroundColor Green
    }

    $chocoPackages = @(
        # Dev tools
        "ripgrep", "fd", "make", "curl", "wget",
        "corretto11jdk", "maven", "awscli", "golang", "python312",
        "putty.install", "autoruns", "dbeaver", "docker-cli",
        "docker-desktop", "nvm", "winget/cli", "terraform", 
        # Editores / IDEs
        "vscode",
        # Browsers
        "brave",
        # Comunicacion
        "discord", "thunderbird", "anydesk",
        # Multimedia
        "vlc.install", "4k-youtube-to-mp3", "file-converter",
        # Productividad
        "obsidian", "powertoys", "googledrive",
        "adobereader", "winrar", "7zip", "office2019proplus",
        # Gaming
        "steam", "logitechgaming","gh",
        # Automatizacion
        "autohotkey",
        # Seguridad / Hacking
        "nmap", "wireshark", "burp-suite-free-edition"
    )
    Write-Host "  Instalando paquetes Chocolatey..." -ForegroundColor Gray
    foreach ($pkg in $chocoPackages) {
        try {
            choco install $pkg -y --no-progress 2>$null
            Write-Host "    $pkg OK" -ForegroundColor Gray
        } catch {
            Write-Host "    $pkg WARN: $_" -ForegroundColor DarkYellow
        }
    }
} else {
    Write-Host "  OMITIDO (requiere admin)." -ForegroundColor DarkYellow
}
