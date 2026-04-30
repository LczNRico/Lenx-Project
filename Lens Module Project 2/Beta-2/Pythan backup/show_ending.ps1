$lines = Get-Content "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex" -Encoding UTF8
$line = $lines[125]

Write-Host "Line (length $($line.Length)):"
Write-Host $line
Write-Host ""

# Show last 5 characters with their values
Write-Host "Last 5 characters:"
for ($i = $line.Length - 5; $i -lt $line.Length; $i++) {
    $char = $line[$i]
    Write-Host "Position $i : '$char'"
}
