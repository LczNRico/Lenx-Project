$lines = Get-Content "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex" -Encoding UTF8
$line = $lines[125]

Write-Host "Full line 126:"
Write-Host $line
Write-Host ""
Write-Host "Character by character (last 10):"
for ($i = [Math]::Max(0, $line.Length - 10); $i -lt $line.Length; $i++) {
    Write-Host "$i : '$($line[$i])' (ASCII $([int]$line[$i]))"
}
