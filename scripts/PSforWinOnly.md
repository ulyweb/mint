Script to include a **dropdown menu (ComboBox)**, so you can select the function you want to execute instead of using separate buttons.  

---

### **Features of the Updated Script**
✅ **Dropdown menu (ComboBox) to select functions**  
✅ **Single "Run" button to execute the selected function**  
✅ **GUI-based for easy selection**  
✅ **Professional-looking, with clean layout**  

---

### **Full PowerShell Script**
```powershell
# Import Required Modules
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to Connect to Exchange Online
function Connect-Exchange {
    try {
        Write-Host "Connecting to Exchange Online..."
        Connect-ExchangeOnline -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("Connected to Exchange Online", "Connection Status", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to connect: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Function to Get Room Mailbox Creation Date
function Get-RoomCreationDate {
    param ([string]$roomMailbox)

    try {
        $mailbox = Get-Mailbox -Identity $roomMailbox -ErrorAction Stop
        $creationDate = (Get-MsolUser -UserPrincipalName $mailbox.PrimarySmtpAddress).WhenCreated
        $outputBox.Text = "Room Created On: $creationDate"
    } catch {
        $outputBox.Text = "Error: Could not retrieve creation date."
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
            $outputBox.Text = "Permission Changes:`r`n" + ($auditLogs | Out-String)
        } else {
            $outputBox.Text = "No permission changes found in the last 30 days."
        }
    } catch {
        $outputBox.Text = "Error: Unable to retrieve permission changes."
    }
}

# Create GUI Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Exchange Online Room Info"
$form.Size = New-Object System.Drawing.Size(500,400)
$form.StartPosition = "CenterScreen"

# Create Label for Room Mailbox
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter Room Mailbox:"
$label.Location = New-Object System.Drawing.Point(20,20)
$label.AutoSize = $true
$form.Controls.Add($label)

# Create Textbox for Room Mailbox Input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(150,20)
$textBox.Size = New-Object System.Drawing.Size(250,20)
$form.Controls.Add($textBox)

# Create Dropdown Menu for Function Selection
$menuLabel = New-Object System.Windows.Forms.Label
$menuLabel.Text = "Select Action:"
$menuLabel.Location = New-Object System.Drawing.Point(20,60)
$menuLabel.AutoSize = $true
$form.Controls.Add($menuLabel)

$menuBox = New-Object System.Windows.Forms.ComboBox
$menuBox.Location = New-Object System.Drawing.Point(150,60)
$menuBox.Size = New-Object System.Drawing.Size(250,20)
$menuBox.Items.Add("Connect to Exchange")
$menuBox.Items.Add("Get Room Creation Date")
$menuBox.Items.Add("Get Permission Changes")
$menuBox.SelectedIndex = 0  # Default selection
$form.Controls.Add($menuBox)

# Create Output Box
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(20,150)
$outputBox.Size = New-Object System.Drawing.Size(440,150)
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$form.Controls.Add($outputBox)

# Create "Run" Button
$runButton = New-Object System.Windows.Forms.Button
$runButton.Text = "Run"
$runButton.Location = New-Object System.Drawing.Point(150,100)

# Define Action for "Run" Button
$runButton.Add_Click({
    $selectedFunction = $menuBox.SelectedItem
    $roomMailbox = $textBox.Text

    switch ($selectedFunction) {
        "Connect to Exchange" {
            Connect-Exchange
        }
        "Get Room Creation Date" {
            if ($roomMailbox -ne "") {
                Get-RoomCreationDate -roomMailbox $roomMailbox
            } else {
                $outputBox.Text = "Please enter a Room Mailbox."
            }
        }
        "Get Permission Changes" {
            if ($roomMailbox -ne "") {
                Get-PermissionChanges -roomMailbox $roomMailbox
            } else {
                $outputBox.Text = "Please enter a Room Mailbox."
            }
        }
    }
})

$form.Controls.Add($runButton)

# Run the Form
$form.ShowDialog()
```

---

### **How to Use**
1. **Run PowerShell as Administrator**  
2. Copy and paste the script into PowerShell  
3. The GUI will launch  
4. **Enter the Room Mailbox Name**  
5. **Select an option from the dropdown menu**:  
   - 🔹 "Connect to Exchange" → Logs into Exchange Online  
   - 🔹 "Get Room Creation Date" → Fetches when the room was created  
   - 🔹 "Get Permission Changes" → Shows audit logs for permission changes  
6. Click **"Run"** to execute the selected function  

---

### **Why This is Better**
✔️ **Dropdown menu makes it easy to choose actions**  
✔️ **Only one button needed (cleaner design)**  
✔️ **Works with Exchange Online, MSOL, and Unified Audit Logs**  
✔️ **Error handling included**  

