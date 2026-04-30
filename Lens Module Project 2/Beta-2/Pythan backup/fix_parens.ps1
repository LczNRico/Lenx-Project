# Fix missing closing parentheses on Plane(IntersectConic(...))

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"

$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Fixing missing closing parentheses..."

# Fix lines that end with Plane(IntersectConic(Sphere(A,α),Sphere(B,β)) but no closing paren
$lines = $content -split "`r?`n"
$result = @()

foreach ($line in $lines) {
    # If line ends with Plane(IntersectConic(Sphere(A,α),Sphere(B,β)) add the closing paren
    if ($line -match '^(.*)Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\)(.*)$') {
        # Already has closing paren, keep as is
        $result += $line
    } elseif ($line -match '^(.*)Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)$') {
        # Missing closing paren, add it
        $result += $line + ')'
    } else {
        $result += $line
    }
}

$content = $result -join "`n"

Write-Host "Writing output..."
[System.IO.File]::WriteAllText($outputFile, $content, [System.Text.Encoding]::UTF8)

$lineCount = ($content -split "`n").Count
Write-Host "Done! Total lines: $lineCount"
