Clear-host
#To more info to be listed use -filter properties listing using command below:
get-recipient "EmailAddressHERE!" -Filter * | fl *
#OR (get-recipient "EmailAddressHERE!" -Filter *) | fl *
(get-distributiongroup "DLGroupNameHERE!").AcceptMessagesOnlyFrom  | Get-Recipient | Select Alias, PrimarySmtpAddress, Title
(Get-RecipientPermission "Executive.Support").Trustee | Get-Recipient | Select Alias, PrimarySmtpAddress, Title
