IF NOT EXIST mkcert.exe powershell Invoke-WebRequest https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-windows-amd64.exe -UseBasicParsing -OutFile mkcert.exe
mkcert -install
del /Q /S traefik\certs\*
mkcert -cert-file traefik\certs\xp0cm.localhost.crt -key-file traefik\certs\xp0cm.localhost.key "xp0cm.localhost"
mkcert -cert-file traefik\certs\xp0id.localhost.crt -key-file traefik\certs\xp0id.localhost.key "xp0id.localhost"