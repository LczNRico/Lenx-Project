$lines = Get-Content "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex" -Encoding UTF8

$line126 = $lines[125]
$line127 = $lines[126]

Write-Host "Line 126 ($($line126.Length) chars):"
Write-Host $line126
Write-Host ""
Write-Host "Last 20 chars of line 126:"
Write-Host $line126.Substring([Math]::Max(0, $line126.Length - 20))
Write-Host ""
Write-Host "Line 127 ($($line127.Length) chars):"
Write-Host $line127
Write-Host ""
Write-Host "Trimmed line 127: [$($line127.Trim())]"
