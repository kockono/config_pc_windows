# OpenCode multi-cuenta (Anthropic principal/secundaria)

## Objetivo

Evitar desloguearse y loguearse manualmente entre dos cuentas de OpenCode/Anthropic.

La estrategia es simple:

- `auth.json` = sesión activa actual
- `auth-primary.json` = respaldo de la cuenta principal
- `auth-secondary.json` = respaldo de la cuenta secundaria

Los scripts copian el respaldo correcto sobre `auth.json` y luego abren `opencode`.

---

## Archivos importantes

Ubicación runtime en Windows:

```powershell
$HOME\.local\share\opencode\auth.json
$HOME\.local\share\opencode\auth-primary.json
$HOME\.local\share\opencode\auth-secondary.json
```

Scripts versionados en dotfiles:

```powershell
E:\config_pc\dotfiles\opencode\oc-primary.ps1
E:\config_pc\dotfiles\opencode\oc-secondary.ps1
E:\config_pc\dotfiles\opencode\oc-save-secondary.ps1
```

---

## Uso diario

### Con la función `opc`

```powershell
opc 1          # usar cuenta principal
opc 2          # usar cuenta secundaria
opc --save=1   # guardar sesión actual como principal
opc --save=2   # guardar sesión actual como secundaria
```

La idea es simple:

- `1` = principal
- `2` = secundaria

Ejemplo de alta de cuenta secundaria:

1. Ejecutar:

```powershell
opc 2
```


2. Dentro de OpenCode hacer `/connect` y loguearte con la cuenta secundaria.
3. Cerrar OpenCode.
4. Guardar esa sesión:

```powershell
opc --save=2
```

---

## Recuperación después de formatear la PC

1. Instalar OpenCode.
2. Copiar este repo de dotfiles a `E:\config_pc\dotfiles`.
3. Crear la carpeta runtime si no existe:

```powershell
New-Item -ItemType Directory -Force -Path "$HOME\.local\share\opencode"
```

4. Restaurar los archivos auth desde tu backup seguro.

> **IMPORTANTE**: los `auth-*.json` contienen tokens reales. No deben publicarse ni subirse a un repo remoto público.

5. Ejecutar:

```powershell
opc 1
```

o

```powershell
opc 2
```

---

## Cargar en PowerShell profile

Agregar al profile algo como:

```powershell
. "E:\config_pc\dotfiles\powershell\opencode-aliases.ps1"
```

Con eso ya podés usar:

```powershell
opc 1
opc 2
opc --save=1
opc --save=2
```

---

## Nota

Esto no es soporte oficial de OpenCode para multi-login. Es un workaround práctico basado en que `/connect` guarda credenciales en:

```powershell
~/.local/share/opencode/auth.json
```

Y el cambio de cuenta se logra reemplazando ese archivo activo.
