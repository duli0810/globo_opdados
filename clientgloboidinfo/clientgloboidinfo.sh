#!/usr/bin/env bash
#
# Segue abaixo novo link para trazer os dados do glive
# curl -s eva-int.globoi.com/user/$GLBID
#

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
        $(basename "$0") leonardo.brito@corp.globo.com
        $(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039

"
if [[ "${PARAMETERS[0]}" != "" ]]
    then
        ALVO="${PARAMETERS[0]}"
        INPUT=$(echo -e $ALVO | grep -i '@')
        CLIENTID="developer"
        if [[ "$INPUT" != "" ]]
            then
                EMAIL="$ALVO"
                LEGACY_ID=$(curl -X GET http://be.glive.globoi.com/v2/users/email/$EMAIL -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.legacyUserId')
                GLBID=$(curl -X GET http://be.glive.globoi.com/v2/users/email/$EMAIL -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.globoId')
            else
                EMAIL=$(curl -X GET http://be.glive.globoi.com/v2/users/$ALVO -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.email')
                LEGACY_ID=$(curl -X GET http://be.glive.globoi.com/v2/users/$ALVO -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -r '.legacyUserId')
                GLBID="$ALVO"
        fi

        ## Validação no eva-int
        echo -e "$IYellow\nVALIDAÇÃO NA APP EVA-INT-PROD \n$IPurple(http://eva-int.globoi.com/cliente/valida/$ALVO): $NC"
        curl -sX GET http://eva-int.globoi.com/cliente/valida/$ALVO | jq -c
        
        ## Informações do usuário
        #echo -e "$IYellow\n\nINFORMAÇÕES DO USUÁRIO PELO VENDAS-GLIVE \n$IPurple(https://vendas-glive.be.globoi.com/vendas-glive/api/glive/v2/usuario/email/$EMAIL): $NC"
        #curl -sX GET https://vendas-glive.be.globoi.com/vendas-glive/api/glive/v2/usuario/email/$EMAIL | jq
        echo -e "$IYellow\n\nINFORMAÇÕES DO USUÁRIO PELO GLIVE $NC"
        if [[ "$INPUT" != "" ]]
            then
                curl -sX GET http://be.glive.globoi.com/v2/users/email/$EMAIL -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq
            else
                curl -sX GET http://be.glive.globoi.com/v2/users/$GLBID -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq
        fi
        
        ## Exibindo os serviços do usuário
        # Contruindo um array com a lista de nomes dos serviços provisionados
	    SERVICESNAME=$(curl -sX GET http://vendas-api.globoi.com:80/vendas-api/usuarios/$LEGACY_ID/servicos -H 'Backstage-Client-Id: '$CLIENTID'' | jq -c 'map(.descricao)' | sed 's/\"//g' | sed 's/\[//g' | sed 's/\]//g')
	    IFS="," read -a SERVICESNAME_LIST <<< $SERVICESNAME
	    # Construindo um array com a lista de serviços, com informações detalhadas, provisionados
	    SERVICESDETAIL=$(curl -sX GET http://be.glive.globoi.com/v2/users/$GLBID/services -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq -c '.[]')
	    SERVICESDETAIL_LIST=($SERVICESDETAIL)
	    # Fazendo um merge entre os arrays dos nomes dos serviços e seus detalhes
	    lenght="${#SERVICESDETAIL_LIST[@]}"
	    for (( i=0; i<$lenght; i++));
	    do
	    	SERVICESDETAIL_LIST[$i]=$(echo ${SERVICESDETAIL_LIST[$i]} | jq --arg description "${SERVICESNAME_LIST[$i]}" '. + {description: $description}')
	    done
        echo -e "$IYellow\n\nINFORMAÇÕES DETALHADAS DOS SERVIÇOS DO USUÁRIO PELO GLIVE $NC"
        echo -e ${SERVICESDETAIL_LIST[@]} | jq

#        ## Lista de serviços do usuário
#        if [[ "$LEGACY_ID" != "" ]]
#            then
#                echo -e "$IYellow\nSERVIÇOS DO USUÁRIO \n$IPurple(http://vendas-api.globoi.com:80/vendas-api/usuarios/$LEGACY_ID/servicos): $NC"
#                echo -e "$IYellow\nCadunID do Usuario: $LEGACY_ID $NC"
#                #curl -sX GET http://vendas-api.globoi.com:80/vendas-api/usuarios/$LEGACY_ID/servicos -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq '.[] | { "ID do Servico": .servicoId, Descricao: .descricao, Status: .statusUsuarioServico }'
#                SERVICENAME_LIST=$(curl -sX GET http://vendas-api.globoi.com:80/vendas-api/usuarios/$LEGACY_ID/servicos -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq '.[] | { ServicoId: .servicoId, Descricao: .descricao, Status: .statusUsuarioServico }')
#                echo $SERVICENAME_LIST | jq
#        fi
#        
#        ## Detalhamento dos serviços do usuário
#        if [[ "$GLBID" != "" ]]
#            then
#                echo -e "$IYellow\n\nINFORMAÇÕES DETALHADAS DOS SERVIÇOS DO USUÁRIO PELO GLIVE \n$IPurple(http://be.glive.globoi.com/v2/users/$GLBID/services): $NC"
#                #curl -sX GET http://be.glive.globoi.com/v2/users/$GLBID/services -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq '.[]'
#                SERVICE_PROP=$(curl -sX GET http://be.glive.globoi.com/v2/users/$GLBID/services -H 'Backstage-Client-Id: '$CLIENTID'' -s | jq '.[]')
#                echo "$SERVICE_PROP" | jq
#        fi
        echo -e "\n\n"
    else
        echo -e "$USAGE_MSG"
fi