# ps-windows-hardening

Scripts de PowerShell para endurecer la seguridad de Windows. No es magia, es configurar bien lo que ya viene en el sistema operativo.

> Todos los scripts requieren ejecutarse como Administrador.

## ¿Por qué hardening?

Windows por defecto viene con un montón de servicios y configuraciones que hacen la vida más cómoda, pero también más fácil de atacar. Estos scripts los ajustan para reducir la superficie de ataque.

```
Superficie de ataque por defecto
         ↓
   firewall-rules.ps1   → Cierra puertos peligrosos
   disable-services.ps1 → Apaga servicios innecesarios
   audit-policy.ps1     → Activa registro de eventos
         ↓
Superficie de ataque reducida
```

## Scripts

### firewall-rules.ps1

Bloquea puertos que los atacantes adoran:

| Puerto | Protocolo | Riesgo |
|--------|-----------|--------|
| 445    | TCP       | SMB — vector principal de ransomware |
| 139    | TCP       | NetBIOS — información de red |
| 3389   | TCP       | RDP — fuerza bruta de contraseñas |
| 5985/6 | TCP       | WinRM — ejecución remota |
| 23     | TCP       | Telnet — credenciales en texto claro |

También activa el registro de paquetes descartados por el firewall.

**Uso:**
```powershell
# Ejecutar PowerShell como Administrador, luego:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\firewall-rules.ps1
```

---

### disable-services.ps1

Deshabilita servicios que no necesitas y que representan un riesgo:

- Telnet, SNMP, Registro Remoto — acceso externo innecesario
- UPnP / SSDP — descubrimiento de red, útil para atacantes
- Xbox Live services — si es un servidor, para qué los quieres
- DiagTrack — telemetría de Microsoft

**Uso:**
```powershell
.\disable-services.ps1
```

---

### audit-policy.ps1

Configura Windows para que registre en el Visor de Eventos:

- Inicios y cierres de sesión
- Cambios en cuentas de usuario
- Uso de privilegios elevados
- Cambios en políticas
- Comandos ejecutados en PowerShell/CMD

Además aumenta el tamaño del log de seguridad a **128MB** para que no se sobreescriba tan rápido.

**Ver los logs después:**
```powershell
Get-EventLog -LogName Security -Newest 50 | Format-Table -AutoSize
# O abrir: eventvwr.msc → Registros de Windows → Seguridad
```

---

## Cómo usarlo todo junto

```powershell
# Ejecutar PowerShell como Administrador
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

.\firewall-rules.ps1
.\disable-services.ps1
.\audit-policy.ps1
```

## Requisitos

- Windows 10 / 11 o Windows Server 2016+
- PowerShell 5.1 o superior
- Ejecutar como Administrador

## Advertencia

Revisar cada script antes de ejecutarlo en producción. El `disable-services.ps1` deshabilita servicios que en algunos entornos de dominio podrían ser necesarios.

## Licencia

MIT.
