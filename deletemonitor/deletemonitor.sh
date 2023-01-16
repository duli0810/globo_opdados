#!/usr/bin/env bash

########################## INFORMAÇOES ##########################################
#
#Nome do Script : deletemonitor.sh.sh
#Descriçao      : Remove a monitoração dos hosts informados no arquivo
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

###################### DEFININDO MESSAGEM DE HELP SCRIPT ##############

help="
               ######## *** HELP SCRIPT *** ######## 

$IRed ATENÇAO: Necessário criar um arquivo .TXT contendo todos os HOSTS a deletar.  
                          Salva-lo no diretorio do script $NC

$IYellow
        Estrutura: ./deletemonitor.sh <NomedoArquivoTXT> $NC

        Exemplos:
                ./deletemonitor.sh host.txt $NC

$IGreen Será removida a monitoração dos hosts informados no arquivo. $NC                 
"

###################### DECLARANDO VARIAVEL ############################
txt=$1
hoje=$(date +"%d-%m-%y_%H:%M:%S")
######################  GERANDO RESULTADO  ############################

delete_monitor ()

{
for host in $(cat $txt);
 do

#Gerando BSToken
bstoken="$(curl --request POST 'https://api.zabbix.globoi.com/api/v4/user/Login' \
                                -H "Content-Type: application/json" \
                                --data-raw  '{ "params" : { "user": "hardview.api", "password": "E#gcuTgW5pAP"}}'| jq -r '.result')"

# Remove a monitoração dos hosts informados no arquivo
curl --request DELETE https://api.zabbix.globoi.com/api/v4/delete/Monitors?host=$host \
                                -H "Content-Type: application/json" -H "auth: $bstoken"
echo -e "\n$bstoken\n"
echo -e "\nRemovida a monitoração dos hosts informados em $1\n"

done

}

###################### MAIN ###########################################

if [ "$1" != "" ]
        then
        delete_monitor
        #cat CheckResult_$hoje.txt
else
        echo -e "$help"
fi
