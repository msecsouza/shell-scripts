#!/usr/bin/env bash
#------------------------------------------------------------------
# Script   : menu-programas.sh
# Descrição: menu para escolha de programas
# Versão   : 0.1
# Autor    : Murilo Souza <e-mail>
# Data     : 05-02-2025
# Licença  : GNU/GPL v3.0
#------------------------------------------------------------------
# Uso: ./menu-programas.sh ou menu-programas.sh
#------------------------------------------------------------------

###########################################################################
#									  #						
# 	Script que exibirá um menu para escolha de execução		  #
# 	dos seguintes programas:	 				  #
# 									  #
# 	1 - Firefox (navegador de internet) 				  #
# 	2 - Leafpad (editor de texto)					  #
# 	3 - Terminator (emulador de terminal)				  #
# 	4 - Geany (editor de texto e IDE)                                 #
#	5 - Sair do Menu						  #
#									  #
###########################################################################


# Variáveis...

OPCAO_INVALIDA="[Erro!] Escolha uma opção entre 1 e 4: tente novamente!"
EXIT_MENU="Saindo... até logo!"

##########################################################################################################################################

while true ; do

echo "
#=======================================#
#	1 - Executar o Firefox		#
#	2 - Executar o Leafpad		#
#	3 - Executar o Terminator	#
#	4 - Executar o Geany		#
#	5 - Sair do Menu		#
#=======================================#
"
# Exibir o menu no terminal
read -p "Selecione a opção desejada: " OPCAO_ESCOLHIDA

# Verificar se a opção escolhida é válida (está entre 1 a 5)
if [[ "$OPCAO_ESCOLHIDA" -lt 1 || "$OPCAO_ESCOLHIDA" -gt 5 ]]; then
   echo "$OPCAO_INVALIDA"
   continue
fi

# Executar uma opção válida

if [[ "$OPCAO_ESCOLHIDA" -eq 1 ]]; then
   firefox &
   break
   
   elif [[ "$OPCAO_ESCOLHIDA" -eq 2 ]]; then
        l3afpad &
   break

   elif [[ "$OPCAO_ESCOLHIDA" -eq 3 ]]; then
        terminator &
   break

   elif [[ "$OPCAO_ESCOLHIDA" -eq 4 ]]; then
        geany & 
   break

   elif [[ "$OPCAO_ESCOLHIDA" -eq 5 ]]; then
        echo "$EXIT_MENU"
   break

fi
done
exit 0
