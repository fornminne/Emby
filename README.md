OmniStream Server (personal fork)
=================================

**OmniStream** — Personal Media Server

This is a personal branded fork / own version of the open source Emby Server.

**Project:** [fornminne/Emby](https://github.com/fornminne/Emby) (branded as OmniStream)

Original upstream: [MediaBrowser/Emby](https://github.com/MediaBrowser/Emby)

---

OmniStream Server is a personal media server (branded fork of Emby Server) with apps on just about every device.

It features a REST-based API with built-in documention to facilitate client development. We also have client libraries for our API to enable rapid development.

## Emby Apps

- [Android Mobile (Play Store)](https://play.google.com/store/apps/details?id=com.mb.android "Android Mobile (Play Store)")
- [Android Mobile (Amazon)](http://www.amazon.com/Emby-for-Android/dp/B00GVH9O0I "Android Mobile (Amazon)")
- [Android TV](https://play.google.com/store/apps/details?id=tv.emby.embyatv "Android TV")
- [Amazon Fire TV](http://www.amazon.com/Emby-for-Fire-TV/dp/B00VVJKTW8 "Amazon Fire TV")
- [HTML5](http://app.emby.media "HTML5")
- [iPad](https://itunes.apple.com/us/app/emby/id992180193?ls=1&mt=8 "iPad")
- [iPhone](https://itunes.apple.com/us/app/emby/id992180193?ls=1&mt=8 "iPhone")
- [Kodi](http://emby.media/download/ "Kodi")
- [Media Portal](http://www.team-mediaportal.com/ "Media Portal")
- [Roku](https://www.roku.com/channels#!details/44191/emby "Roku")
- [Windows Desktop](http://emby.media/download/ "Windows Desktop")
- [Windows Media Center](http://emby.media/download/ "Windows Media Center")
- [Windows Phone](http://www.windowsphone.com/s?appid=f4971ed9-f651-4bf6-84bb-94fd98613b86 "Windows Phone")
- [Windows 8](http://apps.microsoft.com/windows/en-us/app/media-browser/ad55a2f0-9897-47bd-8944-bed3aefd5d06 "Windows 8.1")

## New Users ##

If you're a new user looking to install OmniStream Server, see the releases or build from source.

> Note: This is a personal fork and may include custom builds or modifications. Original project at emby.media. Use at your own discretion.

## Developer Info ##

[Api Docs](https://github.com/MediaBrowser/MediaBrowser/wiki "Api Workflow")

[How to Build a Server Plugin](https://github.com/MediaBrowser/MediaBrowser/wiki/How-to-build-a-Server-Plugin "How to build a server plugin")

## Building OmniStream Server (from source) ##

This is a legacy Visual Studio 2017-era solution (C# .NET 4.7 + netstandard).

**On a Windows machine with Visual Studio 2022/2019:**

1. Open `OmniStream.sln` in Visual Studio.
2. Restore NuGet packages (right-click solution > Restore NuGet Packages). The `/packages` folder has many pre-placed.
3. Set configuration to Release | x64 (or AnyCPU).
4. Build the solution or specifically the `MediaBrowser.ServerApplication` project.
5. The output exe will be in `MediaBrowser.ServerApplication\bin\Release\MediaBrowser.ServerApplication.exe` (title will show as OmniStream).
6. Run it; it should start the web UI on the default port (8096).

**Notes:**
- Some ThirdParty/emby/*.dll are prebuilt closed components from the era.
- For Linux/Mac, look at MediaBrowser.Server.Mono project (requires Mono or .NET Core porting work).
- Expect some updates/retargeting for modern VS/.NET Framework SDK.
- After build, you can rename the exe or use a launcher script for "OmniStream.exe".

For the Android shim / companion, see the separate OmniStream Android project (in your workspace under AI/omnistream).

## Quick Compile + Run (one-liner)

On a Windows dev machine with Visual Studio 2019/2022 + "Desktop development with C#" workload:

```powershell
cd D:\Emby
.\build-omnistream.ps1
```

This will:
- Auto-detect MSBuild from your VS install
- Restore NuGet + build Release x64 as **OmniStream**
- Launch the server (system tray icon + web UI at http://localhost:8096 or your LAN IP)

To build only (no launch): `.\build-omnistream.ps1 -RunAfterBuild:$false`

The resulting executable, service name, DLNA/UPnP discovery, loading messages, web dashboard, shortcuts, etc. are all branded **OmniStream Server**.

**If the script says "No Visual Studio installation with MSBuild found"** (common in limited shells/agents), follow the manual steps it prints, or:

Open a **"Developer Command Prompt for Visual Studio"** and run:

```cmd
cd D:\Emby
msbuild OmniStream.sln /t:Restore /p:Configuration=Release /p:Platform=x64 /v:minimal
msbuild OmniStream.sln /p:Configuration=Release /p:Platform=x64 /v:minimal /m
```

Then run the exe at `MediaBrowser.ServerApplication\bin\x64\Release\MediaBrowser.ServerApplication.exe` (it will brand as OmniStream).

See the full script for more options (service mode, etc.).

## Android Companion App

The companion "OmniStream" Android server shim (Ktor-based Emby-compatible API + web UI, in `D:\AI\omnistream`) has a pre-built APK at:

`D:\AI\omnistream\app\build\outputs\apk\debug\app-debug.apk`

To rebuild it (requires Android SDK + compatible JDK in JAVA_HOME, usually 11/17):

```powershell
cd D:\AI\omnistream
.\gradlew.bat assembleDebug
```

Install the APK on an Android device/emulator to run a lightweight OmniStream server that Emby clients can connect to.

## Visit our community: ##


## Visit our community: ##

http://emby.media/community

## Images

![Android](https://dl.dropboxusercontent.com/u/4038856/android1.png)
![Android](https://dl.dropboxusercontent.com/u/4038856/android2.png)
![Html5](https://github.com/MediaBrowser/MediaBrowser.Resources/raw/master/apps/html5.png)
![iOS](https://github.com/MediaBrowser/MediaBrowser.Resources/raw/master/apps/ios_1.jpg)
![iOS](https://raw.github.com/MediaBrowser/MediaBrowser.Resources/master/apps/ios_2.jpg)
![Emby Theater](https://raw.github.com/MediaBrowser/MediaBrowser.Resources/master/apps/mbt.png)
![Emby Theater](https://raw.github.com/MediaBrowser/MediaBrowser.Resources/master/apps/mbt1.png)
![Windows Phone](https://raw.github.com/MediaBrowser/MediaBrowser.Resources/master/apps/winphone.png)
![Roku](https://raw.github.com/MediaBrowser/MediaBrowser.Resources/master/apps/roku2.jpg)
![iOS](https://raw.github.com/MediaBrowser/MediaBrowser.Resources/master/apps/ios_3.jpg)
![Dashboard](https://raw.github.com/MediaBrowser/MediaBrowser.Resources/master/apps/dashboard.png)
![iOS](http://i.imgur.com/prrzxMc.jpg)
![iOS](http://i.imgur.com/c9Vd1w5.jpg)

