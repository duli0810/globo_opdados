#!/usr/bin/env bash

########################## INFORMAÇOES ##########################################
#
#Nome do Script : operatorowner.sh
#Descriçao      : Verifica o proprietario da conta atrelado ao GloboID consultado.
#Autor          : Eduardo Rodrigues da Silva
#Email          : eduardo.rodrigues@g.globo
#Equipe         : Operaçao Dados
#versao         : 1.0
#Complemento    : KB00xxxx
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

$IYellow
        Estrutura: ./operatorowner.sh <E-mail or GloboID> <Ano+Mês>$NC

        Exemplos:
                ./operatorowner.sh luiz.utikava@gmail.com 202203       
                ./operatorowner.sh da6a8e08-18c0-41fa-b59b-0db6c4e9d2c3 202203  $NC

        $IGreen Verifica o proprietario da conta atrelado ao GloboID consultado. 
        Auxilia nas SCTASKs - Usuário desconhecido associado à Operadora - $NC                 
"

###################### DECLARANDO VARIAVEL ############################
hoje=$(date +"%m-%Y")
data="$2"
###################### DECLARANDO VARIAVEL ############################
if [[ "$1" != "" ]]
    then
        dado="$1"
        verifica=$(echo -e $dado | grep -i '@')

        if [[ "$verifica" != "" ]]
             then
                 EMAIL=$dado     
                 GLBID=$(curl -X GET http://be.glive.globoi.com/v2/users/email/$EMAIL -H 'Backstage-Client-Id: 'developer'' -s | jq -r '.globoId')
                 #echo -e "\n O usuario de e-mail $EMAIL possui o GloboID $GLBID\n"
             else
             	 GLBID=$dado
             	 EMAIL=$(curl -X GET http://be.glive.globoi.com/v2/users/$dado -H 'Backstage-Client-Id: 'developer'' -s | jq -r '.email') 
                 #echo -e "\n O usuario de e-mail $EMAIL possui o GloboID $GLBID\n"
    fi
fi        



LogResult()

{

#echo -e "Comando executado: ssh -t "$LOGNAME"@10.134.0.215 zegrep -ni --color=always "owner.*$GLBID" /mnt/projetos/logs/gsat_multi/be/app-*$data*"
#ssh -t eduardo.rodrigues@10.134.0.215 zegrep -ni --color=always "owner.*$GLBID" /mnt/projetos/logs/gsat_multi/be/app-*202203*
log=$(ssh -t "$LOGNAME"@10.134.0.215 zegrep -ni --color=always "owner.*$GLBID" /mnt/projetos/logs/gsat_multi/be/app-*$data*)

if [ "$log" != "" ]
        then

            echo -e "$IYellow\nLocalizado o(s) Log(s) do usuario$NC $IGreen$EMAIL, $IYellow GloboID $IGreen$GLBID : \n$NC"
            echo -e "\n$log\n" 
        
else
            echo -e "$IYellow\n Não foram localizados logs para o usuário $IGreen $EMAIL ($GLBID) $IYellow que evidencie a associação a operadora. 
Favor solicitar nova tentativa de associação, para assim gerar logs mais recentes.\n$NC"
fi         

}
###################### MAIN ###########################################

if [ "$1" != "" ]
        then
        LogResult
        
else
        echo -e "$help"
fi          
