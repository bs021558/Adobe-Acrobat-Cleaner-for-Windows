# Variables setting
$URL = @(
	"https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2100120135/x64/AdobeAcroCleaner_DC2021.exe"
	"https://www.adobe.com/devnet-docs/acrobatetk/tools/Labs/AcroCleaner_DC2015.zip"
)
$path = "C:\adobe_cleaner"
$paths = 1..2 | ForEach-Object { $path }
$exeFilePath = Join-Path $path "AdobeAcroCleaner_DC2021.exe"
$zipFilePath = Join-Path $path "AcroCleaner_DC2015.zip"
$extractedFilePath = Join-Path $path "AdobeAcroCleaner_DC2015.exe"

# Create path if it doesn't exist.
if (-not (Test-Path -Path $path)) {
    New-Item -Path $path -ItemType Directory
}

# Start downloading
$bitsJob = Start-BitsTransfer -Source $URL -Destination $paths -Asynchronous

# Wait for the completion
while ($bitsJob.JobState -ne "Transferred") {
    Start-Sleep -Seconds 1
}
Complete-BitsTransfer -BitsJob $bitsJob

# Unzip and wait
Expand-Archive $zipFilePath -DestinationPath $path

# Execute the first .exe file and wait for process exiting.
Start-Process $exeFilePath -ArgumentList "/silent" -Wait -Verb RunAs

# Execute the first .exe file and wait for process exiting.
$exeProcess = Start-Process $extractedFilePath -ArgumentList "/silent" -Wait -Verb RunAs
