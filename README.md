-----
## Features of This Fork

This fork builds on the excellent original script by adding several features:

  * **Smarter Downloads:** The script checks if the required driver files (`.cab`, `.msi`) already exist in the temporary folder. If they do, it skips the download, saving you time and bandwidth.
  * **Download Progress Bars:** See the status of your downloads in real-time. No more guessing if the script is frozen\!
  * **Interactive Restart Prompt:** Once the installation is complete, the script will actively ask if you want to restart your computer, which is recommended for the drivers to load correctly.
  * **Download Path Tracing:** The script now prints the exact temporary folder it's using, making it easy to trace files if needed.
-----

## Download / Installation

  - Open **PowerShell** (or Windows Terminal with PowerShell) as administrator.
  - Paste the following and press enter:
      
    ```powershell
     iex (Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/ymuuuu/Forked-Apple-Mobile-Drivers-Installer/refs/heads/main/AppleDrivInstaller.ps1')
    ```
  - A good minute and we're done, drivers installed\!


-----


## Acknowledgements

This script is a fork of the original **[Apple-Mobile-Drivers-Installer](https://github.com/NelloKudo/Apple-Mobile-Drivers-Installer)** created by **[NelloKudo](https://github.com/NelloKudo)**.

All credit for the core functionality and original concept goes to him.

-----
