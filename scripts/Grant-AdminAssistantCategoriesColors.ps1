# Clear
Clear-Host

function Set-CalendarOwnerPermission {
    [CmdletBinding()]
    param ()

    # Prompt for manager's UPN
    $managerUPN = Read-Host "Enter the manager's UPN (email address)"
    $calendarIdentity = $managerUPN+":\Calendar"

    # Display all current permissions for the calendar
    Write-Host "`nCurrent permissions for $calendarIdentity :`n" -ForegroundColor Cyan
    $currentPermissions = Get-MailboxFolderPermission -Identity $calendarIdentity | Where-Object { $_.User -notlike "Default" -and $_.User -notlike "Anonymous" }
    $currentPermissions | Format-Table FolderName, User, AccessRights, SharingPermissionFlags -AutoSize

    # Prompt for assistant admin's UPN
    $assistantAdminUPN = Read-Host "`nEnter the assistant admin's UPN (email address) to adjust permissions"

    # Display current permission for assistant admin
    $currentPermission = Get-MailboxFolderPermission -Identity $calendarIdentity -User $assistantAdminUPN -ErrorAction SilentlyContinue
    if ($null -eq $currentPermission) {
        Write-Host "`n$assistantAdminUPN has no existing permissions on $calendarIdentity." -ForegroundColor Yellow
        return
    } else {
        Write-Host "`nCurrent permission for $assistantAdminUPN :`n" -ForegroundColor Cyan
        $currentPermission | Format-Table FolderName, User, AccessRights, SharingPermissionFlags -AutoSize
    }

    # Confirm change (default to "no" if just Enter)
    $confirmation = Read-Host "`nAre you sure you want to set $assistantAdminUPN as Owner for category management? [yes/NO]"
    if ($confirmation -eq "yes") {
        Set-MailboxFolderPermission -Identity $calendarIdentity -User $assistantAdminUPN -AccessRights Owner

        # Display updated permission
        Write-Host "`nUpdated permission for $assistantAdminUPN :`n" -ForegroundColor Green
        Get-MailboxFolderPermission -Identity $calendarIdentity -User $assistantAdminUPN | Format-Table FolderName, User, AccessRights, SharingPermissionFlags -AutoSize
    } else {
        Write-Host "`nNo changes made." -ForegroundColor Yellow
    }
}
