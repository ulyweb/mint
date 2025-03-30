**PowerShell module**, allowing you to reuse it with `Import-Module` and call functions easily.  

---

## **Steps to Convert the Script into a PowerShell Module**
1. **Create a Module Folder**  
   - Navigate to your PowerShell module directory:  
     - **Windows**: `C:\Users\$env:USERNAME\Documents\PowerShell\Modules\`  
     - **macOS/Linux**: `~/.local/share/powershell/Modules/`  
   - Create a new folder named **ExchangeUtils**  

2. **Save the Script as a `.psm1` Module**  
   - Inside `ExchangeUtils`, create a file named `ExchangeUtils.psm1`  
   - Copy and paste this script into `ExchangeUtils.psm1`:

```powershell
# ExchangeUtils.psm1 - PowerShell Module

# Function to Connect to Exchange Online
function Connect-Exchange {
    try {
        Write-Host "`nConnecting to Exchange Online..."
        Connect-ExchangeOnline -ErrorAction Stop
        Write-Host "Connected to Exchange Online!" -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to connect to Exchange Online - $_" -ForegroundColor Red
    }
}

# Function to Get Room Mailbox Creation Date
function Get-RoomCreationDate {
    param ([string]$roomMailbox)

    try {
        $mailbox = Get-Mailbox -Identity $roomMailbox -ErrorAction Stop
        $creationDate = (Get-MsolUser -UserPrincipalName $mailbox.PrimarySmtpAddress).WhenCreated
        Write-Host "`nRoom Created On: $creationDate" -ForegroundColor Cyan
    } catch {
        Write-Host "Error: Could not retrieve creation date for $roomMailbox" -ForegroundColor Red
    }
}

# Function to Get Permission Changes from Audit Logs
function Get-PermissionChanges {
    param ([string]$roomMailbox)

    try {
        $startDate = (Get-Date).AddDays(-30)
        $endDate = Get-Date
        $auditLogs = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -RecordType ExchangeAdmin `
            -Operations "Add-MailboxPermission", "Remove-MailboxPermission", "Set-MailboxFolderPermission" -ResultSize 1000 |
            Where-Object { $_.ObjectId -match $roomMailbox }

        if ($auditLogs) {
            Write-Host "`nPermission Changes:`n" -ForegroundColor Yellow
            $auditLogs | Format-Table -AutoSize
        } else {
            Write-Host "No permission changes found in the last 30 days for $roomMailbox." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error: Unable to retrieve permission changes for $roomMailbox" -ForegroundColor Red
    }
}

# Export functions so they are available when the module is imported
Export-ModuleMember -Function Connect-Exchange, Get-RoomCreationDate, Get-PermissionChanges
```

---

## **How to Use the Module**
1. **Open PowerShell**  
2. **Import the Module**  
   ```powershell
   Import-Module ExchangeUtils
   ```
3. **Verify It's Loaded**  
   ```powershell
   Get-Module ExchangeUtils
   ```
4. **Use the Functions**  
   - **Connect to Exchange Online**  
     ```powershell
     Connect-Exchange
     ```
   - **Get Room Creation Date**  
     ```powershell
     Get-RoomCreationDate -roomMailbox "room@example.com"
     ```
   - **Get Permission Changes**  
     ```powershell
     Get-PermissionChanges -roomMailbox "room@example.com"
     ```

---

## **Making the Module Permanent**
If you want this module to **always be available**, save it in one of these locations:
- **Windows:** `C:\Users\$env:USERNAME\Documents\PowerShell\Modules\ExchangeUtils\ExchangeUtils.psm1`  
- **macOS/Linux:** `~/.local/share/powershell/Modules/ExchangeUtils/ExchangeUtils.psm1`  

This allows PowerShell to load it automatically when using `Import-Module ExchangeUtils`.

---

### **Why This Is Useful**
✅ **Reusable** – Call functions anytime without rewriting scripts  
✅ **Modular** – Can be updated and expanded easily  
✅ **Cross-Platform** – Works on Windows, macOS, and Linux  
✅ **Professional** – Standard PowerShell module structure  

Now, you can just type `Import-Module ExchangeUtils` and start using the functions! 
