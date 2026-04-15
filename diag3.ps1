$f = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6\03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md'
$text = [System.IO.File]::ReadAllText($f)

# Check apostrophe in "isn't" near "Authorship" paragraph
$auth_idx = $text.IndexOf("Authorship isn")
$apos_char = $text[$auth_idx + 14]  # 'A'=0,'u'=1,'t'=2,'h'=3,'o'=4,'r'=5,'s'=6,'h'=7,'i'=8,'p'=9,' '=10,'i'=11,'s'=12,'n'=13,"'"=14
Write-Host ("Apostrophe after 'isn' near Authorship: U+" + ('{0:X4}' -f [int]$apos_char))

# Check apostrophe in "isn't" near "Computer babble"
$babble_idx = $text.IndexOf("babble problem is a vacuum problem")
$fill_idx = $text.IndexOf("isn't AI improving", $babble_idx)
if ($fill_idx -ge 0) {
    $ap2 = $text[$fill_idx + 3]
    Write-Host ("Apostrophe in 'isn't AI improving': U+" + ('{0:X4}' -f [int]$ap2))
}

# Show the exact chars around "Me.\r\n" to confirm newline type
$me_idx = $text.IndexOf("Me.`r`nAuthorship")
if ($me_idx -ge 0) { Write-Host "Found Me. CRLF" } else {
    $me_idx = $text.IndexOf("Me.`nAuthorship")
    if ($me_idx -ge 0) { Write-Host "Found Me. LF" } else { Write-Host "Me. + Authorship NOT on adjacent lines" }
}
$me_idx2 = $text.IndexOf("Me.")
$chars = for ($j = $me_idx2; $j -lt $me_idx2+10; $j++) { '{0:X4}' -f [int]$text[$j] }
Write-Host ("After 'Me.': " + ($chars -join ' '))

# Check Figure 3 apostrophe in "isn't additive"
$f3_idx = $text.IndexOf("29735a180e81cf6795d60a4b782be584.png)")
$amp_idx = $text.IndexOf("amplification isn", $f3_idx)
if ($amp_idx -ge 0) {
    $ap3 = $text[$amp_idx + 17]
    Write-Host ("Apostrophe in 'amplification isn't': U+" + ('{0:X4}' -f [int]$ap3))
}

# Check the 630cb1e4 area - what exactly follows the png)
$f5_idx = $text.IndexOf("630cb1e469ca8e129cb2479b14c780b7.png)")
$chars5 = for ($j = $f5_idx+36; $j -lt $f5_idx+56; $j++) { '{0:X4}' -f [int]$text[$j] }
Write-Host ("Figure 5 GUID end: " + ($chars5 -join ' '))
