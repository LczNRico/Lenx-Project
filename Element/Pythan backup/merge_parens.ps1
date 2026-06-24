# Merge closing parens that are on their own line after Plane(IntersectConic(...))

$inputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
$outputFile = "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"

$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Merging closing parentheses..."

# Pattern: Line ending with Plane(IntersectConic(Sphere(A,α),Sphere(B,β)) followed by line with just )
$content = $content -replace '(?m)^(\s*)Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\r?\n\s*\)', '$1Plane(IntersectConic(Sphere(A,α),Sphere(B,β)))'

Write-Host "Writing output..."
[System.IO.File]::WriteAllText($outputFile, $content, [System.Text.Encoding]::UTF8)

$lineCount = ($content -split "`n").Count
Write-Host "Done! Total lines: $lineCount"
