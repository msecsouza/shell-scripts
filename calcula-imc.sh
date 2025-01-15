#!/usr/bin/env bash
# -------------------------------------------------------------------
# Script    : script-name.sh
# Descrição : calcular o indice de massa corporal de uma pessoa
# Versão    : 0.1
# Autor     : Seu nome <e-mail>
# Data      : $(date +"%d/%m/%Y") 
# Licença   : GNU/GPL v3.0
# -------------------------------------------------------------------
# Uso:./script-name.sh ou /caminho/script-name.sh
# -------------------------------------------------------------------

########################### DESCRIÇÃO ###########################################
#                                                                               #
#  O IMC de uma pessoa é calculado dividindo o peso da pessoa (em quilos) pela  #
#  sua altura (em metros ao quadrado) IMC = peso(kg)/altura(m) x altura (m)     #
#                                                                               #
#  a tabela de resultados do IMC encontra-se em: www.calculoimc.com.br          #
# 										#
# ###############################################################################                                     

# Variáveis...

declare NOME
declare ALTURA
declare -i PESO
declare IMC

# Execução do script...

echo -e "\nPreencha cuidadosamente os dados a seguir!\n"

read -p "Informe seu nome: " NOME

read -p "Informe sua altura: " ALTURA

read -p "Informe seu peso: " PESO

IMC=$(echo "scale=2.0 ; $PESO / ($ALTURA ^ 2)" | bc)

echo "
==============================================================
$NOME, seu IMC é: $IMC
==============================================================
"
exit 0