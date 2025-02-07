#!/usr/bin/env bash
#------------------------------------------------------------------
# Script   : check-ip_router.sh
# Descrição: validar a conexão com o gateway default
# Versão   : 0.1
# Autor    : Murilo Souza <e-mail>
# Data     : 07-02-2025
# Licença  : GNU/GPL v3.0
#------------------------------------------------------------------
# Uso: check-ip_router.sh ou ./check-ip_router.sh
#------------------------------------------------------------------

	#######################################################################################################
	#												      #
	#  O script oferece um diagnóstico rápido e automatizado. Antes de investigar problemas mais          #
	#  complexos, o script ajuda a isolar uma causa comum de falha: perda de conectivadede com o          #
	#  gateway. 											      #
	#												      #
	#  Automatizar esse processo elimina a possibildiade de erros humanos na execução dos comandos,       #
	#  especialmente em momentos de pressão.							      #
	#												      #
	#  Testa a conectividade do host com o gateway padrão, permitindo diagnosticar possíveis              #
	#  problemas de conectividade com a rede e identificando rapidamente se o host consegue               #
	#  acessar a rede externa ou se há algum bloqueio no caminho para o gateway.                          #
	#      												      #
	#  Pode ser facilmente integrado em sistemas de monitoramento de rede, podendo ser                    #
	#  executado periodicamente e gerar alertas de forma automática caso haja problemas                   #
	#  de conectividade.										      #
	#  												      #
	#  O uso das mensagens de "FALHA" e "SUCESSO" ajuda a equipe a entender rapidamente o estado          #
	#  da rede. Isso é especialmente útil em cenário de troubleshooting, onde o tempo de resposta         #
	#  é crucial.											      #		
	#												      #
	#######################################################################################################
	

# Obter o gateway padrão...

GATEWAY=$(ip route show default | awk '{print $3}')

################################################################################################################

# Variáveis

MSG_ESPERA="[AGUARDE]---> Testando a conexão, por favor, aguarde..."
MSG_SUCESSO="[SUCESSO]---> Conexão com o gateway default estabelecida com sucesso!"
MSG_ERRO="[FALHA]---> Sem conexão com o gateway default: favor verificar!"

#################################################################################################################

echo -e "\n$MSG_ESPERA\n"

# ping será executado 5 vezes, com intervalo de 2 segundos
# para cada tentativa...

if ! ping -c5 -i2 $GATEWAY &>> /dev/null ; then
   echo "$MSG_ERRO"
   exit 1
else
   echo -e "$MSG_SUCESSO\n"
fi
exit 0
