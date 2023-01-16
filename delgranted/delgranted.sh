#!/usr/bin/env bash

########################## INFORMAÇOES ##########################################
#
#Nome do Script : delgranted.sh
#Descriçao      : Deleta o dependente, onde owner ou próprio dependente (granted) não cosegue sair da familia. 
#Autor          : Eduardo Rodrigues da Silva
#Email          : eduardo.rodrigues@g.globo
#Equipe         : Operaçao Dados
#versao         : 1.0
#Complemento    : KB0105132
#                  
#
#################################################################################

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

###################### DEFININDO MESSAGEM DE HELP SCRIPT ##############

help="
               ######## *** HELP SCRIPT *** ######## 
$IPurple
                     *** DELETE GRANTED *** 
$NC
$IYellow
        Estrutura: ./delgranted.sh <globoid owner> <globoid granted> $NC

        Exemplos:
                ./delgranted.sh b8b2c132-554f-48f4-8199-6fd8658e8d0a eef43519-d1e0-4a50-b813-5a9c2d0dd340      
                
        $IGreen Remove o dependente, onde Titular (owner) ou próprio dependente (granted) não cosegue sair da familia. $NC                 
"

###################### DECLARANDO VARIAVEL ############################

owner=$1
granted=$2

############################# DELETE GRANTED ###############################
Del()

{

BSToken=$(curl -sS --location --request POST 'https://accounts.backstage.globoi.com/token' --header 'Content-Type: application/x-www-form-urlencoded' --header 'Authorization: Basic RUQxOFgvUXBNaTNjMlFDSFlBWEJKUT09Ojl1aGlmWG5kdGpoN01LZzVSMG5nMWc9PQ==' --data-urlencode 'grant_type=client_credentials' | jq -r '.access_token')

echo -e "\n$BSToken\n"


curl --location --request DELETE 'https://be.globoid-family-api.globoi.com/v1/user/granted' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer '$BSToken'' \
--data-raw "{
    \"grantedID\": \"$granted\",
    \"ownerID\": \"$owner\",
    \"origin\": \"Exclusão por OP Dados\"
}"

echo -e "$IYellow\nRemovido o dependente$NC $IGreen$granted do $IYellow Titular $IGreen$owner \n$NC"

}

###################### MAIN ###########################################

if [ "$1" != "" ]
        then
        Del
        
else
        echo -e "$help"
fi          

## Rascunho ##
#curl --location --request DELETE 'https://be.globoid-family-api.globoi.com/v1/user/granted' \
#curl --location --request DELETE 'https://be.globoid-family-api.globoi.com/v1/user/granted' \
#curl --location --request DELETE 'https://globoid-family-api.backstage.globoi.com/v1/user/granted' \
#./delgranted.sh operacaowebmedia@corp.globo.com op.videos@corp.globo.com
