$f = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6\03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md'
$text = [System.IO.File]::ReadAllText($f)

# Check apostrophe in "isn't" (Figure 5 area)
$idx5 = $text.IndexOf("630cb1e469ca8e129cb2479b14c780b7.png)")
$isnt_idx = $text.IndexOf("isn", $idx5)
$apos_char = $text[$isnt_idx+2]
Write-Host ("Apostrophe in isn't: " + ('{0:X4}' -f [int]$apos_char))

# Check what the Figure 5 alt text actually looks like (find em-dash position)
$altStart = $text.IndexOf("![Reference panel")
$altStr = ""
for ($i = $altStart; $i -lt $altStart+100; $i++) {
    $c = $text[$i]
    if ([int]$c -gt 0x7E) { $altStr += "[U+$('{0:X4}' -f [int]$c)]" } else { $altStr += $c }
}
Write-Host "Figure 5 alt start: $altStr"
