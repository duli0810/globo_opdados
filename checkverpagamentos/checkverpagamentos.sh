#!/usr/bin/env bash

########################## INFORMAÇOES ##########################################
#
#Nome do Script : checkverpagamentos.sh
#Descriçao      : Verifica a opcao ver pagamentos esta habilitada.
#Autor          : Eduardo Rodrigues da Silva
#Email          : eduardo.rodrigues@g.globo
#Equipe         : Operaçao Dados
#versao         : 1.0
#Complemento    : KB0105502 - [GloboID] – Verificar "Opção Ver Pagamentos"
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
                     *** OPÇÃO VER PAGAMENTO ***                
$NC
$IYellow
        Estrutura: ./checkverpagamentos.sh <E-mail or GloboID>$NC

        Exemplos:
                ./checkverpagamentos.sh luiz.utikava@gmail.com       
                ./checkverpagamentos.sh da6a8e08-18c0-41fa-b59b-0db6c4e9d2c3  $NC

        $IGreen Verifica a opcao ver pagamentos esta habilitada - $NC                 
"

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

###################### FUNÇÃO - OPCAO VER PAGAMENTO ############################

OpcaoPagamentos()

{

pay=$(curl -X GET http://be.glive.globoi.com/v2/users/$GLBID/subscription/status -H 'Backstage-Client-Id: 'developer'' -s | jq .status)

if [ "$pay" == "\"SALESFORCE\"" ]
        then

            echo -e "$IYellow\nO usuário (a) $IGreen$EMAIL$IYellow, GloboID $IGreen$GLBID$IYellow é considerado assinante $IGreen$pay,$IYellow portanto a opção ver pagamento deve esta habilitada.\n$NC" 
             
            curl -X GET http://be.glive.globoi.com/v2/users/$GLBID/subscription/status -H 'Backstage-Client-Id: 'developer'' -s | jq
        
else
            echo -e "$IYellow\nO usuário (a) $IGreen$EMAIL$IYellow, GloboID $IGreen$GLBID$IYellow é considerado um usuário(a) $IGreen$pay,$IYellow portanto a opção ver pagamento$IGreen NÃO$IYellow deve esta habilitada.\n$NC" 
             
            curl -X GET http://be.glive.globoi.com/v2/users/$GLBID/subscription/status -H 'Backstage-Client-Id: 'developer'' -s | jq
fi         

}
###################### MAIN ###########################################

if [ "$1" != "" ]
        then
        OpcaoPagamentos
        
else
        echo -e "$help"
fi          
