#!/usr/bin/env bash
#------------------------------------------------------------------
# Script   : pingsweep.sh
# Descrição: varredura de IPs em um faixa de rede
# Versão   : 0.1
# Autor    : Murilo Souza <e-mail>
# Data     : 27-03-2025
# Licença  : GNU/GPL v3.0
#------------------------------------------------------------------
# Uso: pingsweep.sh ou /caminho/pingsweep.sh
#------------------------------------------------------------------

###########################################################
#                       PING SWEEP                        #
#                      ------------                       #
#  Um ping sweep significa que um ping é enviado a todos  #
#  os possíves endereços IP de uma dada faixa a fim de    #
#  determinar aqueles que enviarão uma resposta e, desse  #
#  modo, serão considerados up ou ativos.                 #
#                                                         #
###########################################################

#########################
# Definição de cores... #
#########################

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


#############
# Variáveis #
#############

SUBREDE="$1"
ARQUIVO="result-pingsweep.txt"
SCRIPT_NAME=$(basename "$0")

#===============================================================================================================================#

###############################################
# Verifica se o usuário informou a subrede... #
###############################################

if [[ -z "$1" ]]; then
   echo -e "\n${RED}[ERRO]--> Necessário informar a subrede${RESET}\n"   
   echo -e "${MAGENTA}[USO]--> $SCRIPT_NAME <subrede> (exemplo: $SCRIPT_NAME 192.168.1)${RESET}\n"
   exit 1
fi

############################################
# Executa ping sweep de forma otimizada... #
############################################

echo -e "\n${MAGENTA}Varredura de rede em andamento... ($SUBREDE.0/24)${RESET}\n"
for IP in {1..254}; do
    ping -c 1 -W 1 "$SUBREDE"."$IP" >> "$ARQUIVO" &
done
wait

echo -e "\n${UNDERLINE}${MAGENTA}Varredura concluída! Resultados salvos em $ARQUIVO${RESET}\n"

exit 0
