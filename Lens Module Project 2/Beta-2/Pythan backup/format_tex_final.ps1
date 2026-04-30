# PowerShell script to format the .tex file - Final Version
# Comprehensive reformatting with proper indentation

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_new.tex"

# Read the entire file
$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Processing file..."
Write-Host "Original length: $($content.Length) characters"

# Function to collapse simple function calls - very aggressive
function Collapse-SimpleFunctions {
    param([string]$text)

    $iterations = 0
    $maxIterations = 20
    $changed = $true

    while ($changed -and $iterations -lt $maxIterations) {
        $iterations++
        $oldLength = $text.Length

        # Collapse Sphere(A,α) in ALL forms
        $text = $text -replace '(?s)Sphere\s*\(\s*A\s*,\s*α\s*\)', 'Sphere(A,α)'

        # Collapse Sphere(B,β) in ALL forms
        $text = $text -replace '(?s)Sphere\s*\(\s*B\s*,\s*β\s*\)', 'Sphere(B,β)'

        # Collapse Segment(A,B) in ALL forms
        $text = $text -replace '(?s)Segment\s*\(\s*A\s*,\s*B\s*\)', 'Segment(A,B)'

        # Collapse Ray(Light1,Light2) in ALL forms
        $text = $text -replace '(?s)Ray\s*\(\s*Light1\s*,\s*Light2\s*\)', 'Ray(Light1,Light2)'

        # Collapse Plane with Ray
        $text = $text -replace '(?s)Plane\s*\(\s*B\s*,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(B,Ray(Light1,Light2))'
        $text = $text -replace '(?s)Plane\s*\(\s*A\s*,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(A,Ray(Light1,Light2))'

        # Collapse IntersectConic with two Spheres - handle newlines
        $text = $text -replace '(?s)IntersectConic\s*\(\s*Sphere\(A,α\)\s*,\s*Sphere\(B,β\)\s*\)', 'IntersectConic(Sphere(A,α),Sphere(B,β))'

        # Collapse Plane with IntersectConic
        $text = $text -replace '(?s)Plane\s*\(\s*IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\s*\)', 'Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'

        $changed = ($oldLength -ne $text.Length)
        if ($changed) {
            Write-Host "Iteration $iterations : Reduced by $($oldLength - $text.Length) characters"
        }
    }

    Write-Host "Completed $iterations iterations"
    return $text
}

# Function to fix indentation properly
function Fix-Indentation {
    param([string]$text)

    $lines = $text -split "`r?`n"
    $result = @()
    $indentLevel = 0

    foreach ($line in $lines) {
        $trimmed = $line.Trim()

        if ($trimmed -eq '') {
            continue
        }

        # Count closing parens at start vs end to adjust indent
        $openCount = ($trimmed.ToCharArray() | Where-Object { $_ -eq '(' }).Count
        $closeCount = ($trimmed.ToCharArray() | Where-Object { $_ -eq ')' }).Count

        # Check if line starts with closing paren/bracket
        if ($trimmed -match '^\)') {
            $indentLevel--
            if ($indentLevel -lt 0) { $indentLevel = 0 }
        }

        # Add line with current indentation
        $indent = '    ' * $indentLevel
        $result += $indent + $trimmed

        # Adjust indent level for next line
        # If line ends with opening paren, increase indent
        if ($trimmed -match '\($' -or $trimmed -match '\(.*[^)]$') {
            if ($openCount -gt $closeCount) {
                $indentLevel += ($openCount - $closeCount)
            }
        }

        # If more closing than opening, decrease for next
        if ($closeCount -gt $openCount -and -not ($trimmed -match '^\)')) {
            $indentLevel -= ($closeCount - $openCount)
            if ($indentLevel -lt 0) { $indentLevel = 0 }
        }
    }

    return ($result -join "`n")
}

# Main processing
Write-Host "Step 1: Collapsing simple functions..."
$processed = Collapse-SimpleFunctions $content
Write-Host "After collapse: $($processed.Length) characters (saved $($content.Length - $processed.Length))"

Write-Host "Step 2: Fixing indentation..."
$processed = Fix-Indentation $processed
Write-Host "After indentation fix: $($processed.Length) characters"

# Write output
[System.IO.File]::WriteAllText($outputFile, $processed, [System.Text.Encoding]::UTF8)

Write-Host "`nFormatted file written to: $outputFile"
Write-Host "Done!"

# Show a sample
Write-Host "`nFirst few lines:"
$sampleLines = ($processed -split "`n") | Select-Object -First 30
$sampleLines | ForEach-Object { Write-Host $_ }
