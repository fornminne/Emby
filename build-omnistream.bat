@echo off
echo === OmniStream Build Launcher ===
echo This will try to find and use MSBuild from Visual Studio.
echo If it fails, please open "Developer Command Prompt for Visual Studio 2022" manually.
echo.

setlocal

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

if not exist "%VSWHERE%" (
  echo ERROR: vswhere.exe not found. Please install Visual Studio.
  pause
  exit /b 1
)

for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do (
  set "VSINSTALL=%%i"
)

if not defined VSINSTALL (
  echo ERROR: No Visual Studio with MSBuild found.
  echo Please open "Visual Studio Installer", Modify your VS 2022 install, and add the "Desktop development with C#" workload.
  echo Then re-run this or open the Developer Command Prompt.
  pause
  exit /b 1
)

set "MSBUILD=%VSINSTALL%\MSBuild\Current\Bin\MSBuild.exe"
if not exist "%MSBUILD%" set "MSBUILD=%VSINSTALL%\MSBuild\Current\Bin\amd64\MSBuild.exe"

echo Using MSBuild: %MSBUILD%

echo.
echo Restoring packages...
"%MSBUILD%" OmniStream.sln /t:Restore /p:Configuration=Release /p:Platform=x64 /v:minimal

echo.
echo Building...
"%MSBUILD%" OmniStream.sln /p:Configuration=Release /p:Platform=x64 /v:minimal /m

if %ERRORLEVEL% neq 0 (
  echo Build failed.
  pause
  exit /b %ERRORLEVEL%
)

echo.
echo Build succeeded!
echo The OmniStream server is at:
echo MediaBrowser.ServerApplication\bin\x64\Release\MediaBrowser.ServerApplication.exe
echo.
echo To run it: start the exe above.
echo (It will appear as OmniStream Server)
pause
