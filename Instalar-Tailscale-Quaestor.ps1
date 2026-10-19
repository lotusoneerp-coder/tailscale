# Instalador do Tailscale para computadores Windows da Quaestor
# Execute no PowerShell como Administrador.
$ErrorActionPreference = 'Stop'

try {
    $tailscaleExe = Join-Path $env:ProgramFiles 'Tailscale\tailscale.exe'
    if (Test-Path $tailscaleExe) {
        Write-Host 'Tailscale ja esta instalado.' -ForegroundColor Green
    } else {
        Write-Host 'Instalando Tailscale pelo Windows Package Manager (winget)...' -ForegroundColor Cyan
        $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
        if (-not $winget) {
            throw 'winget nao encontrado. Instale/atualize o App Installer da Microsoft Store ou use https://tailscale.com/download/windows'
        }
        & winget.exe install --id Tailscale.Tailscale --exact --source winget --accept-package-agreements --accept-source-agreements --silent --disable-interactivity
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao instalar o Tailscale (codigo $LASTEXITCODE)."
        }
        if (-not (Test-Path $tailscaleExe)) {
            throw 'Instalacao concluida, mas o executavel nao foi localizado. Verifique a instalacao.'
        }
        Write-Host 'Tailscale instalado com sucesso.' -ForegroundColor Green
    }

    Write-Host 'Abrindo o Tailscale. Entre com a conta autorizada pela Quaestor.' -ForegroundColor Cyan
    $gui = Join-Path $env:ProgramFiles 'Tailscale\tailscale-ipn.exe'
    if (Test-Path $gui) { Start-Process -FilePath $gui }
    else { & $tailscaleExe up }

    Write-Host 'Depois da autorizacao, abra: https://quaestor.tail53d01c.ts.net/erp' -ForegroundColor Green
    Write-Host 'Ou https://erp.quaestoradvisors.com.br quando o redirecionamento estiver configurado.'
} catch {
    Write-Host "ERRO: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
