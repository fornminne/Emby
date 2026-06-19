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
    Write-Error "No Visual Studio installation with MSBuild found. Please install Visual Studio 2019/2022 with 'Desktop development with C#' workload."
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
    # Try x64 subfolder sometimes used
    $exe = Join-Path $root "MediaBrowser.ServerApplication\bin\x64\$Configuration\MediaBrowser.ServerApplication.exe"
}

if (Test-Path $exe) {
    Write-Host "Build succeeded! Output: $exe" -ForegroundColor Green
    
    if ($RunAfterBuild) {
        Write-Host "Launching OmniStream Server..." -ForegroundColor Cyan
        $args = @()
        if ($AsService) { $args += "-service" }
        
        # Run detached or in new window
        Start-Process -FilePath $exe -ArgumentList $args -WorkingDirectory (Split-Path $exe) 
        Write-Host "Server starting (check tray icon or http://localhost:8096). Logs in program data."
    }
} else {
    Write-Warning "Build reported success but exe not found at expected location. Check bin\ folders."
}

Write-Host "Done. For service install: run the exe with -installservice as admin." -ForegroundColor Green
