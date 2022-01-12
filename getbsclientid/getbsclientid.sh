#!/usr/bin/env bash
# Script para pegar infromações sobre
# backstage client id informado

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
	Script para pegar infromações sobre o backstage client id infromado.

	Usage: $(basename "$0") <Backstage Client ID>

	Usage Examples:
		$(basename "$0") a+S86nPZwXXHL1KQYgpMyw==
		$(basename "$0") lgPkAwoq9GJ8ADdqPX9DNQ==
		$(basename "$0") bwNvg542TDFC4V0ofH0zIQ==

"
function get_bs_clientid {
    BSCLIENTID="${PARAMETERS[0]}"
	# Get temporary Backstage Token credentials
	#CLIENTID="ED18X/QpMi3c2QCHYAXBJQ=="
	#CLIENTSECRET="9uhifXndtjh7MKg5R0ng1g=="
	#BASIC_TOKEN=$(/usr/bin/python3 -c "import base64; print(base64.b64encode(b'$CLIENTID:$CLIENTSECRET'))" | sed 's/b//g')
	BASIC_TOKEN="RUQxOFgvUXBNaTNjMlFDSFlBWEJKUT09Ojl1aGlmWG5kdGpoN01LZzVSMG5nMWc9PQ=="
	TOKEN_BS=$(curl -sS --location --request POST 'https://accounts.backstage.globoi.com/token' \
	--header "Content-Type: application/x-www-form-urlencoded" \
	--header "Authorization: Basic $BASIC_TOKEN" \
	--data-urlencode "grant_type=client_credentials" | jq -r '.access_token')

	# Get Backstage Clientid infos
	curl -sS -H "Accept: application/json" -H "Authorization: Bearer $TOKEN_BS" "https://accounts.backstage.globoi.com/apps/$BSCLIENTID" | jq
}

# Main program
if [ "${PARAMETERS[0]}" != "" ]
	then
	get_bs_clientid
else
	echo -e "$USAGE_MSG"
fi