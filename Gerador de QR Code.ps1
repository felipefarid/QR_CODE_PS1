Add-Type -AssemblyName Microsoft.VisualBasic

# Abre uma caixa de diálogo gráfica para o usuário digitar o link
$link = [Microsoft.VisualBasic.Interaction]::InputBox("Digite o link para gerar o QR Code", "Entrada de Link", "https://www.seusite.com")

# Verifica se o link não está vazio
if (-not [string]::IsNullOrEmpty($link)) {

    # Monta a URL da API do QRServer para gerar o QR Code
    $urlQrCode = "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=$link"

    # Cria o diálogo de salvamento de arquivo
    Add-Type -AssemblyName System.Windows.Forms
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "PNG Files (*.png)|*.png"
    $saveFileDialog.Title = "Escolha onde salvar o QR Code"
    $saveFileDialog.ShowDialog() | Out-Null

    # Obtém o caminho selecionado pelo usuário
    $path = $saveFileDialog.FileName

    # Verifica se o usuário selecionou um caminho
    if (![string]::IsNullOrEmpty($path)) {
        # Baixa a imagem do QR Code e salva no caminho escolhido
        Invoke-WebRequest -Uri $urlQrCode -OutFile $path
        Write-Host "QR Code gerado e salvo com sucesso em $path"
    } else {
        Write-Host "Operação cancelada. Nenhum arquivo foi salvo."
    }
} else {
    Write-Host "Operação cancelada. Nenhum link foi fornecido."
}
