#!/bin/bash

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
	Usage: $(basename "$0") [<e-mail> | <globoid>]

	Usage Examples:
		$(basename "$0") operacao.producao@ig.com
		$(basename "$0") operacaowebmedia@corp.globo.com
		$(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039

"

# Validate parameters and get globoid from email or email from globoid
if [ "${PARAMETERS[0]}" != "" ]
    then
    ALVO="${PARAMETERS[0]}"
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

function check_family {
	# Get temporary Backstage Token credentials
	TOKEN_BS=$(curl -sS --location --request POST 'https://accounts.backstage.globoi.com/token' \
	--header 'Content-Type: application/x-www-form-urlencoded' \
	--header 'Authorization: Basic RUQxOFgvUXBNaTNjMlFDSFlBWEJKUT09Ojl1aGlmWG5kdGpoN01LZzVSMG5nMWc9PQ==' \
	--data-urlencode 'grant_type=client_credentials' | jq -r '.access_token')

	# Get family type user
	USER_TYPE=$(curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/type/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -r '.type')

	# Get family from owner user
	if [ "$USER_TYPE" == "owner" ]
		then
		OWNER_FAMILY=$(curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/family/owners/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -C '.')
		echo -e "$IYellow\nO usuário$IBlue $EMAIL$IYellow é considerado$IBlue titular$IYellow da familia! $NC"
		echo -e "\n$OWNER_FAMILY\n"
		
	elif [ "$USER_TYPE" == "granted" ]
		then
		echo -e "$IYellow\nO usuário$IBlue $EMAIL$IYellow é considerado$IBlue $USER_TYPE$IYellow, ou seja,$IBlue dependente$IYellow!$NC\n"
	else
		echo -e "$IYellow\nO usuário$IBlue $EMAIL$IYellow é considerado$IBlue $USER_TYPE$IYellow!$NC\n"
	fi
}

# Main program
if [ "${PARAMETERS[0]}" != "" ]
	then
	check_family
else
	echo -e "$USAGE_MSG"
fi