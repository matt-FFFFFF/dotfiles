#
Get-PSRepository -Name PSGallery | Set-PSRepository -InstallationPolicy Trusted

Install-Module -Name PSReadLine -AllowPrerelease -Repository PSGallery
Install-Module -Name Terminal-Icons -Repository PSGallery
