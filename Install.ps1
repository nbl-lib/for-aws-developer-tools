# Create folder to publish binaries from drop folder
mkdir c:\website-published

# Switch to drop folder
Set-Location C:\website-dropfolder   

# Restore the nuget references
& "C:\Program Files\dotnet\dotnet.exe" restore

# Publish application with all of its dependencies and runtime for IIS to use
& "C:\Program Files\dotnet\dotnet.exe" publish --configuration release -o c:\website-published --runtime active

# Create an IIS website and point it to the published folder
New-WebSite -Name CoreWebsite -Port 80 -HostHeader CoreWebsite -PhysicalPath "$env:systemdrive\website-published"

# Create AppPool for website and set CLR version to core-dotnet
New-WebAppPool CoreWebsiteAppPool
Set-ItemProperty IIS:\\AppPools\CoreWebsiteAppPool managedRuntimeVersion "" -verbose

# Point IIS wwwroot of the published folder. CodeDeploy uses 32 bit version of PowerShell.
# To make use the IIS PowerShell CmdLets we need call the 64 bit version of PowerShell.
##C:\Windows\SysNative\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; Set-ItemProperty 'IIS:\sites\Default Web Site' -Name physicalPath -Value c:\ExploringAspNetCore\publish}