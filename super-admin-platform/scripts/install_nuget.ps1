# Installs NuGet CLI for Flutter Windows builds (webview_windows).
# Run once: powershell -ExecutionPolicy Bypass -File scripts\install_nuget.ps1

$ErrorActionPreference = "Stop"

$nugetDir = Join-Path $env:LOCALAPPDATA "Microsoft\NuGet"
$nugetExe = Join-Path $nugetDir "nuget.exe"
$nugetUrl = "https://dist.nuget.org/win-x86-commandline/v5.10.0/nuget.exe"
$expectedHash = "852b71cc8c8c2d40d09ea49d321ff56fd2397b9d6ea9f96e532530307bbbafd3"

Write-Host "Installing NuGet to $nugetDir ..."
New-Item -ItemType Directory -Force -Path $nugetDir | Out-Null

if (-not (Test-Path $nugetExe)) {
    Invoke-WebRequest -Uri $nugetUrl -OutFile $nugetExe -UseBasicParsing
}

$hash = (Get-FileHash -Path $nugetExe -Algorithm SHA256).Hash.ToLowerInvariant()
if ($hash -ne $expectedHash) {
    throw "NuGet integrity check failed. Expected $expectedHash but got $hash"
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$nugetDir*") {
    $newPath = if ([string]::IsNullOrWhiteSpace($userPath)) { $nugetDir } else { "$userPath;$nugetDir" }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added to User PATH."
} else {
    Write-Host "Already on User PATH."
}

$env:Path = "$env:Path;$nugetDir"
& $nugetExe help | Select-Object -First 1
Write-Host "Done. Restart terminal, then run: flutter run -d windows"
