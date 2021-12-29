#!/bin/bash
# Script para verificar se o usuário
# é titular de uma familia na app
# globoid-relationship-manager e 
# remove-lo caso seja uma inconsistencia.

# Setting High Intensity Colors
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC="\033[0m"              # Reset Colors

# Creating array with all inputs
while test -n "$1"
do
	PARAMETERS[i]="$1"
	let i++
	shift
done

USAGE_MSG="
	Script para verificar se o usuário é titular de uma familia na app	
	globoid-relationship-manager e remove-lo caso seja uma inconsistencia.

	KB0019910 - https://globoservice.service-now.com/kb_view.do?sysparm_article=KB0019910

	Usage: $(basename "$0") <options> [<e-mail> | <globoid>]

	Options:
		<empty>			to check user owner status in globoid-relationship-manager
		-d --delete		to remove inconsistent user owner status in globoid-relationship-manager

	Usage Examples:
		$(basename "$0") -d operacao.producao@ig.com
		$(basename "$0") operacaowebmedia@corp.globo.com
		$(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039

"

# Validate parameters and get globoid from email or email from globoid
if [ "${PARAMETERS[0]}" != "" ]
    then
	if [[ "${#PARAMETERS[@]}" == 1 ]]
		then
		ALVO="${PARAMETERS[0]}"
	else
    	ALVO="${PARAMETERS[1]}"
	fi
    INPUT=$(echo -e $ALVO | grep -i '@')
    CLIENTID="developer"
    if [ "$INPUT" != "" ]
    	then
        EMAIL="$ALVO"
        GLBID=$(curl -X GET http://be.glive.globoi.com/v2/users/email/$EMAIL -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.globoId')
    else
        EMAIL=$(curl -X GET http://be.glive.globoi.com/v2/users/$ALVO -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.email')
        GLBID="$ALVO"
    fi
fi

# Get temporary Backstage Token credentials
	#CLIENTID="ED18X/QpMi3c2QCHYAXBJQ=="
	#CLIENTSECRET="9uhifXndtjh7MKg5R0ng1g=="
	#BASIC_TOKEN=$(/usr/bin/python3 -c "import base64; print(base64.b64encode(b'$CLIENTID:$CLIENTSECRET'))" | sed 's/b//g')
	BASIC_TOKEN="RUQxOFgvUXBNaTNjMlFDSFlBWEJKUT09Ojl1aGlmWG5kdGpoN01LZzVSMG5nMWc9PQ=="
	TOKEN_BS=$(curl -sS --location --request POST 'https://accounts.backstage.globoi.com/token' \
	--header "Content-Type: application/x-www-form-urlencoded" \
	--header "Authorization: Basic $BASIC_TOKEN" \
	--data-urlencode "grant_type=client_credentials" | jq -r '.access_token')

function check_rm {
	# Get relationship manager family type user
	curl -sS --location --request GET "https://relationship-manager.backstage.globoi.com/relation/info?user_id=$GLBID&service_id=6778" --header "Authorization: Bearer $TOKEN_BS" | jq
}

function delete_rm {
	# Get relationship manager family type user
	curl -sS --location --request DELETE "https://relationship-manager.backstage.globoi.com/relation/user/$GLBID/service/6778" --header "Authorization: Bearer $TOKEN_BS" | jq
}

# Main program
if [[ "${PARAMETERS[0]}" != "" && "${#PARAMETERS[@]}" == 1 ]]
	then
	echo -e "curl -sS --location --request GET \"https://relationship-manager.backstage.globoi.com/relation/info?user_id=$GLBID&service_id=6778\" --header \"Authorization: Bearer $TOKEN_BS\" | jq"
	check_rm
elif [[ "${#PARAMETERS[@]}" == 2 && "${PARAMETERS[0]}" == "-d" || "${#PARAMETERS[@]}" == 2 && "${PARAMETERS[0]}" == "--delete" ]]
	then
	echo -e "$IYellow[ ATENÇÃO ]$NC O WA será aplicado para que o "$IBlue"relationship-manager$NC não reconheça o usuário infromado como titular da família. Tem certeza que deseja continuar? (s para sim ou n para não)"
	read option
    while [[ "$option" != "s" && "$option" != "n" ]]
    do
      echo -e "$IRed Opção Inválida! Tente novamente (\"s\" para sim ou \"n\" para não): $NC"
      read option
    done
	if [[ $option == "s" ]]
		then
		echo -e "curl -sS --location --request DELETE \"https://relationship-manager.backstage.globoi.com/relation/user/$GLBID/service/6778\" --header \"Authorization: Bearer $TOKEN_BS\" | jq"
		delete_rm
		result="$(check_rm)"
		if [[ $result == "{}" ]]
			then
			echo -e "$result"
			echo -e "O WA foi aplicado com sucesso!"
		fi
	else
		echo -e "Nenhuma alteração foi realizada!"
		exit 0
	fi
else
	echo -e "$USAGE_MSG"
fi