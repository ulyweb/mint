#Here's the function script for it
## Here is a PowerShell function that prompts the user to enter the distribution group name (DL name), 
## lists all members with their names and primary SMTP addresses, and displays the total member count.
## This uses Read-Host for the prompt.
##
function Get-DLGroupMembers {
    $dlName = Read-Host -Prompt "Enter the distribution group name"
    $members = Get-DistributionGroupMember $dlName
    $members | Select-Object Name, PrimarySmtpAddress
    Write-Host "Total Members:" $($members.Count)
}

# To run the function, just type:
Get-DLGroupMembers
