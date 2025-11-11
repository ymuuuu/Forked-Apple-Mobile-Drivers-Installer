## Apple USB and Mobile Device Ethernet drivers installer!
## Please report any issues at GitHub: https://github.com/NelloKudo/Apple-Mobile-Drivers-Installer

# --- MODIFICATION: Import BitsTransfer for progress bars ---
Import-Module BitsTransfer -ErrorAction SilentlyContinue

## Download links for Apple USB Drivers and Apple Mobile Ethernet USB Drivers respectively.
## All of these are downloaded from Microsoft's Update Catalog, which you can browse yourself at here: https://www.catalog.update.microsoft.com/

$AppleDri1 = "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2020/11/01d96dfd-2f6f-46f7-8bc3-fd82088996d2_a31ff7000e504855b3fa124bf27b3fe5bc4d0893.cab"
$AppleDri2 = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/11/netaapl_7503681835e08ce761c52858949731761e1fa5a1.cab"
$AppleITunesLink = "https://www.apple.com/itunes/download/win64"

Write-Host ""
Write-Host -ForegroundColor Cyan "Welcome to Apple USB and Mobile Device Ethernet drivers installer!!"
Write-Host ""

## Checking if the script is being run as admin..
if (-not ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544')) {
    Write-Host -ForegroundColor Yellow "This script requires administrative privileges!"
    Write-Host -ForegroundColor Yellow "Please run the script as an administrator if you want to install drivers."
    pause
    exit 1
}

## Preparing the system to actually download drivers..
$destinationFolder = [System.IO.Path]::Combine($env:TEMP, "AppleDriTemp")
if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

# --- MODIFICATION: Print download path for tracing ---
Write-Host "Temporary file location: $destinationFolder" -ForegroundColor Gray

try {
    $currentPath = $PWD.Path
    
    # --- MODIFICATION START: Smarter download logic for iTunes ---
    $iTunesInstallerPath = [System.IO.Path]::Combine($destinationFolder, "iTunes64Setup.exe")
    $amdsMsiPath = [System.IO.Path]::Combine($destinationFolder, "AppleMobileDeviceSupport64.msi")

    If (Test-Path $amdsMsiPath) {
        Write-Host "AppleMobileDeviceSupport64.msi already found. Skipping download and extraction." -ForegroundColor Green
    } Else {
        If (Test-Path $iTunesInstallerPath) {
            Write-Host "iTunes64Setup.exe found. Skipping download." -ForegroundColor Green
        } Else {
            Write-Host -ForegroundColor Yellow "Downloading Apple iTunes installer..."
            # --- MODIFICATION: Use Start-BitsTransfer for progress bar ---
            Start-BitsTransfer -Source $AppleITunesLink -Destination $iTunesInstallerPath -DisplayName "Downloading iTunes Installer"
        }
        
        Write-Host -ForegroundColor Yellow "Extracting AppleMobileDeviceSupport64.msi..."
        cd "$destinationFolder"
        Start-Process -FilePath $iTunesInstallerPath -ArgumentList "/extract" -Wait
        cd "$currentPath"
    }
    # --- MODIFICATION END ---

    Write-Host -ForegroundColor Yellow "Installing AppleMobileDeviceSupport64.msi..."
    Start-Process -FilePath $amdsMsiPath -ArgumentList "/qn" -Wait

    # --- MODIFICATION START: Define paths and check before downloading CAB files ---
    Write-Host -ForegroundColor Yellow "Checking for Apple USB and Mobile Device Ethernet drivers..."
    $usbDriPath = [System.IO.Path]::Combine($destinationFolder, "AppleUSB-486.0.0.0-driv.cab")
    $netDriPath = [System.IO.Path]::Combine($destinationFolder, "AppleNet-1.8.5.1-driv.cab")

    If (Test-Path $usbDriPath) {
        Write-Host "AppleUSB driver (AppleUSB-486.0.0.0-driv.cab) found. Skipping download." -ForegroundColor Green
    } Else {
        Write-Host "Downloading AppleUSB driver..."
        # --- MODIFICATION: Use Start-BitsTransfer for progress bar ---
        Start-BitsTransfer -Source $AppleDri1 -Destination $usbDriPath -DisplayName "Downloading AppleUSB Driver"
    }
    
    If (Test-Path $netDriPath) {
        Write-Host "AppleNet driver (AppleNet-1.8.5.1-driv.cab) found. Skipping download." -ForegroundColor Green
    } Else {
        Write-Host "Downloading AppleNet driver..."
        # --- MODIFICATION: Use Start-BitsTransfer for progress bar ---
        Start-BitsTransfer -Source $AppleDri2 -Destination $netDriPath -DisplayName "Downloading AppleNet Driver"
    }
    # --- MODIFICATION END ---

    Write-Host -ForegroundColor Yellow "Extracting drivers..."
    & expand.exe -F:* $usbDriPath "$destinationFolder" >$null 2>&1
    & expand.exe -F:* $netDriPath "$destinationFolder" >$null 2>&1

    ## Installing drivers..
    Write-Host -ForegroundColor Yellow "Installing Apple USB and Mobile Device Ethernet drivers!"
    Write-Host -ForegroundColor Yellow "If any of your peripherals stop working for a few seconds that's due to Apple stuff installing."
    Write-Host ""
    Get-ChildItem -Path "$destinationFolder\*.inf" | ForEach-Object {
        pnputil /add-driver $_.FullName /install
        Write-Host ""
        Write-Host -ForegroundColor Yellow "Driver installed.."
        Write-Host ""
    }

    ## Cleaning..
    Remove-Item -Path $destinationFolder -Recurse -Force

} catch {
    Write-Host -ForegroundColor Red "Failed to complete installation. Error: $_"
}

Write-Host ""
Write-Host -ForegroundColor Cyan "Installation complete! Enjoy your Apple devices!!"

# --- MODIFICATION START: Add restart prompt ---
Write-Host -ForegroundColor Yellow "A restart is recommended to ensure all drivers are loaded correctly."
try {
    $choice = Read-Host "Do you want to restart now? (Y/N)"

    If ($choice -match '^[Yy]$') {
        Write-Host "Restarting computer..."
        Restart-Computer -Force
    } Else {
        Write-Host "Restart skipped. Please restart your computer manually later."
    }
} catch {
    Write-Host -ForegroundColor Red "Failed to read input. Please restart manually."
}
# --- MODIFICATION END ---
