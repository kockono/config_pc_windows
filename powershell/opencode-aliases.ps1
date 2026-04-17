function opc {
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
  )

  $authDir = "$HOME\.local\share\opencode"
  $active  = Join-Path $authDir "auth.json"

  if (-not (Test-Path $authDir)) {
    New-Item -ItemType Directory -Force -Path $authDir | Out-Null
  }

  # --- Parse estilo: opc 1 / opc 2 / opc --save=1 / opc --save=2 ---
  if ($Args.Count -eq 0) {
    Write-Host "Uso:" -ForegroundColor Yellow
    Write-Host "  opc 1           -> usar cuenta principal" -ForegroundColor Yellow
    Write-Host "  opc 2           -> usar cuenta secundaria" -ForegroundColor Yellow
    Write-Host "  opc --save=1    -> guardar sesión actual como principal" -ForegroundColor Yellow
    Write-Host "  opc --save=2    -> guardar sesión actual como secundaria" -ForegroundColor Yellow
    return
  }

  $first = $Args[0]

  switch -Regex ($first) {
    '^1$' {
      $source = Join-Path $authDir "auth-primary.json"
      if (-not (Test-Path $source)) {
        Write-Host "No existe auth-primary.json" -ForegroundColor Red
        return
      }
      Copy-Item $source $active -Force
      Write-Host "Cuenta activa: principal" -ForegroundColor Green
      opencode
      return
    }

    '^2$' {
      $source = Join-Path $authDir "auth-secondary.json"
      if (-not (Test-Path $source)) {
        Write-Host "No existe auth-secondary.json" -ForegroundColor Red
        return
      }
      Copy-Item $source $active -Force
      Write-Host "Cuenta activa: secundaria" -ForegroundColor Green
      opencode
      return
    }

    '^--save=1$' {
      $target = Join-Path $authDir "auth-primary.json"
      if (-not (Test-Path $active)) {
        Write-Host "No existe auth.json activo para guardar" -ForegroundColor Red
        return
      }
      Copy-Item $active $target -Force
      Write-Host "Sesión actual guardada como principal" -ForegroundColor Green
      return
    }

    '^--save=2$' {
      $target = Join-Path $authDir "auth-secondary.json"
      if (-not (Test-Path $active)) {
        Write-Host "No existe auth.json activo para guardar" -ForegroundColor Red
        return
      }
      Copy-Item $active $target -Force
      Write-Host "Sesión actual guardada como secundaria" -ForegroundColor Green
      return
    }

    default {
      Write-Host "Argumento no reconocido: $first" -ForegroundColor Red
      Write-Host "Usá: opc 1 | opc 2 | opc --save=1 | opc --save=2" -ForegroundColor Yellow
      return
    }
  }
}
