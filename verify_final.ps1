$f = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6\03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md'
$lines = [System.IO.File]::ReadAllLines($f)

Write-Host "=== All figure references in file ==="
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match "Figure|GUID|media/") {
        Write-Host ("Line " + ($i+1) + ": " + $line.Substring(0, [Math]::Min(120, $line.Length)))
    }
}

Write-Host ""
Write-Host "=== GUID check ==="
$guids = @("29735a180e", "630cb1e469", "a4a66d7d79", "7c5a0f3d78")
$text = [System.IO.File]::ReadAllText($f)
foreach ($g in $guids) {
    if ($text.Contains($g)) { Write-Host "  STILL PRESENT: $g" } else { Write-Host "  CLEAN: $g" }
}
