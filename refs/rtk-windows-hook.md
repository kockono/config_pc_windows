# RTK Hook en Windows — Referencia

> Fuente: https://github.com/rtk-ai/rtk/discussions/1212  
> Autor: @kockono

## El problema

`rtk init -g` solo funciona en Unix. En Windows siempre muestra:

```
[rtk] /!\ No hook installed — run `rtk init -g` for automatic token savings
```

Esto pasa porque el instalador del hook tiene tres dependencias Unix:
1. **Bash** — el script es `.sh`
2. **`jq`** — para parsear JSON
3. **`chmod 755`** — permisos Unix, no compila en Windows

Sin hook, RTK solo funciona ~70-80% del tiempo (depende de que el LLM lea y siga las instrucciones). Con hook: ~100%.

---

## Solución usada: Option B — PowerShell

Sin dependencias extra. Solo PowerShell 7+.

### 1. Crear `~/.claude/hooks/rtk-rewrite.ps1`

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$json = [Console]::In.ReadToEnd()

try {
    $data = $json | ConvertFrom-Json
} catch { exit 0 }

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
```

### 2. Patch `~/.claude/settings.json`

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File C:\\Users\\<TU_USUARIO>\\.claude\\hooks\\rtk-rewrite.ps1",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### 3. Agregar `@RTK.md` a `~/.claude/CLAUDE.md`

```
@RTK.md
```

### 4. Test

```powershell
$json = '{"session_id":"test","tool_name":"Bash","tool_input":{"command":"git status"}}'
$json | powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\hooks\rtk-rewrite.ps1"
```

Resultado esperado:
```json
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":"rtk git status"}}}
```

---

## Gotchas importantes

| Bug | Causa | Fix |
|-----|-------|-----|
| JSON garbled | PowerShell 7 usa UTF-16LE por default | `[Console]::OutputEncoding = UTF8` |
| Hook bloqueado | Execution policy | `-ExecutionPolicy Bypass` |
| Hook sin stdin | `"async": true` cierra el pipe | No usar `async` |
| BOM en archivos | `Set-Content -Encoding UTF8` agrega BOM | Usar `[System.IO.File]::WriteAllText()` con `UTF8Encoding($false)` |

---

## Nota sobre el warning cosmético

Las opciones A y B siguen mostrando `[warn] Hook outdated` porque RTK compara
el contenido del archivo contra su script bash embebido. El hook funciona
correctamente igual — el warning es cosmético.

Solo la **Option C (WSL)** elimina el warning completamente.

---

## Otras opciones disponibles

| Opción | Requisitos | Hook detectado por RTK |
|--------|-----------|----------------------|
| **A — Git Bash** | Git for Windows + jq | ⚠️ parcial |
| **B — PowerShell** | PowerShell 7+ | ⚠️ parcial |
| **C — WSL** | WSL2 + Ubuntu | ✅ completo |
