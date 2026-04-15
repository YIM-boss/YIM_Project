$baseDir = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6'
$manifestFile = Join-Path $baseDir '09 - Cognitive-Amplification-Framework-SHA256-FILE-MANIFEST.txt'
$archiveManifestFile = Join-Path $baseDir '10 - Cognitive-Amplification-Framework-SHA256-ARCHIVE-MANIFEST.txt'
$zipFile = Join-Path $baseDir '07 - Cognitive-Amplification-Framework-v1.6-ARCHIVE.zip'

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

Write-Host "=== Rebuilding ZIP ==="
if (Test-Path $zipFile) {
    Remove-Item $zipFile -Force
    Write-Host "  Old ZIP removed."
}

# Build list of full paths to compress
$zipPaths = New-Object System.Collections.Generic.List[string]
foreach ($rel in $contentFiles) {
    $fp = Join-Path $baseDir $rel
    if (Test-Path $fp) {
        $zipPaths.Add($fp)
    } else {
        Write-Host ("  WARN: " + $rel)
    }
}
foreach ($mf in $mediaFiles) {
    $fp = Join-Path $baseDir "media\$mf"
    if (Test-Path $fp) {
        $zipPaths.Add($fp)
    } else {
        Write-Host ("  WARN: media\" + $mf)
    }
}

Write-Host ("  Adding " + $zipPaths.Count + " files to ZIP...")
Compress-Archive -Path $zipPaths.ToArray() -DestinationPath $zipFile -CompressionLevel Optimal
$zipSize = (Get-Item $zipFile).Length
Write-Host ("  ZIP created: " + [math]::Round($zipSize/1MB, 1) + " MB  (" + $zipSize + " bytes)")

Write-Host ""
Write-Host "=== Writing ARCHIVE-MANIFEST ==="
$zipHash = (Get-FileHash -Path $zipFile -Algorithm SHA256).Hash
$ts2 = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$archiveContent = "Cognitive Amplification Framework -- SHA256 Archive Manifest`r`n"
$archiveContent += "Generated: $ts2`r`n"
$archiveContent += "======================================================================`r`n"
$archiveContent += $zipHash + "  07 - Cognitive-Amplification-Framework-v1.6-ARCHIVE.zip`r`n"
$archiveContent += "`r`nZIP file size: $zipSize bytes`r`n"
[System.IO.File]::WriteAllText($archiveManifestFile, $archiveContent, [System.Text.Encoding]::UTF8)
Write-Host ("  ZIP hash: " + $zipHash)
Write-Host ("  Written: " + $archiveManifestFile)

Write-Host ""
Write-Host "=== Done ==="
