#Requires -RunAsAdministrator
# disable-services.ps1 — Deshabilita servicios de Windows que son un riesgo de seguridad
# o que simplemente no necesitás en un entorno controlado

$ServiciosPeligrosos = @(
    @{ Name = "RemoteRegistry";   Display = "Registro remoto" },
    @{ Name = "Telnet";           Display = "Telnet" },
    @{ Name = "TlntSvr";         Display = "Servidor Telnet" },
    @{ Name = "SNMP";             Display = "SNMP" },
    @{ Name = "Browser";          Display = "Explorador de equipos" },
    @{ Name = "SSDPSRV";          Display = "Descubrimiento SSDP (UPnP)" },
    @{ Name = "upnphost";         Display = "Host UPnP" },
    @{ Name = "XboxGipSvc";       Display = "Xbox Accessory Management" },
    @{ Name = "XblAuthManager";   Display = "Xbox Live Auth Manager" },
    @{ Name = "XblGameSave";      Display = "Xbox Live Game Save" },
    @{ Name = "XboxNetApiSvc";    Display = "Xbox Live Networking" },
    @{ Name = "DiagTrack";        Display = "Telemetría de diagnóstico" }
)

foreach ($Svc in $ServiciosPeligrosos) {
    $s = Get-Service -Name $Svc.Name -ErrorAction SilentlyContinue
    if ($null -ne $s) {
        Stop-Service -Name $Svc.Name -Force -ErrorAction SilentlyContinue
        Set-Service -Name $Svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "[OK] Deshabilitado: $($Svc.Display)" -ForegroundColor Green
    } else {
        Write-Host "[--] No encontrado: $($Svc.Display)" -ForegroundColor DarkGray
    }
}

Write-Host "`n[*] Deshabilitación completada." -ForegroundColor Cyan
