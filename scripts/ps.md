**Exchange Online PowerShell module (EXO)** is outdated. Upgrading to **EXO V3.7**, which is optimized for better performance and security, especially on **Linux Mint (Ubuntu-based)** where WinRM is not used.

---

## **Steps to Upgrade Exchange Online PowerShell Module on Linux Mint**
Since you're on **Linux Mint**, you need **PowerShell Core (pwsh)** and the latest **ExchangeOnlineManagement** module. Follow these steps:

### **1️⃣ Check Your Current PowerShell Version**
Run this in **pwsh**:
```powershell
$PSVersionTable
```
- If your **PowerShell version is below 7.2**, update it.

### **2️⃣ Upgrade PowerShell Core (If Needed)**
- **Linux Mint (Ubuntu-based)**:
  ```bash
  sudo apt remove powershell -y
  sudo apt update && sudo apt upgrade -y
  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt update
  sudo apt install -y powershell
  pwsh
  ```

### **3️⃣ Remove the Old ExchangeOnlineManagement Module**
Open **PowerShell Core** (`pwsh`) and run:
```powershell
Remove-Module ExchangeOnlineManagement -ErrorAction SilentlyContinue
Uninstall-Module ExchangeOnlineManagement -AllVersions -Force
```

### **4️⃣ Install the Latest Exchange Online Module (V3.7)**
```powershell
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
```
> 🔹 If you get an error about **TLS 1.2**, run:
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

### **5️⃣ Verify Installation**
```powershell
Get-Module ExchangeOnlineManagement -ListAvailable
```
It should now show **Version 3.7** or newer.

### **6️⃣ Restart PowerShell & Connect to Exchange**
Close **pwsh**, reopen it, and try:
```powershell
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline
```

---

## **Why Upgrade to EXO V3.7?**
✅ No more **WinRM dependency**  
✅ Faster performance & **better memory handling**  
✅ Works better on **Linux & macOS**  
✅ **More secure** with REST API 
