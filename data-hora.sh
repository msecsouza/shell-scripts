#!/usr/bin/env bash
# -------------------------------------------------------------------
# Script    : script-name.sh
# Descricão : check de data, hora e uptime do sistema
# Versão    : 0.1
# Autor     : Seu nome <e-mail>
# Data      : $(date +"%d/%m/%Y") 
# Licença   : GNU/GPL v3.0
# -------------------------------------------------------------------
# Uso: ./script-name.sh ou /caminho/dscript-namesh
# -------------------------------------------------------------------

# Variáveis...

UPTIME=$(uptime -s)
FMT='+%d/%m/%Y - %T'
SEP="========================================================"
HOSTNAME=$(hostname)

# Execução do script...

echo -e "
	       Hostname: $HOSTNAME
$SEP
Data e hora: $(date "$FMT")\n
Ativo desde: $(date "$FMT" -d "$UPTIME")
$SEP
"
exit 0