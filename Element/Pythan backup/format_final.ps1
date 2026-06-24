# Final formatting script - collapse simple functions only, keep structure intact
# Read original file and process it carefully

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_formatted.tex"

# Read the entire file
$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Processing file..."
Write-Host "Original size: $($content.Length) characters"

# Multiple passes to collapse simple functions
for ($pass = 1; $pass -le 15; $pass++) {
    $oldLen = $content.Length

    # Collapse Sphere(A,α) - handle newlines and whitespace
    $content = $content -creplace '(?s)Sphere\s*\(\s*A\s*,\s*α\s*\)', 'Sphere(A,α)'

    # Collapse Sphere(B,β)
    $content = $content -creplace '(?s)Sphere\s*\(\s*B\s*,\s*β\s*\)', 'Sphere(B,β)'

    # Collapse Segment(A,B)
    $content = $content -creplace '(?s)Segment\s*\(\s*A\s*,\s*B\s*\)', 'Segment(A,B)'

    # Collapse Ray(Light1,Light2)
    $content = $content -creplace '(?s)Ray\s*\(\s*Light1\s*,\s*Light2\s*\)', 'Ray(Light1,Light2)'

    # Collapse IntersectConic(Sphere(A,α),Sphere(B,β))
    $content = $content -creplace '(?s)IntersectConic\s*\(\s*Sphere\(A,α\)\s*,\s*Sphere\(B,β\)\s*\)', 'IntersectConic(Sphere(A,α),Sphere(B,β))'

    # Collapse Plane(IntersectConic(...))
    $content = $content -creplace '(?s)Plane\s*\(\s*IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\s*\)', 'Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'

    # Collapse Plane(B,Ray(...))
    $content = $content -creplace '(?s)Plane\s*\(\s*B\s*,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(B,Ray(Light1,Light2))'

    # Collapse Plane(A,Ray(...))
    $content = $content -creplace '(?s)Plane\s*\(\s*A\s*,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(A,Ray(Light1,Light2))'

    if ($content.Length -eq $oldLen) {
        Write-Host "Pass $pass : No changes"
        break
    } else {
        Write-Host "Pass $pass : Saved $($oldLen - $content.Length) characters"
    }
}

Write-Host "After collapsing: $($content.Length) characters"

# Now fix indentation - normalize to 4 spaces per level
$lines = $content -split "`r?`n"
$normalized = @()

foreach ($line in $lines) {
    if ($line.Trim() -eq '') {
        continue
    }

    # Match indentation
    if ($line -match '^(\s*)(.+)$') {
        $spaces = $matches[1]
        $text = $matches[2]

        # Convert tabs to 4 spaces
        $spaces = $spaces -replace "`t", '    '

        # Calculate indent level
        $level = [Math]::Round($spaces.Length / 4.0)

        # Rebuild line
        $newIndent = '    ' * $level
        $normalized += $newIndent + $text
    }
}

$content = $normalized -join "`n"

Write-Host "After normalization: $($content.Length) characters"

# Write output
[System.IO.File]::WriteAllText($outputFile, $content, [System.Text.Encoding]::UTF8)

Write-Host "`nFile written to: $outputFile"
Write-Host "Done!"

# Count lines
$lineCount = ($content -split "`n").Count
Write-Host "Total lines: $lineCount"
