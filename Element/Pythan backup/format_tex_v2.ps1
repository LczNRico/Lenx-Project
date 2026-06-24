# PowerShell script to format the .tex file - Version 2
# More comprehensive collapsing of simple functions

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_new.tex"

# Read the entire file
$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Processing file..."
Write-Host "Original length: $($content.Length) characters"

# Function to collapse simple function calls to one line
function Collapse-SimpleFunctions {
    param([string]$text)

    $iterations = 0
    $maxIterations = 10
    $changed = $true

    while ($changed -and $iterations -lt $maxIterations) {
        $iterations++
        $oldText = $text

        # Pattern for Segment with A and B on separate lines
        $text = $text -replace '(?ms)Segment\(\s+A\s*,\s+B\s+\)', 'Segment(A,B)'
        $text = $text -replace '(?ms)Segment\(\s*A\s*,\s*B\s*\)', 'Segment(A,B)'

        # Pattern for Sphere(A,α) with various whitespace
        $text = $text -replace '(?ms)Sphere\(\s+A\s*,\s+α\s+\)', 'Sphere(A,α)'
        $text = $text -replace '(?ms)Sphere\(\s*A\s*,\s*α\s*\)', 'Sphere(A,α)'

        # Pattern for Sphere(B,β) with various whitespace
        $text = $text -replace '(?ms)Sphere\(\s+B\s*,\s+β\s+\)', 'Sphere(B,β)'
        $text = $text -replace '(?ms)Sphere\(\s*B\s*,\s*β\s*\)', 'Sphere(B,β)'

        # Pattern for Ray(Light1,Light2) with various whitespace
        $text = $text -replace '(?ms)Ray\(\s+Light1\s*,\s+Light2\s+\)', 'Ray(Light1,Light2)'
        $text = $text -replace '(?ms)Ray\(\s*Light1\s*,\s*Light2\s*\)', 'Ray(Light1,Light2)'

        # Pattern for Plane with simple Ray inside
        $text = $text -replace '(?ms)Plane\(\s*B\s*,\s*Ray\(\s*Light1\s*,\s*Light2\s*\)\s*\)', 'Plane(B,Ray(Light1,Light2))'
        $text = $text -replace '(?ms)Plane\(\s*A\s*,\s*Ray\(\s*Light1\s*,\s*Light2\s*\)\s*\)', 'Plane(A,Ray(Light1,Light2))'

        # Pattern for IntersectConic with two Sphere calls
        $text = $text -replace '(?ms)IntersectConic\(\s*Sphere\(A,α\)\s*,\s*Sphere\(B,β\)\s*\)', 'IntersectConic(Sphere(A,α),Sphere(B,β))'

        # Pattern for Plane with IntersectConic inside
        $text = $text -replace '(?ms)Plane\(\s*IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\s*\)', 'Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'

        $changed = ($oldText -ne $text)
        if ($changed) {
            Write-Host "Iteration $iterations : Made changes"
        }
    }

    return $text
}

# Function to normalize indentation to 4 spaces
function Normalize-Indentation {
    param([string]$text)

    $lines = $text -split "`r?`n"
    $result = @()

    foreach ($line in $lines) {
        # Skip empty lines
        if ($line -match '^\s*$') {
            $result += ''
            continue
        }

        # Match leading whitespace and content
        if ($line -match '^(\s*)(.*)$') {
            $indent = $matches[1]
            $content = $matches[2]

            # Convert tabs to 4 spaces
            $indent = $indent -replace "`t", '    '

            # Count total spaces
            $spaceCount = $indent.Length

            # Determine indentation level (every 4 spaces = 1 level)
            # But preserve the exact indentation if it's a multiple of 4
            if ($spaceCount % 4 -eq 0) {
                $level = $spaceCount / 4
            } else {
                # Round to nearest multiple of 4
                $level = [Math]::Round($spaceCount / 4)
            }

            # Rebuild with normalized indentation
            $newIndent = '    ' * $level
            $result += $newIndent + $content
        } else {
            $result += $line
        }
    }

    return ($result -join "`n")
}

# Process the content
$processed = Collapse-SimpleFunctions $content
Write-Host "After collapse: $($processed.Length) characters"

$processed = Normalize-Indentation $processed
Write-Host "After normalization: $($processed.Length) characters"

# Write output
[System.IO.File]::WriteAllText($outputFile, $processed, [System.Text.Encoding]::UTF8)

Write-Host "Formatted file written to: $outputFile"
Write-Host "Done!"
