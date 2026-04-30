# PowerShell script to format the .tex file
# Format rules:
# - Simple functions (Segment, Sphere, Ray, Plane with simple args) on one line
# - Complex nested structures expanded with 4-space indentation

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_new.tex"

# Read the entire file
$content = Get-Content $inputFile -Raw -Encoding UTF8

# Function to collapse simple function calls to one line
function Collapse-SimpleFunctions {
    param([string]$text)

    # Pattern for Segment(A,B) that's split across lines
    $text = $text -replace '(?ms)Segment\(\s+A,\s+B\s+\)', 'Segment(A,B)'

    # Pattern for Sphere(A,α) split across lines
    $text = $text -replace '(?ms)Sphere\(\s+A,\s+α\s+\)', 'Sphere(A,α)'

    # Pattern for Sphere(B,β) split across lines
    $text = $text -replace '(?ms)Sphere\(\s+B,\s+β\s+\)', 'Sphere(B,β)'

    # Pattern for Ray(Light1,Light2) split across lines
    $text = $text -replace '(?ms)Ray\(\s+Light1,\s+Light2\s+\)', 'Ray(Light1,Light2)'

    # Pattern for Plane(B,Ray(Light1,Light2)) - keep if already on one line
    $text = $text -replace '(?ms)Plane\(\s*B,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(B,Ray(Light1,Light2))'

    # Pattern for Plane(A,Ray(Light1,Light2))
    $text = $text -replace '(?ms)Plane\(\s*A,\s*Ray\(Light1,Light2\)\s*\)', 'Plane(A,Ray(Light1,Light2))'

    return $text
}

# Function to normalize indentation to 4 spaces
function Normalize-Indentation {
    param([string]$text)

    $lines = $text -split "`n"
    $result = @()

    foreach ($line in $lines) {
        # Count leading spaces
        if ($line -match '^(\s*)(.*)$') {
            $indent = $matches[1]
            $content = $matches[2]

            # Convert tabs to 4 spaces
            $indent = $indent -replace "`t", '    '

            # Count total spaces
            $spaceCount = $indent.Length

            # Round to nearest multiple of 4
            $level = [Math]::Floor($spaceCount / 4)

            # Rebuild with normalized indentation
            $newIndent = '    ' * $level
            $result += $newIndent + $content
        } else {
            $result += $line
        }
    }

    return ($result -join "`n")
}

Write-Host "Processing file..."

# Process the content
$processed = Collapse-SimpleFunctions $content
$processed = Normalize-Indentation $processed

# Write output
$processed | Out-File -FilePath $outputFile -Encoding UTF8 -NoNewline

Write-Host "Formatted file written to: $outputFile"
Write-Host "Please review the output file."
