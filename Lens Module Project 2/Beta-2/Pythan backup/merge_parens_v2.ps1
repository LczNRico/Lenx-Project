# Merge closing parens - line by line approach

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"

$lines = Get-Content $inputFile -Encoding UTF8
$result = @()
$skipNext = $false

Write-Host "Processing $($lines.Count) lines..."

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($skipNext) {
        $skipNext = $false
        continue
    }

    $line = $lines[$i]

    # Check if this line ends with Plane(IntersectConic(Sphere(A,α),Sphere(B,β))
    # AND the next line is just whitespace and )
    if ($line -match '^(\s*)Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)$' -and $i + 1 -lt $lines.Count) {
        $nextLine = $lines[$i + 1]
        if ($nextLine.Trim() -eq ')') {
            # Merge: add the closing paren to current line
            $result += $line + ')'
            $skipNext = $true
            continue
        }
    }

    $result += $line
}

Write-Host "Writing output..."
$result | Out-File -FilePath $outputFile -Encoding UTF8

$lineCount = $result.Count
Write-Host "Done! Total lines: $lineCount"
