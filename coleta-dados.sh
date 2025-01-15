#!/usr/bin/env bash
# -------------------------------------------------------------------
# Script    : script-name.sh
# Descrição : coletar informações técnicas do sistema
# Versão    : 0.1
# Autor     : Seu nome <e-mail>
# Data      : $(date +"%d/%m/%Y") 
# Licença   : GNU/GPL v3.0
# -------------------------------------------------------------------
# Uso: ./script-name.sh ou /caminho/script-name.sh
# -------------------------------------------------------------------

# Variáveis...

OS_VERSION=$(lsb_release -d | awk -F'\t' '{print $2}')
OS_RELEASE=$(grep -E '^VERSION=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
USUARIO=$(whoami)
FMT='+%d/%m/%Y - %T'
KERNEL=$(uname -rms)
HOSTNAME=$(hostname)
CPUQTD=$(cat /proc/cpuinfo | grep "model name" | wc -l)
MEMTOTAL=$(free -m | awk 'NR==2{print $2 " MB"}')
MEMFREE=$(free -m | awk 'NR==2{print $4 "  MB"}')
FILESYS=$(df -Th | egrep -v '(tmpfs|udev)')
UPTIME=$(uptime -s)
LOADAVERAGE=$(uptime | sed 's/.*load average: //'i)

# Execução do script...

echo -e "
           Coleta de dados do host: $HOSTNAME
==============================================================
Data e hora   : $(date "$FMT")\n
Ativo desde   : $(date "$FMT" -d "$UPTIME")\n
Usuário atual : $USUARIO\n
Load average  : $LOADAVERAGE (1 min, 5 min, 15 min)
==============================================================
"
echo -e "Distribuição                  : $OS_VERSION\n"
echo -e "Release                       : $OS_RELEASE\n"
echo -e "Kernel e Arquitetura          : $KERNEL\n"
echo -e "Quantidade de CPUs/Core       : $CPUQTD\n"
echo -e "Memória Total                 : $MEMTOTAL\n"
echo -e "Memória Livre                 : $MEMFREE\n"
echo -e "Partições                     :\n                   
$FILESYS
"
echo "
#############################################################
#	Coleta de dados efetuada com sucesso!               #
#	Os dados estão prontos para análise.                #
#############################################################
"

exit 0