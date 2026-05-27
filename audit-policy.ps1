#Requires -RunAsAdministrator
# audit-policy.ps1 — Configura políticas de auditoría para detectar accesos sospechosos
# Registra inicios de sesión, cambios de privilegios y acceso a objetos

Write-Host "[*] Configurando políticas de auditoría..." -ForegroundColor Cyan

$Politicas = @(
    "Logon",
    "Logoff",
    "Account Logon",
    "Account Management",
    "Privilege Use",
    "Object Access",
    "Policy Change",
    "System"
)

foreach ($Politica in $Politicas) {
    $resultado = auditpol /set /subcategory:"$Politica" /success:enable /failure:enable 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Auditoría habilitada: $Politica" -ForegroundColor Green
    } else {
        Write-Host "[WARN] No se pudo configurar: $Politica" -ForegroundColor Yellow
    }
}

# Aumentar tamaño de logs de seguridad a 128MB
wevtutil sl Security /ms:134217728
Write-Host "[OK] Log de seguridad configurado a 128MB." -ForegroundColor Green

# Habilitar auditoría de línea de comandos (detecta PowerShell malicioso)
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
New-Item -Path $RegPath -Force | Out-Null
Set-ItemProperty -Path $RegPath -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1
Write-Host "[OK] Auditoría de línea de comandos habilitada." -ForegroundColor Green

Write-Host "`n[*] Política de auditoría configurada." -ForegroundColor Cyan
