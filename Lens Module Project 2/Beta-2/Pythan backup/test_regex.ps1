$testLine = '                        Plane(IntersectConic(Sphere(A,α),Sphere(B,β))'
Write-Host "Testing line: $testLine"

if ($testLine -match '^(\s+)Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\s*$') {
    Write-Host "MATCH! Indent: [$($matches[1].Length) spaces]"
} else {
    Write-Host "NO MATCH"
}

# Try without the IntersectConic part
if ($testLine -match '^(\s+)Plane\(') {
    Write-Host "Matches beginning: Plane("
}

# Show what it ends with
Write-Host "Line ends with: $($testLine.Substring([Math]::Max(0, $testLine.Length - 10)))"
