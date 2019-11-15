#stop  the website
Stop-WebSite -Name "CoreWebsite"

#remove old files
Remove-Item C:\website-published -Recurse -ErrorAction Ignore

#Start the website once clean up done
Start-WebSite -Name "CoreWebsite"