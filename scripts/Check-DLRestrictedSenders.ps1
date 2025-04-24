Clear-Host
# Prompt the user to enter the name or alias of the Distribution List (DL)
$dl = Read-Host "Enter the name or alias of the distribution list (DL)"

# Fetch the DL object
$dlObject = Get-DistributionGroup -Identity $dl -ErrorAction SilentlyContinue

# Confirm the DL was found
if (-not $dlObject) {
    Write-Host "Distribution group '$dl' not found." -ForegroundColor Red
    return
}

# Initialize a collection to hold combined results for export
$exportData = @()

# --- PART 1: Users explicitly allowed to send messages ---
Write-Host "`n=== AcceptMessagesOnlyFrom ===`n" -ForegroundColor Cyan

$directSenders = $dlObject.AcceptMessagesOnlyFrom

if ($directSenders) {
    $resolvedDirect = $directSenders | Get-Recipient | Select Name, PrimarySmtpAddress, RecipientType

    # Display results
    $resolvedDirect | Format-Table -AutoSize

    # Add to export data
    $resolvedDirect | ForEach-Object {
        $exportData += [PSCustomObject]@{
            DLName           = $dl
            SenderType       = "AcceptMessagesOnlyFrom"
            Name             = $_.Name
            EmailAddress     = $_.PrimarySmtpAddress
            RecipientType    = $_.RecipientType
        }
    }
} else {
    Write-Host "No users are listed in AcceptMessagesOnlyFrom." -ForegroundColor Yellow
}

# --- PART 2: Groups or users allowed to send (SendersOrMembers) ---
Write-Host "`n=== AcceptMessagesOnlyFromSendersOrMembers ===`n" -ForegroundColor Cyan

$memberSenders = $dlObject.AcceptMessagesOnlyFromSendersOrMembers

if ($memberSenders) {
    $resolvedMembers = $memberSenders | Get-Recipient | Select Name, PrimarySmtpAddress, RecipientType

    # Display results
    $resolvedMembers | Format-Table -AutoSize

    # Add to export data
    $resolvedMembers | ForEach-Object {
        $exportData += [PSCustomObject]@{
            DLName           = $dl
            SenderType       = "AcceptMessagesOnlyFromSendersOrMembers"
            Name             = $_.Name
            EmailAddress     = $_.PrimarySmtpAddress
            RecipientType    = $_.RecipientType
        }
    }
} else {
    Write-Host "No users or groups are listed in AcceptMessagesOnlyFromSendersOrMembers." -ForegroundColor Yellow
}

# --- EXPORT SECTION ---
# Create a timestamp for the filename
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$filename = "$dl-allowed-senders-$timestamp.csv"

# Get current directory to save the file
$currentDir = Get-Location
$fullPath = Join-Path -Path $currentDir -ChildPath $filename

# Export to CSV
$exportData | Export-Csv -Path $fullPath -NoTypeInformation

Write-Host "`nExport completed. File saved to: $fullPath" -ForegroundColor Green
