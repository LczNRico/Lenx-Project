# Merge Plane(IntersectConic(...)) lines that are split

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"

$lines = Get-Content $inputFile -Encoding UTF8
$result = @()
$skipNext = $false

Write-Host "Processing $($lines.Count) lines..."
$merged = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($skipNext) {
        $skipNext = $false
        continue
    }

    $line = $lines[$i]

    # Check if line ends with Plane(IntersectConic(Sphere(A,α),Sphere(B,β)) - missing closing )
    if ($line -match '^(\s+)Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\s*$' -and $i + 1 -lt $lines.Count) {
        $nextLine = $lines[$i + 1]

        # Check if next line is just indentation + )
        if ($nextLine -match '^\s+\)\s*$') {
            # This is a split Plane call - merge them
            $indent = $matches[1]
            $result += $indent + 'Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'
            $skipNext = $true
            $merged++
            continue
        }
    }

    $result += $line
}

Write-Host "Merged $merged instances"
Write-Host "Writing output..."
$result | Out-File -FilePath $outputFile -Encoding UTF8

$lineCount = $result.Count
Write-Host "Done! Total lines: $lineCount"
