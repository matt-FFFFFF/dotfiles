# Install powershell
brew install powershell

# Install modules using ps1 script
pwsh -File $(dirname $0)/install.ps1

# Update pwsh profile, dot sourcing the file in home dir
