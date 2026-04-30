# Fix standalone operators on their own lines

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_formatted.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"

$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Fixing standalone operators..."

# Fix < on its own line - merge with previous line
$content = $content -replace '(?m)\)\s*\r?\n\s*<\s*\r?\n\s*CircularArc\(', ')<CircularArc('

# Fix any remaining standalone < by joining with previous line
$lines = $content -split "`r?`n"
$result = @()
$skipNext = $false

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($skipNext) {
        $skipNext = $false
        continue
    }

    $line = $lines[$i]
    $trimmed = $line.Trim()

    # If this line is just "<" and next line exists
    if ($trimmed -eq '<' -and $i + 1 -lt $lines.Count) {
        # Append < to previous line
        if ($result.Count -gt 0) {
            $result[$result.Count - 1] += '<'
        }
        continue
    }

    $result += $line
}

$content = $result -join "`n"

Write-Host "Writing output..."
[System.IO.File]::WriteAllText($outputFile, $content, [System.Text.Encoding]::UTF8)

Write-Host "Done! File written to: $outputFile"

# Count lines
$lineCount = ($content -split "`n").Count
Write-Host "Total lines: $lineCount"
