# OmniStream Build and Run Script
# Run this from the Emby (OmniStream) source root on a machine with Visual Studio installed.

param(
    [string]$Configuration = "Release",
    [string]$Platform = "x64",
    [switch]$RunAfterBuild = $true,
    [switch]$AsService = $false
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

Write-Host "=== OmniStream Server Build Script ===" -ForegroundColor Cyan
Write-Host "Root: $root"

# Find VS using vswhere (installed with VS Installer)
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) {
    Write-Error "vswhere.exe not found. Install Visual Studio or the Build Tools."
    exit 1
}

$vsPath = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
if (-not $vsPath) {
    Write-Host "No Visual Studio installation with MSBuild found in this environment." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This shell (agent environment) only has the VS Installer, not a full Visual Studio edition with the Desktop development with C# workload." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "=== MANUAL BUILD INSTRUCTIONS (run on a machine with Visual Studio installed) ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. On your Windows machine, open a 'Developer Command Prompt for Visual Studio 2022' (or 2019) from the Start menu." -ForegroundColor White
    Write-Host "2. cd to your Emby/OmniStream source folder (e.g. D:\Emby)" -ForegroundColor White
    Write-Host "3. Run these commands:" -ForegroundColor White
    Write-Host ""
    Write-Host "   msbuild OmniStream.sln /t:Restore /p:Configuration=Release /p:Platform=x64 /v:minimal" -ForegroundColor Green
    Write-Host "   msbuild OmniStream.sln /p:Configuration=Release /p:Platform=x64 /v:minimal /m" -ForegroundColor Green
    Write-Host ""
    Write-Host "4. The server executable will be at:" -ForegroundColor White
    Write-Host "   MediaBrowser.ServerApplication\bin\x64\Release\MediaBrowser.ServerApplication.exe" -ForegroundColor Green
    Write-Host "   (or bin\Release\... depending on platform)"
    Write-Host ""
    Write-Host "5. To run:" -ForegroundColor White
    Write-Host "   .\MediaBrowser.ServerApplication\bin\x64\Release\MediaBrowser.ServerApplication.exe" -ForegroundColor Green
    Write-Host ""
    Write-Host "   Or with the script (once on full VS machine): .\build-omnistream.ps1" -ForegroundColor Green
    Write-Host ""
    Write-Host "Note: The binary will be branded as OmniStream Server (title, service, DLNA, UI strings, etc.)." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To install the required workload on a machine with VS Installer:" -ForegroundColor White
    Write-Host '   "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" modify --installPath "C:\Program Files\Microsoft Visual Studio\2022\Community" --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Component.NuGet --quiet' -ForegroundColor Gray
    Write-Host ""
    exit 1
}

$msbuild = Join-Path $vsPath "MSBuild\Current\Bin\MSBuild.exe"
if (-not (Test-Path $msbuild)) {
    $msbuild = Join-Path $vsPath "MSBuild\Current\Bin\amd64\MSBuild.exe"
}
if (-not (Test-Path $msbuild)) {
    Write-Error "MSBuild.exe not found in $vsPath"
    exit 1
}

Write-Host "Using MSBuild: $msbuild" -ForegroundColor Green

$solution = Join-Path $root "OmniStream.sln"
if (-not (Test-Path $solution)) {
    Write-Error "OmniStream.sln not found in $root"
    exit 1
}

Write-Host "Restoring NuGet packages..." -ForegroundColor Yellow
& $msbuild $solution /t:Restore /p:Configuration=$Configuration /p:Platform=$Platform /v:minimal

Write-Host "Building OmniStream solution ($Configuration|$Platform)..." -ForegroundColor Yellow
& $msbuild $solution /p:Configuration=$Configuration /p:Platform=$Platform /v:minimal /m

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

$exe = Join-Path $root "MediaBrowser.ServerApplication\bin\$Configuration\MediaBrowser.ServerApplication.exe"
if (-not (Test-Path $exe)) {
    # Try x64 subfolder (common for x64 platform)
    $exe = Join-Path $root "MediaBrowser.ServerApplication\bin\x64\$Configuration\MediaBrowser.ServerApplication.exe"
}
if (-not (Test-Path $exe)) {
    $exe = Join-Path $root "MediaBrowser.ServerApplication\bin\x64\$Configuration\MediaBrowser.ServerApplication.exe"
}

if (Test-Path $exe) {
    Write-Host "Build succeeded! Output: $exe" -ForegroundColor Green
    
    if ($RunAfterBuild) {
        Write-Host "Launching OmniStream Server..." -ForegroundColor Cyan
        $args = @()
        if ($AsService) { $args += "-service" }
        
        # Run detached 
        Start-Process -FilePath $exe -ArgumentList $args -WorkingDirectory (Split-Path $exe) 
        Write-Host "Server starting (check system tray icon or http://localhost:8096 or your LAN IP)." -ForegroundColor Green
        Write-Host "Branded as OmniStream Server throughout (UI, service, discovery, etc.)." -ForegroundColor Green
    }
} else {
    Write-Warning "Build reported success but exe not found at expected location. Check bin\ folders manually."
}

Write-Host "Done. For service install/uninstall: run the exe with -installservice or -uninstallservice (as admin)." -ForegroundColor Green
