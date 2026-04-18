# Requires: $isAdmin, $claudeHooks, $claudeMd
Write-Host "`n[9] Configurando RTK hook para Claude Code..." -ForegroundColor Yellow

if ($isAdmin) {
    New-Item -ItemType Directory -Force $claudeHooks | Out-Null

    $hookScript = @'
# RTK PreToolUse hook — Windows PowerShell
# Referencia: github.com/rtk-ai/rtk/discussions/1212
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$json = [Console]::In.ReadToEnd()

try {
    $data = $json | ConvertFrom-Json
} catch {
    exit 0
}

$cmd = $data.tool_input.command
if (-not $cmd) { exit 0 }

$rewritten = & rtk rewrite $cmd 2>$null
$exitCode  = $LASTEXITCODE

if ($exitCode -eq 0 -and $rewritten -and $rewritten -ne $cmd) {
    @{
        hookSpecificOutput = @{
            hookEventName      = "PreToolUse"
            permissionDecision = "allow"
            updatedInput       = @{ command = $rewritten }
        }
    } | ConvertTo-Json -Compress -Depth 5
} elseif ($exitCode -eq 3 -and $rewritten -and $rewritten -ne $cmd) {
    @{
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            updatedInput  = @{ command = $rewritten }
        }
    } | ConvertTo-Json -Compress -Depth 5
}

exit 0
'@

    $hookPath = "$claudeHooks\rtk-rewrite.ps1"
    [System.IO.File]::WriteAllText($hookPath, $hookScript, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  Hook escrito en: $hookPath" -ForegroundColor Gray

    $settingsPath = "$env:USERPROFILE\.claude\settings.json"
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
    } else {
        $settings = [PSCustomObject]@{}
    }

    $hookEntry = @{
        type    = "command"
        command = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$hookPath`""
        timeout = 5
    }

    $hookBlock = @{
        matcher = "Bash"
        hooks   = @($hookEntry)
    }

    if (-not $settings.hooks) {
        $settings | Add-Member -NotePropertyName "hooks" -NotePropertyValue @{}
    }
    if (-not $settings.hooks.PreToolUse) {
        $settings.hooks | Add-Member -NotePropertyName "PreToolUse" -NotePropertyValue @()
    }
    $settings.hooks.PreToolUse = @($hookBlock)

    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
    Write-Host "  settings.json actualizado OK." -ForegroundColor Green

    if (-not (Test-Path $claudeMd) -or -not (Select-String -Path $claudeMd -Pattern "@RTK.md" -Quiet)) {
        Add-Content -Path $claudeMd -Value "`n@RTK.md" -Encoding UTF8
        Write-Host "  @RTK.md agregado a CLAUDE.md." -ForegroundColor Green
    } else {
        Write-Host "  CLAUDE.md ya tiene @RTK.md." -ForegroundColor Green
    }
} else {
    Write-Host "  OMITIDO (requiere admin)." -ForegroundColor DarkYellow
}
