$f = 'C:\YIM_Project\Cognitive Amplification Essay\v1.6\03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md'
$enc = [System.Text.Encoding]::UTF8
$bytes = [System.IO.File]::ReadAllBytes($f)
$text = $enc.GetString($bytes)

$apos = [char]0x2019
$emdash = [char]0x2014

# ===== FIX 1: Figure 3 - replace old GUID+alt-text block with correct named reference + caption =====
$fig3_old = "![Figure 3 " + $emdash + " the gap made visible only through dual-advisory amplification.](media/29735a180e81cf6795d60a4b782be584.png)"
$fig3_new = "![Figure 3](media/Cognitive-Amplification-Figure-3.png)`r`n`r`n**Figure 3. Discovery of Surface Compliance Across Two Advisory Platforms** The sixth syndrome emerged not from a single conversation, but from the gap between two sessions. Merlin helped map existing patterns. Perplexity helped identify what didn" + $apos + "t fit. The human carried the unresolved question across platforms. The instrument held enough context for the gap to become visible.`r`n`r`n"
if ($text.Contains($fig3_old)) {
    $text = $text.Replace($fig3_old, $fig3_new)
    Write-Host "OK: Figure 3 fixed"
} else {
    Write-Host "WARN: Figure 3 old string not found"
    # Debug
    $idx = $text.IndexOf("29735a180e81cf6795d60a4b782be584")
    if ($idx -ge 0) {
        $chunk = $text.Substring([Math]::Max(0,$idx-40), 80)
        $hvals = for ($j=[Math]::Max(0,$idx-5); $j -lt [Math]::Min($idx+5,$text.Length); $j++) { '{0:X4}' -f [int]$text[$j] }
        Write-Host ("  GUID found, chars before: " + ($hvals -join ' '))
    }
}

# ===== FIX 2: Insert Figure 5 between "Me." and "Authorship" =====
# Me.\r\n\r\nAuthorship (curly apos in "isn't" further in)
$fig5_anchor_old = "me. Me.`r`n`r`nAuthorship isn" + $apos + "t the physical act"
$fig5_caption = "**Figure 5. Selected Research Artifacts** The artifacts discussed in this essay" + $emdash + "diagnostic taxonomy, voice preservation, validation corpus, and proof of concept. The coordination infrastructure that made this possible (workspace ecosystem, cross-AI communication systems, session recovery mechanisms) exists but isn" + $apos + "t the focus here."
$fig5_anchor_new = "me. Me.`r`n`r`n![Figure 5](media/Cognitive-Amplification-Figure-5.png)`r`n`r`n" + $fig5_caption + "`r`n`r`nAuthorship isn" + $apos + "t the physical act"
if ($text.Contains($fig5_anchor_old)) {
    $text = $text.Replace($fig5_anchor_old, $fig5_anchor_new)
    Write-Host "OK: Figure 5 inserted after 'Me.'"
} else {
    Write-Host "WARN: Figure 5 insert anchor not found"
    $me_idx = $text.IndexOf("me. Me.")
    Write-Host ("  'me. Me.' found at: $me_idx")
}

# ===== FIX 3a: Replace Figure 5 GUID block with Figure 6 reference + caption =====
# Current: ![Reference panel...](media/630cb1e4...png)The progression isn't AI improving.
$fig6_old = "![Reference panel of YIM Project research artifacts produced through cognitive amplification: Core Six AI defensive behavior taxonomy, Ernesthification voice preservation system, IRR validation corpus, and proof-of-concept research output " + $emdash + " demonstrating the output of an independent practitioner working without institutional infrastructure.](media/630cb1e469ca8e129cb2479b14c780b7.png)The progression isn" + $apos + "t AI improving. It is human intent becoming more precisely articulable through iteration - which means more of what I actually meant has found its way onto the page."
$fig6_caption = "**Figure 6. Specification as Authorship** The practitioner" + $apos + "s unique specifications - drawn from lived experience with specific failure patterns, in specific sequences, under specific pressure - are what distinguish cognitive amplification output from generic AI babble. No two practitioners who have lived different things can specify the same work."
$fig6_new = "![Figure 6](media/Cognitive-Amplification-Figure-6.png)`r`n`r`n" + $fig6_caption + "`r`n`r`nThe progression isn" + $apos + "t AI improving. It is human intent becoming more precisely articulable through iteration - which means more of what I actually meant has found its way onto the page."
if ($text.Contains($fig6_old)) {
    $text = $text.Replace($fig6_old, $fig6_new)
    Write-Host "OK: Figure 6 block fixed (was Figure 5 GUID)"
} else {
    Write-Host "WARN: Figure 6 old block not found - trying GUID-only match"
    $guid_old = "630cb1e469ca8e129cb2479b14c780b7.png)The progression isn" + $apos + "t AI improving. It is human intent becoming more precisely articulable through iteration - which means more of what I actually meant has found its way onto the page."
    $idx30 = $text.IndexOf("630cb1e469ca8e129cb2479b14c780b7")
    if ($idx30 -ge 0) {
        $chunk2 = $text.Substring([Math]::Max(0,$idx30-10), 50)
        $hv2 = for ($j=$idx30-2; $j -lt $idx30+5; $j++) { '{0:X4}' -f [int]$text[$j] }
        Write-Host ("  GUID found, chars: " + ($hv2 -join ' '))
    }
}

# ===== FIX 3b: Remove Figure 6 straggler (orphaned alt text with old GUID) =====
# Current remaining: ![removed — in specific sequences...](media/a4a66d7d...png)
$fig6_straggler = "![removed " + $emdash + " in specific sequences, under specific pressure " + $emdash + " produces specifications no other practitioner could replicate, distinguishing cognitive amplification output from generic AI-generated content.](media/a4a66d7d79d13efa446fbdf7d8049fe3.png)"
if ($text.Contains($fig6_straggler)) {
    $text = $text.Replace($fig6_straggler, "")
    Write-Host "OK: Figure 6 straggler removed"
} else {
    Write-Host "WARN: Figure 6 straggler not found - trying GUID"
    $idx31 = $text.IndexOf("a4a66d7d79d13efa446fbdf7d8049fe3.png)")
    if ($idx31 -ge 0) {
        # Find the ![ before it
        $line_start = $text.LastIndexOf("![", $idx31)
        $line_end = $idx31 + "a4a66d7d79d13efa446fbdf7d8049fe3.png)".Length
        $straggler_actual = $text.Substring($line_start, $line_end - $line_start)
        Write-Host ("  Found straggler via GUID: " + $straggler_actual.Substring(0, [Math]::Min(60, $straggler_actual.Length)))
        $hv3 = for ($j = $line_start; $j -lt $line_start+10; $j++) { '{0:X4}' -f [int]$text[$j] }
        Write-Host ("  Hex: " + ($hv3 -join ' '))
        $text = $text.Remove($line_start, $line_end - $line_start)
        Write-Host "OK: Figure 6 straggler removed via GUID fallback"
    } else {
        Write-Host "WARN: a4a66d7d GUID not found - may already be removed"
    }
}

# ===== FIX 4: Remove orphaned Figure 8 image (GUID 7c5a0f3d) =====
$orphan8_guid = "![Tornado calligram visualizing the essay" + $apos + "s full version history: draft text spiraling inward from a wide funnel mouth to a single touchdown point, representing the iterative authorship process across multiple months " + $emdash + " the chaos of revision rendered as form rather than inventory, with every version present in the shape itself.](media/7c5a0f3d787be6cf9fbf2896db882613.png)"
if ($text.Contains($orphan8_guid)) {
    $text = $text.Replace($orphan8_guid, "")
    Write-Host "OK: Orphaned Figure 8 image removed"
} else {
    Write-Host "WARN: Orphaned Figure 8 exact string not found - trying GUID only"
    $idx32 = $text.IndexOf("7c5a0f3d787be6cf9fbf2896db882613.png)")
    if ($idx32 -ge 0) {
        $line_start2 = $text.LastIndexOf("![", $idx32)
        $line_end2 = $idx32 + "7c5a0f3d787be6cf9fbf2896db882613.png)".Length
        $text = $text.Remove($line_start2, $line_end2 - $line_start2)
        Write-Host "OK: Orphaned Figure 8 removed via GUID fallback"
    } else {
        Write-Host "WARN: 7c5a0f3d GUID not found in file"
    }
}

# ===== FIX 5: Remove duplicate "direct output" fragment (standalone incomplete sentence) =====
# The duplicate starts with "direct output" lowercase (not "is the direct output")
# It follows the orphaned image block above
$dup_para = "`r`n`r`ndirect output of this methodology at full scale. One researcher. No institution. No team. The correction trail in the companion verification appendix - every struck-through citation, every replaced number, every dated fix - is not a record of failure. That trail exists because the system worked."
if ($text.Contains($dup_para)) {
    $text = $text.Replace($dup_para, "")
    Write-Host "OK: Duplicate 'direct output' fragment removed"
} else {
    # Try LF version
    $dup_para_lf = "`n`ndirect output of this methodology at full scale. One researcher. No institution. No team. The correction trail in the companion verification appendix - every struck-through citation, every replaced number, every dated fix - is not a record of failure. That trail exists because the system worked."
    if ($text.Contains($dup_para_lf)) {
        $text = $text.Replace($dup_para_lf, "")
        Write-Host "OK: Duplicate fragment removed (LF variant)"
    } else {
        Write-Host "WARN: Duplicate 'direct output' not found - checking if already removed"
        $idx33 = $text.IndexOf("`r`ndirect output of this methodology")
        if ($idx33 -lt 0) { $idx33 = $text.IndexOf("`ndirect output of this methodology") }
        Write-Host ("  'direct output...' at index: $idx33")
    }
}

# ===== Verify remaining GUIDs =====
Write-Host ""
Write-Host "=== Remaining GUIDs check ==="
$guids = @("29735a180e", "630cb1e469", "a4a66d7d79", "7c5a0f3d78")
foreach ($g in $guids) {
    $idx = $text.IndexOf($g)
    if ($idx -ge 0) {
        Write-Host ("  STILL PRESENT: " + $g)
    } else {
        Write-Host ("  CLEAN: " + $g)
    }
}

# ===== Write file =====
$outBytes = $enc.GetPreamble() + $enc.GetBytes($text)
[System.IO.File]::WriteAllBytes($f, $outBytes)
Write-Host ""
Write-Host "File saved."
