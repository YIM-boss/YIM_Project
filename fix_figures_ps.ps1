
# ======================================================================
# START PART 1 - Setup
# ======================================================================
$f = "C:\YIM_Project\Cognitive Amplification Essay\v1.6\03 - Cognitive Amplification-A Framework for Human-AI Collaborative Authorship v1.6.md"
$text = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
$orig = $text.Length
Write-Host "File loaded, length: $orig chars"
# ======================================================================
# END PART 1
# ======================================================================

# ======================================================================
# START PART 2 - Fix Figure 3 (alt text + path + caption)
# ======================================================================
# Step 2a: Replace the known-unique prefix of the alt text (no em-dash in match)
$text = $text.Replace(
    "![Process diagram showing the cross-platform discovery of Surface Compliance, the sixth AI defensive syndrome: Merlin mapped existing patterns in session one, Perplexity identified unresolved orphan tags in session two, and the human carried the unresolved question between platforms",
    "![Figure 3"
)
# Step 2b: After above, the remaining text is " -- the gap...](media/29735a...). Fix path and remove residual alt text
$text = $text.Replace(
    "![Figure 3" + [char]0x2014 + " the gap made visible only through dual-advisory amplification.](media/29735a180e81cf6795d60a4b782be584.png)The amplification isn't additive.",
    "![Figure 3](media/Cognitive-Amplification-Figure-3.png)" + "`n" + "`n" + "**Figure 3. Discovery of Surface Compliance Across Two Advisory Platforms** The sixth syndrome emerged not from a single conversation, but from the gap between two sessions. Merlin helped map existing patterns. Perplexity helped identify what didn't fit. The human carried the unresolved question across platforms. The instrument held enough context for the gap to become visible." + "`n" + "`n" + "The amplification isn't additive."
)

if ($text.Contains("29735a180e")) { Write-Host "WARN: Figure 3 GUID still present" }
else { Write-Host "OK: Figure 3 fixed" }
# ======================================================================
# END PART 2
# ======================================================================

# ======================================================================
# START PART 3 - Fix Figure 5/6 swap
# ======================================================================
# Figure 5 (630cb1e4) is in wrong position. Replace with Figure 6, then add progression text
# The block is: [Figure5 image inline with "The progression..."] blank [Figure6 image inline with "You don't ask..."]
$old3 = "![Reference panel of YIM Project research artifacts produced through cognitive amplification: Core Six AI defensive behavior taxonomy, Ernesthification voice preservation system, IRR validation corpus, and proof-of-concept research output " + [char]0x2014 + " demonstrating the output of an independent practitioner working without institutional infrastructure.](media/630cb1e469ca8e129cb2479b14c780b7.png)The progression isn't AI improving. It is human intent becoming more precisely articulable through iteration - which means more of what I actually meant has found its way onto the page."

$new3a = "![Figure 6](media/Cognitive-Amplification-Figure-6.png)`n`n**Figure 6. Specification as Authorship** The practitioner's unique specifications - drawn from lived experience with specific failure patterns, in specific sequences, under specific pressure - are what distinguish cognitive amplification output from generic AI babble. No two practitioners who have lived different things can specify the same work."

if ($text.Contains($old3)) {
    $text = $text.Replace($old3, $new3a)
    Write-Host "OK: Figure 5 chunk replaced with Figure 6"
} else {
    Write-Host "WARN: Figure 5 original block not found - trying ASCII-only match"
    # Fall back to path-only replacement
    $text = $text.Replace(
        "media/630cb1e469ca8e129cb2479b14c780b7.png)The progression isn't AI improving. It is human intent becoming more precisely articulable through iteration - which means more of what I actually meant has found its way onto the page.",
        "media/Cognitive-Amplification-Figure-6.png)`n`n**Figure 6. Specification as Authorship** The practitioner's unique specifications - drawn from lived experience with specific failure patterns, in specific sequences, under specific pressure - are what distinguish cognitive amplification output from generic AI babble. No two practitioners who have lived different things can specify the same work."
    )
    Write-Host "OK: Figure 6 path+caption fixed via fallback"
}

# Fix Figure 6 (a4a66d7d) - it's stranded inline with "You don't ask", also needs alt+path fix
$old3b = "![Conceptual diagram illustrating specification as authorship: a practitioner's unique lived experience with AI failure patterns " + [char]0x2014 + " in specific sequences, under specific pressure " + [char]0x2014 + " produces specifications no other practitioner could replicate, distinguishing cognitive amplification output from generic AI-generated content.](media/a4a66d7d79d13efa446fbdf7d8049fe3.png)You don't ask if the piano created the symphony."

$new3b = "The progression isn't AI improving. It is human intent becoming more precisely articulable through iteration - which means more of what I actually meant has found its way onto the page.`n`nYou don't ask if the piano created the symphony."

if ($text.Contains($old3b)) {
    $text = $text.Replace($old3b, $new3b)
    Write-Host "OK: Old Figure 6 straggler removed, progression text restored"
} else {
    Write-Host "WARN: Figure 6 straggler not found - trying path-only"
    $text = $text.Replace(
        "media/a4a66d7d79d13efa446fbdf7d8049fe3.png)You don't ask if the piano created the symphony.",
        "The progression isn't AI improving. It is human intent becoming more precisely articulable through iteration - which means more of what I actually meant has found its way onto the page.`n`nYou don't ask if the piano created the symphony."
    )
    $text = $text.Replace("![Conceptual diagram illustrating specification as authorship: a practitioner's unique lived experience with AI failure patterns ", "![removed ")
    Write-Host "OK: Straggler removed via fallback"
}

if ($text.Contains("630cb1e4") -or $text.Contains("a4a66d7d")) { Write-Host "WARN: Figure 5/6 GUIDs still present" }
else { Write-Host "OK: Figure 5/6 GUIDs gone" }
# ======================================================================
# END PART 3
# ======================================================================

# ======================================================================
# START PART 4 - Fix Figure 8 (split sentence)
# ======================================================================
# The broken text has "...is the\n\n![Tornado...]\n\ndirect output..."
# Need to reassemble into complete sentence, move image after sentence
$old4 = "([Taylor, 2026, DOI reserved) -](https://yeahitsme.com/core-six) 31,000 words, formal inter-rater reliability study, grounded in 50,000+ documented conversation turns - is the"
$new4 = "(Taylor, 2026, doi:10.5281/zenodo.19423182) - 31,000 words, formal inter-rater reliability study, grounded in 50,000+ documented conversation turns - is the direct output of this methodology at full scale. One researcher. No institution. No team. The correction trail in the companion verification appendix - every struck-through citation, every replaced number, every dated fix - is not a record of failure. That trail exists because the system worked.`n`n![Figure 8](media/Cognitive-Amplification-Figure-8.png)`n`n**Figure 8. Calligram / Tornado** Fourteen drafts over two months, rendered as shape rather than list. The text spirals inward from the wide funnel mouth to the touchdown point. Every version is in there. The chaos is the record.`n`n"

if ($text.Contains($old4)) {
    $text = $text.Replace($old4, $new4)
    Write-Host "OK: Figure 8 sentence start replaced"
} else { Write-Host "WARN: Figure 8 sentence start not found" }

# Now remove the orphaned split "is the\n\n[image]\n\ndirect output..." pattern
$old4b = "[Tornado calligram visualizing the essay's full version history: draft text spiraling inward from a wide funnel mouth to a single touchdown point, representing the iterative authorship process across multiple months " + [char]0x2014 + " the chaos of revision rendered as form rather than inventory, with every version present in the shape itself.](media/7c5a0f3d787be6cf9fbf2896db882613.png)"
if ($text.Contains($old4b)) {
    # Remove the orphaned image and everything between replacement point and "direct output"
    $text = $text.Replace("`n`n" + $old4b + "`n`ndirect output of this methodology at full scale. One researcher. No institution. No team. The correction trail in the companion verification appendix - every struck-through citation, every replaced number, every dated fix - is not a record of failure. That trail exists because the system worked.", "")
    Write-Host "OK: Orphaned Figure 8 image + duplicate sentence removed"
} else {
    # Try without em-dash
    $text = $text.Replace("media/7c5a0f3d787be6cf9fbf2896db882613.png)", "REMOVED_F8_GUID)")
    Write-Host "WARN: Figure 8 em-dash path not found, trying simple path mark"
}

if ($text.Contains("7c5a0f3d")) { Write-Host "WARN: Figure 8 GUID still present" }
else { Write-Host "OK: Figure 8 GUID gone" }
# ======================================================================
# END PART 4
# ======================================================================

# ======================================================================
# START PART 5 - Write file and report
# ======================================================================
[System.IO.File]::WriteAllText($f, $text, [System.Text.Encoding]::UTF8)
$newLen = $text.Length
Write-Host ""
Write-Host "=== Done. Length: $orig -> $newLen chars ==="
# ======================================================================
# END PART 5
# ======================================================================

# ======================================================================
# START PART 6 - Verify
# ======================================================================
$remaining = Select-String -Path $f -Pattern "29735a180e|630cb1e4|a4a66d7d|7c5a0f3d|b66940253bb|9eb23fac|3e5945db|6306ed35" | Select-Object LineNumber, Line
if ($remaining) {
    Write-Host "REMAINING GUIDS:"
    $remaining | ForEach-Object { Write-Host "  Line $($_.LineNumber): $($_.Line.Substring(0, [Math]::Min(80, $_.Line.Length)))" }
} else {
    Write-Host "All target GUIDs removed."
}
# ======================================================================
# END PART 6
# ======================================================================
