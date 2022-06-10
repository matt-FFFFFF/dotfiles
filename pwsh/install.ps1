#
Get-PSRepository -Name PSGallery | Set-PSRepository -InstallationPolicy Trusted

Install-Module -Name PSReadLine -AllowPrerelease -Repository PSGallery -Force -AllowClobber
Install-Module -Name Terminal-Icons -Repository PSGallery

$p = ". ~/.pwshprofile.ps1"

$p | Set-Content -Path $PROFILE
