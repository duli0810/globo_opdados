#!/bin/bash

########################## INFORMAÇOES ##########################################
#
#Nome do Script : domainblacklist.sh
#Descriçao      : Verifica se dominio esta presente no Black list da Globo
#Autor          : Eduardo Rodrigues da Silva
#Email          : eduardo.rodrigues@g.globo
#Equipe         : Operaçao Dados
#versao         : 1.0
#Complemento    : ******
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

###################### DECLARANDO VARIAVEL ############################

z=$1

###################### DEFININDO MESSAGEM DE HELP SCRIPT ##############

help="
      ######## *** HELP SCRIPT *** ######## 
$IYellow
        Estrutura: ./domainblacklist <domain> $NC

        Exemplos:
                ./domainblacklist globo.com $NC
"
###################### ANALISANDO URL ##################################

check_url ()
{
 
x="$(curl -sS http://be.glive.globoi.com/domain/$z/blacklist)"

if [[ $x == "" ]]; then

	echo -e "$IYellow\nDOMINIO CONFIAVEL\n"

else 

	echo -e "$IGreen\n$x\n"
	echo -e "$IYellow\nDOMINIO EM BLACK LIST\n"

fi
}
###################### MAIN ###########################################

if [ "$z" != "" ]
        then
        check_url
else
        echo -e "$help"
fi


