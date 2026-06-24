# Simple merge script

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"

$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Original length: $($content.Length)"

# Pattern: Plane(IntersectConic(Sphere(A,α),Sphere(B,β)) with 3 closing parens,
# followed by newline and one more )
# Need to match: Plane( Intersect Conic( Sphere(A,α) Sphere(B,β) ) ) with one more ) on next line
# Use . to match any character for α and β since they might not match literally in regex
$content = $content -creplace 'Plane\(IntersectConic\(Sphere\(A,.\),Sphere\(B,.\)\)\)\)\s*\r?\n\s*\)', 'Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'

Write-Host "After merge: $($content.Length)"

[System.IO.File]::WriteAllText($outputFile, $content, [System.Text.Encoding]::UTF8)

Write-Host "Done!"
