Add-Type -AssemblyName System.IO.Compression.FileSystem

$baseDir = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6'
$manifestFile = Join-Path $baseDir '09 - Cognitive-Amplification-Framework-SHA256-FILE-MANIFEST.txt'
$archiveManifestFile = Join-Path $baseDir '10 - Cognitive-Amplification-Framework-SHA256-ARCHIVE-MANIFEST.txt'
$zipFile = Join-Path $baseDir '07 - Cognitive-Amplification-Framework-v1.6-ARCHIVE.zip'

# === Content files to hash (relative paths from baseDir) ===
$contentFiles = @(
    '01 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.pdf',
    '02 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.docx',
    '03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md',
    '04 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6 AUDIT-TRAIL.pdf',
    '05 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6 AUDIT-TRAIL.docx',
    '06 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6 AUDIT-TRAIL.md',
    '08 - VERIFICATION-REPORT-v1.6.pdf',
    'README.md',
    'media\Cognitive-Amplification-Cover-Image.png',
    'media\Cognitive-Amplification-Figure-1.jpeg',
    'media\Cognitive-Amplification-Figure-2.png',
    'media\Cognitive-Amplification-Figure-3.png',
    'media\Cognitive-Amplification-Figure-4.png',
    'media\Cognitive-Amplification-Figure-5.png',
    'media\Cognitive-Amplification-Figure-6.png',
    'media\Cognitive-Amplification-Figure-7.png',
    'media\Cognitive-Amplification-Figure-8.png',
    'media\Cognitive-Amplification-Figure-9.png'
)

# === STEP 1: Hash content files ===
Write-Host "=== Step 1: Hashing content files ==="
$hashes = [System.Collections.Specialized.OrderedDictionary]::new()
foreach ($rel in $contentFiles) {
    $fullPath = Join-Path $baseDir $rel
    if (Test-Path $fullPath) {
        $hash = (Get-FileHash -Path $fullPath -Algorithm SHA256).Hash
        $hashes[$rel] = $hash
        Write-Host ("  OK: " + $hash.Substring(0,16) + "...  " + $rel)
    } else {
        Write-Host ("  WARN: NOT FOUND: " + $rel)
    }
}

# === STEP 2: Write FILE-MANIFEST ===
Write-Host ""
Write-Host "=== Step 2: Writing FILE-MANIFEST ==="
$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$sb = New-Object System.Text.StringBuilder
$null = $sb.AppendLine("Cognitive Amplification Framework -- SHA256 File Manifest")
$null = $sb.AppendLine("Generated: $ts")
$null = $sb.AppendLine("======================================================================")
foreach ($rel in $hashes.Keys) {
    $displayRel = $rel -replace '\\', '/'
    $null = $sb.AppendLine($hashes[$rel] + "  " + $displayRel)
}
[System.IO.File]::WriteAllText($manifestFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host ("  Written: " + $manifestFile)

# === STEP 3: Rebuild ZIP ===
Write-Host ""
Write-Host "=== Step 3: Rebuilding ZIP ==="
if (Test-Path $zipFile) {
    Remove-Item $zipFile -Force
    Write-Host "  Old ZIP removed."
}

$zipStream = [System.IO.File]::Open($zipFile, [System.IO.FileMode]::Create)
$archive = New-Object System.IO.Compression.ZipArchive($zipStream, [System.IO.Compression.ZipArchiveMode]::Create)

# Add content files
foreach ($rel in $contentFiles) {
    $fullPath = Join-Path $baseDir $rel
    if (Test-Path $fullPath) {
        $entryName = $rel -replace '\\', '/'
        $entry = $archive.CreateEntry($entryName, [System.IO.Compression.CompressionLevel]::Optimal)
        $entryStream = $entry.Open()
        $fileStream = [System.IO.File]::OpenRead($fullPath)
        $fileStream.CopyTo($entryStream)
        $fileStream.Close()
        $entryStream.Close()
        Write-Host ("  Added: " + $entryName)
    }
}

# Add FILE-MANIFEST to ZIP
$manifestRel = '09 - Cognitive-Amplification-Framework-SHA256-FILE-MANIFEST.txt'
$manifestEntry = $archive.CreateEntry($manifestRel, [System.IO.Compression.CompressionLevel]::Optimal)
$mEntryStream = $manifestEntry.Open()
$mFileStream = [System.IO.File]::OpenRead($manifestFile)
$mFileStream.CopyTo($mEntryStream)
$mFileStream.Close()
$mEntryStream.Close()
Write-Host ("  Added: " + $manifestRel)

$archive.Dispose()
$zipStream.Close()

$zipSize = (Get-Item $zipFile).Length
Write-Host ("  ZIP created: " + [math]::Round($zipSize/1MB, 1) + " MB")

# === STEP 4: Hash ZIP and write ARCHIVE-MANIFEST ===
Write-Host ""
Write-Host "=== Step 4: Writing ARCHIVE-MANIFEST ==="
$zipHash = (Get-FileHash -Path $zipFile -Algorithm SHA256).Hash
$ts2 = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$archiveContent = "Cognitive Amplification Framework -- SHA256 Archive Manifest`r`n"
$archiveContent += "Generated: $ts2`r`n"
$archiveContent += "======================================================================`r`n"
$archiveContent += $zipHash + "  07 - Cognitive-Amplification-Framework-v1.6-ARCHIVE.zip`r`n"
$archiveContent += "`r`nZIP file size: $zipSize bytes`r`n"
[System.IO.File]::WriteAllText($archiveManifestFile, $archiveContent, [System.Text.Encoding]::UTF8)
Write-Host ("  ZIP hash: " + $zipHash.Substring(0,16) + "...")
Write-Host ("  Written: " + $archiveManifestFile)

Write-Host ""
Write-Host "=== Done ==="
