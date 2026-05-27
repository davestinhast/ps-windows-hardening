#Requires -RunAsAdministrator
# firewall-rules.ps1 — Reglas de firewall defensivas para Windows
# Bloquea puertos peligrosos y habilita solo lo necesario

Write-Host "[*] Aplicando reglas de firewall..." -ForegroundColor Cyan

# Bloquear puertos SMB (ransomware los ama)
New-NetFirewallRule -DisplayName "Bloquear SMB Entrada" `
    -Direction Inbound -Protocol TCP -LocalPort 445 `
    -Action Block -Profile Any -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "Bloquear NetBIOS Entrada" `
    -Direction Inbound -Protocol TCP -LocalPort 139 `
    -Action Block -Profile Any -ErrorAction SilentlyContinue

# Bloquear RDP desde redes públicas
New-NetFirewallRule -DisplayName "Bloquear RDP Publico" `
    -Direction Inbound -Protocol TCP -LocalPort 3389 `
    -Action Block -Profile Public -ErrorAction SilentlyContinue

# Bloquear WinRM externo (ejecución remota)
New-NetFirewallRule -DisplayName "Bloquear WinRM Externo" `
    -Direction Inbound -Protocol TCP -LocalPort 5985,5986 `
    -Action Block -Profile Public -ErrorAction SilentlyContinue

# Bloquear telnet
New-NetFirewallRule -DisplayName "Bloquear Telnet" `
    -Direction Inbound -Protocol TCP -LocalPort 23 `
    -Action Block -Profile Any -ErrorAction SilentlyContinue

# Habilitar registro de paquetes descartados
Set-NetFirewallProfile -Profile Domain,Public,Private `
    -LogBlocked True -LogMaxSizeKilobytes 4096 `
    -LogFileName "$env:SystemRoot\system32\LogFiles\Firewall\pfirewall.log"

Write-Host "[OK] Reglas de firewall aplicadas." -ForegroundColor Green
