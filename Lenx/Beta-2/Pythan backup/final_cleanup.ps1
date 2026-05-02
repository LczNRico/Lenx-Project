# Final cleanup script

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"

$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Running final cleanup..."

# Fix missing closing paren on Plane(IntersectConic(...))
$content = $content -replace 'Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)(?!\))', 'Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'

# Split )<CircularArc( onto separate lines with proper operator placement
$content = $content -replace '\)<CircularArc\(', ")<CircularArc("

# Now handle the < operator by reading lines
$lines = $content -split "`r?`n"
$result = @()

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]

    # Check if line ends with )<CircularArc(
    if ($line -match '^(\s*)(.*)\)<CircularArc\($') {
        $indent = $matches[1]
        $beforeOperator = $matches[2]

        # Add the part before < with the closing paren
        $result += $indent + $beforeOperator + ')<'

        # Add CircularArc( on next line with same indentation
        $result += $indent + 'CircularArc('
    } else {
        $result += $line
    }
}

$content = $result -join "`n"

Write-Host "Writing final output..."
[System.IO.File]::WriteAllText($outputFile, $content, [System.Text.Encoding]::UTF8)

$lineCount = ($content -split "`n").Count
Write-Host "Done! Total lines: $lineCount"
