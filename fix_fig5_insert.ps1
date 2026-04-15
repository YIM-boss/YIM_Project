$f = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6\03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md'
$enc = [System.Text.Encoding]::UTF8
$bytes = [System.IO.File]::ReadAllBytes($f)
$text = $enc.GetString($bytes)

$apos = [char]0x2019
$emdash = [char]0x2014

# The paragraph before "Me." ends with "Not the VS Code agent."
# Then: blank line, "Me.", blank line, "Authorship isn't..."
$anchor_old = "Not the VS Code agent.`r`n`r`nMe.`r`n`r`nAuthorship isn" + $apos + "t the physical act"
$fig5_caption = "**Figure 5. Selected Research Artifacts** The artifacts discussed in this essay" + $emdash + "diagnostic taxonomy, voice preservation, validation corpus, and proof of concept. The coordination infrastructure that made this possible (workspace ecosystem, cross-AI communication systems, session recovery mechanisms) exists but isn" + $apos + "t the focus here."
$anchor_new = "Not the VS Code agent.`r`n`r`nMe.`r`n`r`n![Figure 5](media/Cognitive-Amplification-Figure-5.png)`r`n`r`n" + $fig5_caption + "`r`n`r`nAuthorship isn" + $apos + "t the physical act"

if ($text.Contains($anchor_old)) {
    $text = $text.Replace($anchor_old, $anchor_new)
    Write-Host "OK: Figure 5 inserted after 'Me.'"
} else {
    Write-Host "WARN: anchor not found - checking text..."
    $idx = $text.IndexOf("VS Code agent.")
    if ($idx -ge 0) {
        $chunk = $text.Substring($idx, 60)
        $hvals = for ($j = $idx+14; $j -lt $idx+20; $j++) { '{0:X4}' -f [int]$text[$j] }
        Write-Host ("  After 'VS Code agent.': " + ($hvals -join ' '))
        Write-Host ("  Text snippet: " + $chunk.Substring(0, [Math]::Min(50, $chunk.Length)))
    }
}

# Verify Figure 5 is now present
if ($text.Contains("Cognitive-Amplification-Figure-5.png")) {
    Write-Host "CONFIRMED: Figure 5 named path present in file"
} else {
    Write-Host "WARN: Figure 5 named path NOT found"
}

$outBytes = $enc.GetPreamble() + $enc.GetBytes($text)
[System.IO.File]::WriteAllBytes($f, $outBytes)
Write-Host "File saved."
