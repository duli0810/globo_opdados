#! /bin/bash
# Funciona como comando para facilitar a checagem da existencia
# de logs do glive para um determinado usuário
#
# Criado em 05/04/2019
# Autor: Leonardo Ferreira de Brito <leonardo.brito@corp.globo.com>
# Versão: 1.0 

# Definindo cores de intensidade alta
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC="\033[0m"              # Reset Colors

# Definindo o ip de um dos servidores do glive no caso abaixo glive-prod-be-dccm-cmal07be-06
glive_server="10.133.70.49"

# Definindo o caminho para os diretorios de logs
logsdir="/mnt/projetos/logs/glive/be"

# Criando um arranjo com todas as entradas
while test -n "$1"
do
  PARAMETERS[i]="$1"
  let i++
  shift
done

USAGE_MSG="
Funciona como comando para facilitar a checagem da existencia
de logs do glive para um determinado usuário.

Uso:  $(basename "$0") [<e-mail>|<globoId>] <path> 
      OPTIONS:
      <e-mail>      E-mail do usuário a ser pesquisado
      <globoId>     GloboId do usuário
      <path>        O path no formato "$IBlue"AAAA-MM/DD/HH/glive-tipodolog*$NC
      
      Examplos de uso:
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive*
        $(basename "$0") leonardo.brito@corp.globo.com 2021-03/04/*/glive*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-authenticate*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-authorize*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-block-unblock-users*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-daemon*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-external-integration*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-glbid*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-password*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-provision*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-purge*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-registration*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-services*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-update*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-users-admin*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-disk-msgs*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-enqueuestomp*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-03/04/*/glive-parental-consent*

      "$IBlue"Exemplos de busca em um determinado periodo:
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-05/{'01..05'}/glive-auth*
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039 2021-05/{'11..20'}/glive-provision*$NC
"

# Mostra a mensagem de ajuda quando necessario
while echo "${PARAMETERS[0]}" | egrep -q '(^$|^\-h$|^\-{0,}help$)' || [[ ${#PARAMETERS[@]} < "2" ]]
do
  echo -e "$USAGE_MSG"
  exit 0
done

# Definindo, de acordo com o input, o e-mail ou globoid do usuário
CLIENTID="developer"
INPUT=$(echo -e ${PARAMETERS[0]} | grep -i '@')
if test -n "$INPUT"
  then
    EMAIL="${PARAMETERS[0]}"
    ID=$(curl -X GET http://be.glive.globoi.com/v2/users/email/"${PARAMETERS[0]}" -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.globoId')
  else
    ID="${PARAMETERS[0]}"
    EMAIL=$(curl -X GET http://be.glive.globoi.com/v2/users/"${PARAMETERS[0]}" -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.email')
fi

# Programa principal
echo -e "\n"$IYellow"Executando o comando abaixo:"
echo -e "ssh "$LOGNAME"@"$glive_server" \"zegrep -i --color=always '${PARAMETERS[0]}' $logsdir/${PARAMETERS[1]}\"$NC"
if [[ "$EMAIL" != "null" ]]
  then
    echo -e "
            \rE-mail: $EMAIL
            \rGloboid: $ID"
fi
ssh "$LOGNAME"@"$glive_server" "zegrep -i --color=always '${PARAMETERS[0]}' $logsdir/${PARAMETERS[1]}"