$f = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6\03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md'
$text = [System.IO.File]::ReadAllText($f)

# Check Figure 3 space issue: what follows "![Figure 3"
$idx3 = $text.IndexOf("![Figure 3")
$chars3 = ""
for ($i = $idx3+10; $i -lt $idx3+20; $i++) { $chars3 += ('{0:X4}' -f [int]$text[$i]) + " " }
Write-Host "After Figure 3 bracket: $chars3"

# Check Figure 5 - what immediately follows the GUID path end
$idx5 = $text.IndexOf("630cb1e469ca8e129cb2479b14c780b7.png)")
$chars5 = ""
for ($i = $idx5+37; $i -lt $idx5+45; $i++) { $chars5 += ('{0:X4}' -f [int]$text[$i]) + " " }
Write-Host "After Figure5 GUID end ('+'.png)'): $chars5"

# Check Figure 8 - what's around the GUID
$idx8 = $text.IndexOf("7c5a0f3d787be6cf9fbf2896db882613.png)")
$chars8pre = ""
for ($i = $idx8-5; $i -lt $idx8; $i++) { $chars8pre += ('{0:X4}' -f [int]$text[$i]) + " " }
$chars8post = ""
for ($i = $idx8+37; $i -lt $idx8+45; $i++) { $chars8post += ('{0:X4}' -f [int]$text[$i]) + " " }
Write-Host "Before Figure8 GUID: $chars8pre"
Write-Host "After Figure8 GUID end: $chars8post"
