#Here's the function script for it
## Here is a PowerShell function that prompts the user to enter the distribution group name (DL name), 
## lists all members with their names and primary SMTP addresses, and displays the total member count.
## This uses Read-Host for the prompt.
##
function Get-DLGroupMembersAMOFDLM {
    $dlName = Read-Host -Prompt "Enter the distribution group name"
    $DLgroup = Get-DistributionGroup $dlName
    $DLgroup.AcceptMessagesOnlyFromDLMembers | ForEach-Object { Get-Recipient $_ | Select DisplayName, AcceptMessagesOnlyFromDLMembers }
}
# To Run the function, just type:
Get-DLGroupMembersAMOFDLM
