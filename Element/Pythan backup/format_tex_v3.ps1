# PowerShell script to format the .tex file - Version 3
# Fix remaining issues with Plane(IntersectConic(...)) structures

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_new.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_v3.tex"

# Read the file
$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Processing file from previous output..."
Write-Host "Original length: $($content.Length) characters"

# Aggressive multi-pass collapsing
$iterations = 0
$maxIterations = 30
$changed = $true

while ($changed -and $iterations -lt $maxIterations) {
    $iterations++
    $oldLength = $content.Length

    # Collapse ALL Sphere(A,α) - very aggressive with (?s) for multiline
    $content = $content -replace '(?s)Sphere\s*\(\s*A\s*,\s*α\s*\)', 'Sphere(A,α)'

    # Collapse ALL Sphere(B,β)
    $content = $content -replace '(?s)Sphere\s*\(\s*B\s*,\s*β\s*\)', 'Sphere(B,β)'

    # Collapse ALL Segment(A,B)
    $content = $content -replace '(?s)Segment\s*\(\s*A\s*,\s*B\s*\)', 'Segment(A,B)'

    # Collapse ALL Ray(Light1,Light2)
    $content = $content -replace '(?s)Ray\s*\(\s*Light1\s*,\s*Light2\s*\)', 'Ray(Light1,Light2)'

    # Collapse IntersectConic with Spheres
    $content = $content -replace '(?s)IntersectConic\s*\(\s*Sphere\(A,α\)\s*,\s*Sphere\(B,β\)\s*\)', 'IntersectConic(Sphere(A,α),Sphere(B,β))'

    # Collapse Plane with IntersectConic
    $content = $content -replace '(?s)Plane\s*\(\s*IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\s*\)', 'Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'

    # Collapse Plane with single parameter
    $content = $content -replace '(?s)Plane\s*\(\s*B\s*,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(B,Ray(Light1,Light2))'
    $content = $content -replace '(?s)Plane\s*\(\s*A\s*,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(A,Ray(Light1,Light2))'

    # Fix operators on separate lines - bring them to previous line
    $content = $content -replace '(?m)\)\s*\n\s*<\s*\n\s*CircularArc\(', ")<CircularArc("
    $content = $content -replace '(?m)\)\s*\n\s*<\s*CircularArc\(', ")<CircularArc("

    # Fix comparison operators that got separated
    $content = $content -replace '(?m)\)\s*\n\s*<\s*\(', ")<("
    $content = $content -replace '(?m)\)\s*\n\s*>\s*\(', ")>("

    $changed = ($oldLength -ne $content.Length)
    if ($changed) {
        Write-Host "Iteration $iterations : Reduced by $($oldLength - $content.Length) characters"
    }
}

Write-Host "Completed $iterations iterations"

# Now reformat indentation
$lines = $content -split "`r?`n"
$result = @()
$indentLevel = 0

foreach ($line in $lines) {
    $trimmed = $line.Trim()

    if ($trimmed -eq '') {
        continue
    }

    # Decrease indent if line starts with )
    while ($trimmed -match '^\)' -and $indentLevel -gt 0) {
        $indentLevel--
        $trimmed = $trimmed.Substring(1).Trim()
        if ($trimmed -eq '' -or $trimmed -match '^\)') {
            $result += ('    ' * $indentLevel) + ')'
            if ($trimmed -eq '' -or $trimmed -eq ')') {
                if ($trimmed.Length -gt 0) { $trimmed = $trimmed.Substring(1).Trim() }
                continue
            }
        } else {
            $trimmed = ')' + $trimmed
            break
        }
    }

    if ($trimmed -eq '') {
        continue
    }

    # Add line with current indentation
    $indent = '    ' * $indentLevel
    $result += $indent + $trimmed

    # Count parentheses to adjust indent
    $openCount = ($trimmed.ToCharArray() | Where-Object { $_ -eq '(' }).Count
    $closeCount = ($trimmed.ToCharArray() | Where-Object { $_ -eq ')' }).Count

    $indentLevel += ($openCount - $closeCount)
    if ($indentLevel -lt 0) { $indentLevel = 0 }
}

$finalContent = $result -join "`n"

Write-Host "After reformatting: $($finalContent.Length) characters"

# Write output
[System.IO.File]::WriteAllText($outputFile, $finalContent, [System.Text.Encoding]::UTF8)

Write-Host "`nFormatted file written to: $outputFile"
Write-Host "Done!"
