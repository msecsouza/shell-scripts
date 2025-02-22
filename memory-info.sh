#!/usr/bin/env bash                                                                                                                                                        
#------------------------------------------------------------------
# Script   : memory-info.sh
# Descrição: Exibe o consumo atual de memória do sistema
# Versão   : 0.1
# Autor    : Murilo Souza <e-mail>
# Data     : 21-02-2025
# Licença  : GNU/GPL v3.0
#------------------------------------------------------------------
# Uso: memory-info.sh ou ./memory-info.sh
#------------------------------------------------------------------


########################################################################
#			                                               #
#               ------------------------------                         #
#		INFORMAÇÕES GERAIS DO PROGRAMA                         #
#               ------------------------------                         #
#								       #
#   Através do acesso ao arquivo /proc/meminfo, o programa coleta e    #
#   apresenta, em tempo real, informações sobre a utilização de        #
#   memória em sistemas GNU/Linux.				       #
#                                                                      #
#   Se o arquivo /proc/meminfo não existir ou não for acessível,       #
#   o programa será imediatamente interrompido.                        #
#                                                                      #
#   A fim de tornar a leitura dos dados mais clara, foi criada a       #
#   função 'convert_kb_to_mb', que exibe os dados em Megabytes (MB).   #
#							               #
#   No final do programa, é possível identificar os cinco processos    #
#   que mais consomem memória no momento, juntamente com os usuários   #
#   responsáveis por cada processo.                                    #
#								       #
########################################################################

#####################################################################################################
#   												    #	
#              			------------------------                                            #
#				SOBRE OS DADOS COLETADOS                                            #
#               		------------------------                                            #
#                                                                                                   #
#   MemTotal     : Indica o total de memória RAM instalada no sistema.                              #
#                                                                                                   #
#   MemFree      : Indica a quantidade de memória RAM que está completamente                        # 
#                  livre e não está sendo utilizada por nenhum processo, cache                      #
#                  buffer.                                                                          #
#                                                                                                   #
#   MemAvailable : Indica a quantidade de memória que pode ser usada por novos processos,           #
#                  sem que seja necessário fazer troca (swap) de dados para o disco.                #
#                                                                                                   #
#   Buffer       : Áreas de memória usadas para armazenar dados temporários durante                 #
#                  operações de I/O em dispositivos de armazenamento (HD, SSD, etc).                #
#												    #
#   Cached       : Quantidade de memória usada pelo sistema para armazenar dados temporários        #
#                  de arquivos. Isso acelera o acesso a arquivos que foram lidos recentemente.      #
#                                                                                                   #
#   SwapTotal    : Swap é um espaço no disco rígido que é usado quando a memória RAM física         #
#                  está cheia. Essa área de swap atua como uma extensão de memória física,          #
#                  permitindo que o sistema continue funcionando sem travar.                        #
#                                                                                                   #
#   SwapFree     : Indica a quantidade de swap que não foi utilizado até o momento.                 #
#                                                                                                   #
#   Active       : Memória que está atualmente em uso. Contém páginas de dados ativas,              #
#                  frequentemente acessadas por processos.                                          #
#                                                                                                   #
#   Inactive     : Memória que não está sendo usada ativamente no momento, mas ainda contém dados   #
#                  que podem ser utilizados rapidamente, se necessário. Pode ser liberada para      #
#                  outras tarefas quando a memória for necessária.                                  #                           
#                                                                                                   #
#####################################################################################################


# Iniciando a execução do programa...

##################################################################
# Verificando se o arquivo /proc/meminfo existe no sistema...
##################################################################

if [[ ! -e /proc/meminfo ]] ; then
   echo -e "\e[31m[OPS...] --> Não é possível continuar. O arquivo /proc/meminfo não foi encontrado no sistema.\e[0m"
   exit 1
fi

########################################
# Função para conversão de KB em MB
# limitado para duas casas decimais
# #######################################

function convert_kb_to_mb() {
       echo "scale=2; $1 / 1024" | bc
}

###########################################
# Coleta de dados do /proc/meminfo
###########################################

TOTAL_MEM=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
FREE_MEM=$(grep "MemFree" /proc/meminfo | awk '{print $2}')
AVAILABLE_MEM=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')
BUFFERS=$(grep "Buffers" /proc/meminfo | awk '{print $2}')
CACHED=$(grep "^Cached" /proc/meminfo | awk '{print $2}')
SWAP_TOTAL=$(grep "SwapTotal" /proc/meminfo | awk '{print $2}')
SWAP_FREE=$(grep "SwapFree" /proc/meminfo | awk '{print $2}')
ACTIVE_MEM=$(grep "Active" /proc/meminfo | head -1 |awk '{print $2}')                                                                                           
INACTIVE_MEM=$(grep "^Inactive" /proc/meminfo | head -1 | awk '{print $2}')


#############################################
# Conversão dos valores coletados para MB
#############################################

TOTAL_MEM_MB=$(convert_kb_to_mb "$TOTAL_MEM")
FREE_MEM_MB=$(convert_kb_to_mb "$FREE_MEM")
AVAILABLE_MEM_MB=$(convert_kb_to_mb "$AVAILABLE_MEM")
BUFFERS_MB=$(convert_kb_to_mb "$BUFFERS")
CACHED_MB=$(convert_kb_to_mb "$CACHED")
SWAP_TOTAL_MB=$(convert_kb_to_mb "$SWAP_TOTAL")
SWAP_FREE_MB=$(convert_kb_to_mb "$SWAP_FREE")
ACTIVE_MEM_MB=$(convert_kb_to_mb "$ACTIVE_MEM")
INACTIVE_MEM_MB=$(convert_kb_to_mb "$INACTIVE_MEM")

#################################                                                                                                                            
# Exibir valores formatados
#################################

echo -e "
Coleta efetuada no host \e[95m'$(hostname -f)'\e[0m pelo usuário \e[95m'$USER'\e[0m
\e[94m
=======================================================================================
	    Informações de Memória (em MB) no dia $(date "+ %d-%m-%Y  %T")
=======================================================================================
Memória Total      : $TOTAL_MEM_MB
Memória Livre      : $FREE_MEM_MB
Memória Disponível : $AVAILABLE_MEM_MB
Buffers            : $BUFFERS_MB
Cache              : $CACHED_MB
Swap Total         : $SWAP_TOTAL_MB
Swap Livre         : $SWAP_FREE_MB
Memória Ativa      : $ACTIVE_MEM_MB
Memória Inativa    : $INACTIVE_MEM_MB\e[0m"

#########################################################
# TOP 5 processos que mais consomem memória...                                                                                                   
########################################################

echo -e "
\e[91m=======================================================================================
			TOP 5 processos por uso de memória (em MB):
=======================================================================================\e[0m"
echo -e "
\e[91mPID	   USER	          MEM_MB	COMMAND
---------------------------------------------------------------------------------------
$(ps aux --sort=-%mem | awk 'NR==2,NR==6 {printf "%-10d %-12s %8.2f	%s\n", $2, $1, $6/1024, $11}')\e[0m"
echo " "
exit 0                                                                                                                           
