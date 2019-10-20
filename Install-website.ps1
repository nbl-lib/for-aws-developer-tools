# Create folder to publish binaries from drop folder
mkdir c:\website-published

# Switch to drop folder
Set-Location C:\website-dropfolder   

# Create an IIS website and point it to the published folder
New-WebSite -Name CoreWebsite -Port 80 -HostHeader CoreWebsite -PhysicalPath "$env:systemdrive\website-published"  -ErrorAction SilentlyContinue

# Create AppPool for website and set CLR version to core-dotnet
New-WebAppPool CoreWebsiteAppPool  -ErrorAction SilentlyContinue
Set-ItemProperty IIS:\\AppPools\CoreWebsiteAppPool managedRuntimeVersion "" -verbose  -ErrorAction SilentlyContinue


# Point IIS wwwroot of the published folder. CodeDeploy uses 32 bit version of PowerShell.
# To make use the IIS PowerShell CmdLets we need call the 64 bit version of PowerShell.
##C:\Windows\SysNative\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; Set-ItemProperty 'IIS:\sites\Default Web Site' -Name physicalPath -Value c:\ExploringAspNetCore\publish}