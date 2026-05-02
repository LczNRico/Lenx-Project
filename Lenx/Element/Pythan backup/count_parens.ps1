$lines = Get-Content "c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex" -Encoding UTF8
$line = $lines[125]

Write-Host "Line 126: $line"
Write-Host ""

$opens = ($line.ToCharArray() | Where-Object { $_ -eq '(' }).Count
$closes = ($line.ToCharArray() | Where-Object { $_ -eq ')' }).Count

Write-Host "Open parens: $opens"
Write-Host "Close parens: $closes"
Write-Host "Difference: $($opens - $closes)"
