#!/bin/bash
# Script para instalar o Discord manualmente no Arch Linux a partir do arquivo tar.gz oficial

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute este script como root (usando sudo, por exemplo)."
    exit 1
fi

# URL para download do Discord (formato tar.gz)
DOWNLOAD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"

# Diretórios e arquivos temporários
TEMP_DIR=$(mktemp -d)
ARCHIVE="$TEMP_DIR/discord.tar.gz"

# Diretório de instalação e link simbólico
INSTALL_DIR="/opt/discord"
SYMLINK="/usr/bin/discord"

echo "Baixando o Discord do site oficial..."
if ! curl -L -o "$ARCHIVE" "$DOWNLOAD_URL"; then
    echo "Erro: Falha ao baixar o Discord."
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Extraindo o arquivo..."
if ! tar -xzvf "$ARCHIVE" -C "$TEMP_DIR"; then
    echo "Erro: Falha ao extrair o arquivo."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Geralmente o tar.gz extrai um diretório chamado 'Discord'
EXTRACTED_DIR="$TEMP_DIR/Discord"

if [ ! -d "$EXTRACTED_DIR" ]; then
    echo "Erro: Diretório 'Discord' não encontrado após a extração."
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Instalando o Discord..."

# Se houver uma versão anterior instalada, removê-la
if [ -d "$INSTALL_DIR" ]; then
    echo "Removendo instalação anterior em $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
fi

# Move o diretório extraído para o diretório de instalação
if ! mv "$EXTRACTED_DIR" "$INSTALL_DIR"; then
    echo "Erro: Não foi possível mover o Discord para $INSTALL_DIR."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Cria (ou atualiza) o link simbólico para o executável
# O executável geralmente se encontra em /opt/discord/Discord
echo "Criando link simbólico em $SYMLINK..."
rm -f "$SYMLINK"
if ! ln -s "$INSTALL_DIR/Discord" "$SYMLINK"; then
    echo "Erro: Não foi possível criar o link simbólico."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# (Opcional) Criar o atalho para o menu (arquivo desktop)
DESKTOP_FILE="/usr/share/applications/discord.desktop"
echo "Criando arquivo desktop em $DESKTOP_FILE..."
cat << EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Discord
Comment=Aplicativo de comunicação para comunidades e jogos
Exec=/usr/bin/discord
Icon=$INSTALL_DIR/discord.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
EOF

# Se o pacote extrair ícones (ex.: discord.png) dentro do diretório, copie para o diretório de instalação
if [ -f "$INSTALL_DIR/discord.png" ]; then
    echo "Ícone encontrado e configurado."
fi

# Limpeza do diretório temporário
rm -rf "$TEMP_DIR"

echo "Instalação do Discord concluída com sucesso!"
