$lines = Get-Content "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex" -Encoding UTF8

$line126 = $lines[125]
$line127 = $lines[126]

$combined = $line126 + "`n" + $line127

Write-Host "Combined string:"
Write-Host $combined
Write-Host ""

$pattern = 'Plane\(IntersectConic\(Sphere\(A,α\),Sphere\(B,β\)\)\)\)\s*\r?\n\s*\)'

if ($combined -match $pattern) {
    Write-Host "MATCH!"
} else {
    Write-Host "NO MATCH"

    # Try simpler patterns
    if ($combined -match 'Plane\(') {
        Write-Host "Matches: Plane("
    }

    if ($combined -match 'Plane.*\n.*\)') {
        Write-Host "Matches: Plane...newline...)"
    }
}
