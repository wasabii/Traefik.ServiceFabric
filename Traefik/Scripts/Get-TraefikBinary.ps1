﻿#
# Simple script to pull down the Traefik Binary for deployment. 
# Overwride URL to upgrade versions to new Binary
# 

param(
    [string]$version
)

while (!($version)) {
    Write-Host "Review current Traefik releases:" -foregroundcolor Green
    Write-Host "https://github.com/containous/traefik/releases"
    Write-Host "Please provide the release tag (e.g. 'v1.6.0-rc6' or 'v1.5.4') of the Traefik release you wish to download: " -foregroundcolor Green -NoNewline
    $version = Read-Host 
}

#Github and other sites now require tls1.2 without this line the script will fail with an SSL error. 
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

$traefikBaseUrl = "https://github.com/containous/traefik/releases/download/"
$url = $traefikBaseUrl + $version + "/traefik_windows-amd64.exe"

Write-Host "Downloading Traefik Binary from: " -foregroundcolor Green
Write-Host $url

$traefikPath = "/../ApplicationPackageRoot/Traefik/Code/traefik.exe"
$traefikTempPath = "/../ApplicationPackageRoot/Traefik/Code/traefik.exe.tmp"
$outFile = Join-Path $PSScriptRoot $traefikPath
$outTempFile = Join-Path $PSScriptRoot $traefikTempPath

Invoke-WebRequest -Uri $url -OutFile $outTempFile -UseBasicParsing
Move-Item $outTempFile $outFile -Force

Write-Host "Download complete, files:" -foregroundcolor Green
Write-Host $outfile

Write-Host "Traefik version downloaded:" -foregroundcolor Green

& $outfile version

