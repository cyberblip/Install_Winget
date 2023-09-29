# Cleanup: Remove any resources from previous executions
if (Test-Path "Microsoft.VCLibs.x64.14.00.Desktop.appx") {
    Remove-Item -Path "Microsoft.VCLibs.x64.14.00.Desktop.appx" -Force
}
if (Test-Path "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle") {
    Remove-Item -Path "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -Force
}
if (Test-Path "microsoft.ui.xaml.2.7.3.zip") {
    Remove-Item -Path "microsoft.ui.xaml.2.7.3.zip" -Force
}
if (Test-Path ".\Nuget UI XAML") {
    Remove-Item -Path ".\Nuget UI XAML" -Recurse -Force
}

# Step 1: Download and install Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "Microsoft.VCLibs.x64.14.00.Desktop.appx"
if (-not (Test-Path "Microsoft.VCLibs.x64.14.00.Desktop.appx")) {
    throw "Failed to download Microsoft.VCLibs.x64.14.00.Desktop.appx"
}
Add-AppxPackage -Path ".\Microsoft.VCLibs.x64.14.00.Desktop.appx"

# Step 2: Download Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
if (-not (Test-Path "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle")) {
    throw "Failed to download Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
}
Add-AppxPackage -Path ".\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

# Step 3: Download microsoft.ui.xaml.2.7.3.nupkg
Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3" -OutFile "microsoft.ui.xaml.2.7.3.nupkg"
if (-not (Test-Path "microsoft.ui.xaml.2.7.3.nupkg")) {
    throw "Failed to download microsoft.ui.xaml.2.7.3.nupkg"
}

# Step 4: Rename and unzip the file
Rename-Item -Path "microsoft.ui.xaml.2.7.3.nupkg" -NewName "microsoft.ui.xaml.2.7.3.zip"
Expand-Archive -Path "microsoft.ui.xaml.2.7.3.zip" -DestinationPath ".\Nuget UI XAML"

# Step 5: Install the Microsoft.UI.Xaml.2.7.appx file
$unzippedPath = ".\Nuget UI XAML\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"
if (-not (Test-Path $unzippedPath)) {
    throw "Failed to find the unzipped Microsoft.UI.Xaml.2.7.appx file"
}
Add-AppxPackage -Path $unzippedPath

# Step 6: Execute get-appxpackage
Get-AppxPackage Microsoft.UI.Xaml.2.7 -AllUsers

# Step 7: Install the Microsoft.WinGet.Client module
Install-Module -Name Microsoft.WinGet.Client -Force -AllowClobber

# Step 8: Check if winget was successfully installed
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Output "Winget was successfully installed!"
} else {
    Write-Output "Winget installation failed!"
}

# Post-Execution Cleanup: Remove downloaded and extracted files
Remove-Item -Path "Microsoft.VCLibs.x64.14.00.Desktop.appx" -Force
Remove-Item -Path "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -Force
Remove-Item -Path "microsoft.ui.xaml.2.7.3.zip" -Force
Remove-Item -Path ".\Nuget UI XAML" -Recurse -Force
