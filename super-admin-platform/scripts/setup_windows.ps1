# One-time / after "flutter pub get" setup for Windows builds.
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$ToolsDir = Join-Path $Root "windows\tools"
$NugetExe = Join-Path $ToolsDir "nuget.exe"
$NugetUrl = "https://dist.nuget.org/win-x86-commandline/v5.10.0/nuget.exe"
$ExpectedHash = "852B71CC8C8C2D40D09EA49D321FF56FD2397B9D6EA9F96E532530307BBBAFD3"

New-Item -ItemType Directory -Force -Path $ToolsDir | Out-Null

if (-not (Test-Path $NugetExe)) {
    Write-Host "Downloading NuGet..."
    Invoke-WebRequest -Uri $NugetUrl -OutFile $NugetExe
}

$hash = (Get-FileHash $NugetExe -Algorithm SHA256).Hash
if ($hash -ne $ExpectedHash) {
    throw "NuGet integrity check failed."
}

# Patch webview_windows plugin CMake (CMP0175) after pub get.
$PluginCmake = Join-Path $Root "windows\flutter\ephemeral\.plugin_symlinks\webview_windows\windows\CMakeLists.txt"
if (Test-Path $PluginCmake) {
    $content = Get-Content $PluginCmake -Raw
    if ($content -notmatch "CMP0175") {
        $patch = @"
if(POLICY CMP0175)
  cmake_policy(SET CMP0175 OLD)
endif()

"@
        $content = $content -replace "(cmake_minimum_required\(VERSION 3\.15\)\r?\n)", "`$1$patch"
        Set-Content -Path $PluginCmake -Value $content -NoNewline
        Write-Host "Patched webview_windows CMakeLists.txt (CMP0175)."
    }
}

Write-Host "Windows setup complete. NuGet: $NugetExe"
