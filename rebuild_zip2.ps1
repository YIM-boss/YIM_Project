$baseDir = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6'
$archiveManifestFile = Join-Path $baseDir '10 - Cognitive-Amplification-Framework-SHA256-ARCHIVE-MANIFEST.txt'
$zipFile = Join-Path $baseDir '07 - Cognitive-Amplification-Framework-v1.6-ARCHIVE.zip'
$tempDir = 'C:\YIM_Project\temp_zip_staging'

$contentFiles = @(
    '01 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.pdf',
    '02 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.docx',
    '03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md',
    '04 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6 AUDIT-TRAIL.pdf',
    '05 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6 AUDIT-TRAIL.docx',
    '06 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6 AUDIT-TRAIL.md',
    '08 - VERIFICATION-REPORT-v1.6.pdf',
    'README.md',
    '09 - Cognitive-Amplification-Framework-SHA256-FILE-MANIFEST.txt'
)

$mediaFiles = @(
    'Cognitive-Amplification-Cover-Image.png',
    'Cognitive-Amplification-Figure-1.jpeg',
    'Cognitive-Amplification-Figure-2.png',
    'Cognitive-Amplification-Figure-3.png',
    'Cognitive-Amplification-Figure-4.png',
    'Cognitive-Amplification-Figure-5.png',
    'Cognitive-Amplification-Figure-6.png',
    'Cognitive-Amplification-Figure-7.png',
    'Cognitive-Amplification-Figure-8.png',
    'Cognitive-Amplification-Figure-9.png'
)

# Setup temp staging folder
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir | Out-Null
New-Item -ItemType Directory -Path (Join-Path $tempDir 'media') | Out-Null

# Copy content files to temp root
foreach ($rel in $contentFiles) {
    $src = Join-Path $baseDir $rel
    $dst = Join-Path $tempDir $rel
    Copy-Item $src $dst
    Write-Host ("  Staged: " + $rel)
}

# Copy named media files to temp/media/
foreach ($mf in $mediaFiles) {
    $src = Join-Path $baseDir "media\$mf"
    $dst = Join-Path $tempDir "media\$mf"
    Copy-Item $src $dst
    Write-Host ("  Staged: media\" + $mf)
}

# Remove old ZIP
if (Test-Path $zipFile) { Remove-Item $zipFile -Force; Write-Host "  Old ZIP removed." }

# Compress staging folder
Write-Host "  Compressing..."
Compress-Archive -Path (Join-Path $tempDir '*') -DestinationPath $zipFile -CompressionLevel Optimal
$zipSize = (Get-Item $zipFile).Length
Write-Host ("  ZIP: " + [math]::Round($zipSize/1MB,1) + " MB  (" + $zipSize + " bytes)")

# Cleanup temp
Remove-Item $tempDir -Recurse -Force
Write-Host "  Temp staging cleaned up."

# Write ARCHIVE-MANIFEST
$zipHash = (Get-FileHash -Path $zipFile -Algorithm SHA256).Hash
$ts2 = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$archiveContent = "Cognitive Amplification Framework -- SHA256 Archive Manifest`r`n"
$archiveContent += "Generated: $ts2`r`n"
$archiveContent += "======================================================================`r`n"
$archiveContent += $zipHash + "  07 - Cognitive-Amplification-Framework-v1.6-ARCHIVE.zip`r`n"
$archiveContent += "`r`nZIP file size: $zipSize bytes`r`n"
[System.IO.File]::WriteAllText($archiveManifestFile, $archiveContent, [System.Text.Encoding]::UTF8)
Write-Host ("  ARCHIVE-MANIFEST written: " + $zipHash.Substring(0,16) + "...")

Write-Host ""
Write-Host "=== Done ==="
