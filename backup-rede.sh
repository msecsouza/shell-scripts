#!/usr/bin/env bash
#------------------------------------------------------------------
# Script   : backup-rede.sh
# Descrição: backup das configurações de rede
# Versão   : 0.1
# Autor    : Murilo Souza <e-mail>
# Data     : 06-03-2025
# Licença  : GNU/GPL v3.0
#------------------------------------------------------------------
# Uso: backup-rede.sh ou ./backup-rede.sh
#------------------------------------------------------------------

############################################################################################
# 											   #
#		        ------------------------------                                     #
#               	INFORMAÇÕES GERAIS DO PROGRAMA                                     #
#                       ------------------------------                                     #
#											   #
#   - Fazer o backup dos arquivos de configuração de rede em distros baseadas              #
#     no Debian, sendo facilmente adaptável a outras distribuições.                        #
#               								           #
#   - Arquivos que serão incluídos no processo de backup:                                  #
#                                                                                          #
#              "/etc/network/interfaces"                                                   #
#              "/etc/hostname"                                                             #
#              "/etc/hosts"                                                                #
#              "/etc/resolv.conf"                                                          #
# 											   #
#   - O backup do diretório /etc/network/interfaces.d/ foi inserido em alguns              #
#     momentos apenas como teste do programa, e funcionou. Ajuste 	                   #
#     conforme necessário.								   #	
#     											   #
#   - Verifica a existência dos arquivos de configuração antes de fazer o backup.          #
#   											   #
#   - Se algum arquivo não for encontrado, será informado no log de execução.              #
#											   #
#   - Se nenhum arquivo for encontrado, a execução do backup é abortada.                   #
#	                                                                                   #
#   - Compacta os arquivos essenciais em um ".tar.gz" e armazena no diretório de backup.   #
#											   #	
#   - Mantém os últimos 3 dias de backup, excluindo os antigos automaticamente.            #
#                      									   #
#   - Saída e erros são salvos no log -->> /var/log/backup-config_rede.log                 #
#    											   #
#   - Para incluir um novo arquivo no backup, adicione o caminho completo                  #
#     dele na variável CONFIG_FILES.                                                       #
#                                                                                          #
#   - Para garantir que o script seja executado automaticamente, em intervalos             #
#     regulares, incluí-lo em um agendador de tarefas, por ex: crontab.                    #
#                                                                                          #
############################################################################################

#---------------------------------------------------------------#
# Definição de cores...
RED='\033[31m'		# Vermelho
GREEN='\033[32m'	# Verde
YELLOW='\033[33m'	# Amarelo
BLUE='\033[0;34m'	# Azul
MAGENTA='\033[35m'	# MAGENTA
CYAN='\033[36m'		# CIANO
BLUE='\033[34m'		# Azul
RESET='\033[0m'		# Reset cor
BOLD='\033[1m'		# Negrito
UNDERLINE='\033[4m'	# Sublinhado
#---------------------------------------------------------------#


# Arquivo de log...
LOG_FILE="/var/log/backup-config_rede.log"

# Diretório onde o backup será armazenado...
BACKUP_DIR="/backup/rede"
DATA=$(date +"%d-%m-%Y")
BACKUP_FILE="backup_rede_$DATA.tar.gz"

# Redirecionamento saída e erros...
exec > >(tee -a "$LOG_FILE") 2>&1

echo -e "${CYAN}
============================================================================================
	Iniciando Backup <<-->> $(date +"%d-%m-%Y às %T")
--------------------------------------------------------------------------------------------
	[ATENÇÃO] <<-->> LOG DE EXECUÇÃO DISPONÍVEL EM: "$LOG_FILE"
============================================================================================
${RESET}"
# Arquivos de rede que serão armazenados...
CONFIG_FILES=(
	"/etc/network/interfaces"
	"/etc/hostname"
	"/etc/hosts"
	"/etc/resolv.conf"
	"/etc/network/interfaces.d/"
)

# Validar a existência dos arquivos...

MISSING_FILES=()
for FILE in "${CONFIG_FILES[@]}"; do
    if [[ ! -e "$FILE" ]]; then
       echo -e "${RED}[ATENÇÃO] <<-->>${RESET} O arquivo $FILE não existe"
       MISSING_FILES+=("$FILE")
    fi
done

# Se todos os arquivos estiverem ausentes, abortar o backup...

if [[ ${#MISSING_FILES[@]} -eq ${#CONFIG_FILES[@]} ]]; then
	echo -e "${RED}[ATENÇÃO] <<-->> Nenhum dos arquivos foi encontrado. Backup encerrado em $(date +"%d-%m-%Y às %T")${RESET}"
        exit 1
fi

# Criar diretório de backup, caso não exista...
if [[ ! -d "$BACKUP_DIR" ]]; then
   echo -e "${RED}[ATENÇÃO] <<-->> Diretório $BACKUP_DIR não encontrado. Criando diretório...${RESET}"
   mkdir -p "$BACKUP_DIR"
   if [[ $? -eq 0 ]]; then
      echo -e "${GREEN}[SUCESSO] <<-->> Diretório criado com êxito!${RESET}"
   else
      echo -e "${RED}[ERRO] <<-->> Erro ao criar o diretório. Verifique as permissões.${RESET}"
      exit 1
   fi
fi

# Criar backup dos arquivos disponíveis...

VALID_FILES=()
for FILE in "${CONFIG_FILES[@]}"; do
    [[ -e "$FILE" ]] && VALID_FILES+=("$FILE")
done

tar -czf "$BACKUP_DIR/$BACKUP_FILE" "${VALID_FILES[@]}" 2>/dev/null

# Verificar se o backup foi criado...

if [[ $? -eq 0 ]]; then
   echo -e "${GREEN}[SUCESSO] <<-->>${RESET} Backup criado com êxito: $BACKUP_DIR/$BACKUP_FILE"
   echo -e "${GREEN}\n[ATENÇÃO] <<-->> O backup realizado incluiu os seguintes arquivos:"
   	for _FILE in "${VALID_FILES[@]}"; do
	    echo -e "\t"$_FILE""
	done	
else
   echo -e "${RED}[ERRO] <<-->>${RESET} Falha ao criar o backup: verifique os logs."
   exit 1
fi

# Remover backups antigos (mais de 3 dias)...

echo -e "${MAGENTA}
===========================================================
	Removendo backups antigos (mais de 3 dias)
===========================================================
"
OLD_BACKUPS=$(find "$BACKUP_DIR" -name "backup_rede_*.tar.gz" -mtime +3)

  if [[ -z "$OLD_BACKUPS" ]]; then 
     echo -e "[ATENÇÃO] <<-->> Nenhum backup antigo para ser removido!"
  else
     echo -e "[AGUARDE] <<-->> Removendo backups antigos..."; sleep 2s
     echo "$OLD_BACKUPS" | xargs rm -f
     echo -e "}[SUCESSO] <<--<> Backups antigos removidos com êxito!${RESET}"
  fi    

# Registrar data e hora de término do backup...

echo -e "${CYAN}
============================================================================================
	Backup finalizado em $(date +"%d-%m-%Y %T")
--------------------------------------------------------------------------------------------
	[FIM] <<-->> LOG DE EXECUÇÃO DISPONÍVEL EM: "$LOG_FILE"
============================================================================================
${RESET}"

exit 0
