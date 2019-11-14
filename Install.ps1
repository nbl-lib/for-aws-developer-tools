# Are you running in 32-bit mode?
#   (\SysWOW64\ = 32-bit mode)

if ($PSHOME -like "*SysWOW64*")
{
  Write-Warning "Restarting this script under 64-bit Windows PowerShell."

  # Restart this script under 64-bit Windows PowerShell.
  #   (\SysNative\ redirects to \System32\ for 64-bit mode)

  & (Join-Path ($PSHOME -replace "SysWOW64", "SysNative") powershell.exe) -File `
    (Join-Path $PSScriptRoot $MyInvocation.MyCommand) @args

  # Exit 32-bit script.

  Exit $LastExitCode
}

# Was restart successful?
Write-Warning "Hello from $PSHOME"
Write-Warning "  (\SysWOW64\ = 32-bit mode, \System32\ = 64-bit mode)"
Write-Warning "Original arguments (if any): $args"


# Create folder to publish binaries from drop folder
mkdir c:\website-published
Set-Location c:\website-published
delete *.*

# Switch to drop folder
Set-Location C:\website-dropfolder   

# Restore the nuget references
#& "C:\Program Files\dotnet\dotnet.exe" restore   

# Publish application with all of its dependencies and runtime for IIS to use
#& "C:\Program Files\dotnet\dotnet.exe" publish --configuration release -o c:\website-published   



# Create an IIS website and point it to the published folder
#New-WebSite -Name CoreWebsite -Port 80 -HostHeader CoreWebsite -PhysicalPath "$env:systemdrive\website-published"  
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; New-WebSite -Name CoreWebsite -Port 80 -HostHeader CoreWebsite -PhysicalPath "$env:systemdrive\website-published"}

# Create AppPool for website and set CLR version to core-dotnet
#New-WebAppPool CoreWebsiteAppPool  -ErrorAction SilentlyContinue
#Set-ItemProperty IIS:\\AppPools\CoreWebsiteAppPool managedRuntimeVersion "" -verbose  
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; New-WebAppPool CoreWebsiteAppPool}
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; Set-ItemProperty IIS:\\AppPools\CoreWebsiteAppPool managedRuntimeVersion "" -verbose}

# Set the app-pool of the website
#Set-ItemProperty 'IIS:\Sites\CoreWebsite' applicationPool CoreWebsiteAppPool
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command {Import-Module WebAdministration; Set-ItemProperty 'IIS:\Sites\CoreWebsite' applicationPool CoreWebsiteAppPool}

