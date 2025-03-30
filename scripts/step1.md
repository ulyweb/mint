Install-Module ExchangeOnlineManagement -Scope CurrentUser

Install-Module MSOnline -Scope CurrentUser 





new version
sudo apt remove powershell -y
sudo apt update && sudo apt upgrade -y
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y powershell
pwsh




Remove-Module ExchangeOnlineManagement -ErrorAction SilentlyContinue
Uninstall-Module ExchangeOnlineManagement -AllVersions -Force

Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Get-Module ExchangeOnlineManagement -ListAvailable
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline
