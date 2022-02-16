#!/usr/bin/env bash
# Funciona como comando para trazer informações da 
# globoid-famaly-api de qualquer usuário cadastrado.
# - permite aplicar WAs;
# 
# Criado em 05/11/2021
# Autor: Leonardo Ferreira de Brito <leonardo.brito@g.globo>
# Versão: 1.0

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

# Global Variables
CANTBEDEPENDENT_SVCS=(
						1 84 151 1007 3033 6004 6445 
						6750 6752 6753 6754 6755 6756 
						6757 6758 6760 6761 6762 6763 
						6764 6765 6766 6768 6769 6771 
						6772 6773 6774 6807 6828
					)

# Creating array with all inputs
while test -n "$1"
do
	PARAMETERS[i]="$1"
	let i++
	shift
done

# KB0014851 - https://globoservice.service-now.com/kb_view.do?sysparm_article=KB0014851
# Problema onde o titular perdeu indevidamente a conta e/ou os relacionamentos com seus dependentes. Em situações normais, o próprio titular precisa enviar um convite para o convidado. Esse passo a passo precisa ser feito com muito cuidado!
# 
# 1 - Verificar se o usuário titular está realmente inconsistente do lado de GloboID, para isso consultar a rota abaixo /type.
# 	  Caso a rota /type retorne que o usuário é um "No-Family" mesmo ele tendo direito ao produto no lado da Salesforce, é necessária a criação da Família através do endpoint da etapa 2.
# 	  Caso a rota /type retorne "Granted" o usuário se encontra como dependente nos sistemas GloboID e ele pode ser tratado com a rota abaixo, tendo certeza de que o usuário realmente não é um dependente e sim um titular
# 	  Caso a rota /type retorne "Owner" o usuário titular está válido, passe para a etapa 3.
#
# 	  curl --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/type/<$GLBID_OWNER> -H "Authorization: Bearer $TOKEN_BS"
#  
# 
# 2 - Rota de criação de família
# 	  Antes de executar esse comando, é necessário confirmar que o usuário é realmente um assinante com direito a dependentes e quantos dependentes podem ser incluídos na família (o tamanho máximo).
# 	  Atenção! a rota abaixo pode transformar um dependente em titular, conferir os dados antes de chamá-la. 
#
# 	  curl -X POST -H "Content-Type: application/json" https://globoid-family-api.backstage.globoi.com/v1/user/family -d '{"OwnerId": "$GLBID_OWNER", "size": $SIZE_FAMILY}' -H "Authorization: Bearer $TOKEN_BS" -v
# 
# 
# 3 – Confirme a família do titular na rota /owners para ver se o dependente realmente não está na família.
# 	  Caso globoid do dependente já esteja na listagem do titular, este WA não é adequado. Volte para a análise. Pode ser necessário o acerto diretamente na base Salesforce.
# 
# 	  curl --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/family/owners/<$GLBID_OWNER> -H "Authorization: Bearer $TOKEN_BS" -v
#
#
# 4 - Verificar se o usuário dependente não está em nenhuma família do lado de GloboID, para isso consultar a rota abaixo /type.
# 	  Caso o usuário seja do tipo "Granted" ou "Owner", o WA não é adequado. Voltar para análise.
# 	  Caso o usuário seja do tipo "No-Family", continue com o WA.
# 
# 	  curl --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/type/<$GLBID_DEPENDENT> -H "Authorization: Bearer $TOKEN_BS"
# 	  
#  
# 5 – Criar a relação entre o titular e o dependente
# 	  Atenção! Essa operação não pode ser facilmente desfeita! Conferir globoids do titular e dependente.
#   
# 	  curl -X POST -H 'Content-Type: application/json' https://globoid-family-api.backstage.globoi.com/internal/granted/relation -d '{\"ownerID\": \"$GLBID_OWNER\", \"grantedID\": \"$GLBID_DEPENDENT\"}' -H 'Authorization: Bearer $TOKEN_BS' -v
#   
# 	  Repetir a etapa 3 para confirmar que o dependente entrou para a família do titular. Caso contrário, chamar a etapa 5 novamente.
#
# 
# 6 – Atualizar serviços do titular para o dependente
# 	  Atenção! Conferir os serviços do titular antes de chamar essa rota, pois ela replicará os serviços do titular para seus dependentes.
# 
# 	  curl --location --request PUT https://globoid-family-api.backstage.globoi.com/v1/user/family/services  --header 'Content-Type: application/json' --data-raw '{\"globoid\": \"$GLBID\"}' -H \"Authorization: Bearer $TOKEN_BS\" -v
#
#
# 7 - Remoção de familia 
# Atenção! Essa rota nao irá remover a família caso o usuário possua serviços ATIVOS que concedam perfil OWNER no Family API. Caso a rota nao funcione, é necessário avaliar qual serviceID está forçando o usuário a ter a familia em questão
# 
#     curl --location --request PUT https://be.globoid-family-api.globoi.com/v1/user/family/services --header 'Content-Type: application/json' --data-raw '{\"globoid\": \"$GLBID\"}' -v
# 

USAGE_MSG="
	Utilizado para trazer as infromações de família na globoid-family-api de um usuário 
	cadastrado no Glive e também aplicar WAs pertinentes, confrome documentação abaixo:

	KB0014851 - https://globoservice.service-now.com/kb_view.do?sysparm_article=KB0014851

	Usage: 
		$(basename "$0") <options> [<e-mail>|<globoid>]
		$(basename "$0") [ -r | --create-relation ] <owner_globoid> <dependent_globoid>
	
	Options:
    	-h, --help                      show this help msg.
    	-f, --create-family <size>      WA to create the owner's family. It is 
					necessary to inform the family size, that is, 
					the number of dependents. The size parameter 
					must be an integer.
    	-r, --create-relation           WA to create owner-dependent relationship.
	-u, --update-services		WA to update services from owner to dependent.
		-d, --delete-family				WA to delete family.

	Usage Examples:
		$(basename "$0") operacao.producao@ig.com
		$(basename "$0") -f 4 operacao.producao@ig.com
		$(basename "$0") operacaowebmedia@corp.globo.com
		$(basename "$0") -r b8b2c132-554f-48f4-8199-6fd8658e8d0a eef43519-d1e0-4a50-b813-5a9c2d0dd340
		$(basename "$0") 0cbbac12-a156-44f0-8447-c56a087c9039
		$(basename "$0") -u b8b2c132-554f-48f4-8199-6fd8658e8d0a
		$(basename "$0") --update-services b8b2c132-554f-48f4-8199-6fd8658e8d0a
		$(basename "$0") -d operacao.producao@ig.com
		$(basename "$0") --delete-family operacao.producao@ig.com

"

# Validate parameters and get globoid from email or email from globoid
if [[  
		"${PARAMETERS[0]}" != "" && \
		"${PARAMETERS[0]}" != "-r" && \
		"${PARAMETERS[0]}" != "--create-relation" && \
		"${PARAMETERS[0]}" != "-h" && \
		"${PARAMETERS[0]}" != "--help"
	]]
    then
	if [[ "${#PARAMETERS[@]}" == 1 ]]
		then
	    ALVO="${PARAMETERS[0]}"
    elif [[ ${#PARAMETERS[@]} == 3 ]]
		then
		ALVO="${PARAMETERS[2]}"
	else
		ALVO="${PARAMETERS[1]}"
	fi
	INPUT=$(echo -e $ALVO | grep -i '@')
    CLIENTID="developer"
    if [[ "$INPUT" != "" ]]
    	then
        EMAIL="$ALVO"
        GLBID=$(curl -sX GET http://be.glive.globoi.com/v2/users/email/$EMAIL -H 'Backstage-Client-Id: '$CLIENTID'' | jq -r '.globoId')
		LEGACY_ID=$(curl -sX GET http://be.glive.globoi.com/v2/users/email/$EMAIL -H 'Backstage-Client-Id: '$CLIENTID'' | jq -r '.legacyUserId')
    else
        EMAIL=$(curl -sX GET http://be.glive.globoi.com/v2/users/$ALVO -H 'Backstage-Client-Id: '$CLIENTID'' | jq -r '.email')
        GLBID="$ALVO"
		LEGACY_ID=$(curl -sX GET http://be.glive.globoi.com/v2/users/$ALVO -H 'Backstage-Client-Id: '$CLIENTID'' | jq -r '.legacyUserId')
    fi
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
fi

# Get temporary Backstage Token credentials
TOKEN_BS=$(curl -sS --location --request POST 'https://accounts.backstage.globoi.com/token' \
			--header 'Content-Type: application/x-www-form-urlencoded' \
			--header 'Authorization: Basic RUQxOFgvUXBNaTNjMlFDSFlBWEJKUT09Ojl1aGlmWG5kdGpoN01LZzVSMG5nMWc9PQ==' \
			--data-urlencode 'grant_type=client_credentials' | jq -r '.access_token')

function read_option {
	read option
    while [[ "$option" != "s" && "$option" != "n" ]]
    do
      echo -e "$IRed Opção Inválida! Tente novamente ($IYellow\"s\"$NC para sim ou $IYellow\"n\"$NC$IRed para não): $NC"
      read option
    done
	if [[ $option == "s" ]]
		then
		echo -e "$IYellow\nExecutando o comando:$NC$IBlue\n$1\n$NC"
		eval "$1"
	else
		echo -e "Nenhuma alteração foi realizada!"
		exit 0
	fi
}

function check_family {
	if [[ $GLBID == "null" ]]
		then
		echo -e "$IRed\nNão existe cadastro no Glive para a conta informada!$NC"
		exit 1
	fi

	# Get family type user
	USER_TYPE=$(curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/type/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -r '.type')
	echo -e "$IYellow\nExecutando o seguinte comando para verificar o tipo de usuário:$NC"
	echo -e "curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/type/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -r '.type'"

	# Get family from owner user
	if [[ "$USER_TYPE" == "owner" ]]
		then
		OWNER_FAMILY=$(curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/family/owners/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -C '.')
		echo -e "$IYellow\nO usuário $IBlue$EMAIL$IYellow, globoid $IBlue$GLBID$IYellow, é considerado$IBlue titular$IYellow da familia! $NC"
		echo -e "$IYellow\nExecutando o seguinte comando para trazer as informaçÕes da família do usuário:$NC"
		echo -e "curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/family/owners/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -C '.'"
		echo -e "\n$OWNER_FAMILY\n"
	elif [[ "$USER_TYPE" == "granted" ]]
		then
		# Get owner family from dependent user
		DEPENDENT_FAMILY=$(curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/granteds/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -C '.')
		echo -e "$IYellow\nO usuário $IBlue$EMAIL$IYellow, globoid $IBlue$GLBID$IYellow, é considerado$IBlue $USER_TYPE$IYellow, ou seja,$IBlue dependente$IYellow.$NC"
		echo -e "$IYellow\nExecutando o seguinte comando para trazer as informaçÕes da família do usuário:$NC"
		echo -e "curl -sS --location --request GET https://globoid-family-api.backstage.globoi.com/v1/user/granteds/$GLBID -H 'Authorization: Bearer '$TOKEN_BS'' | jq -C '.'"
		echo -e "$DEPENDENT_FAMILY\n"
	else
		echo -e "$IYellow\nO usuário $IBlue$EMAIL$IYellow, globoid $IBlue$GLBID$IYellow, é considerado$IBlue $USER_TYPE$IYellow!$NC\n"
	fi
	if [[ "$USER_TYPE" == "owner" || "$USER_TYPE" == "no-family"  ]]
		then
		echo -e ""$IYellow"SERVIÇOS DE ASSINANTE DO USUÁRIO QUE PODEM IMPEDÍ-LO DE SE TORNAR UM POSSíVEL DEPENDENTE"$NC""
		index=0
		output=()
		for detailedservice in "${SERVICESDETAIL_LIST[@]}"
		do
			detailedserviceid=`echo $detailedservice | jq '."serviceId"'`
			for service in "${CANTBEDEPENDENT_SVCS[@]}"
			do
				if [[ $detailedserviceid == $service ]]
				then
					output[$index]=$detailedservice
				fi
			done
			index=`expr $index + 1`
		done
		if [[ ${#output[@]} != 0 ]]
		then
			echo -e ${output[@]} | jq
		else
			echo -e ""$IRed"Não foi encontrado nenhum serviço impeditivo!"$NC"\n"
		fi
	fi
}

function create_family {
	SIZE_FAMILY="${PARAMETERS[1]}"
	echo -e "$IYellow[ ATENÇÃO ]$NC O WA será aplicado para criação da familia do titular, $IYellow$GLBID$NC, com direito a $IYellow$SIZE_FAMILY$NC dependentes. \nAntes de executar esse comando, é necessário confirmar que o usuário é realmente um assinante com direito a dependentes e quantos dependentes podem ser incluídos na família. \nEsse WA pode transformar um dependente em titular, conferir os dados antes de executá-lo. \nTem certeza que deseja continuar? ($IYellow\"s\"$NC para sim ou $IYellow\"n\"$NC para não)"
	read_option "curl -X POST -H \"Content-Type: application/json\" https://globoid-family-api.backstage.globoi.com/v1/user/family -d '{\"OwnerId\": \"$GLBID\", \"size\": $SIZE_FAMILY}' -H \"Authorization: Bearer $TOKEN_BS\" -v"
}

function create_relation {
	GLBID_OWNER="${PARAMETERS[1]}"
	GLBID_DEPENDENT="${PARAMETERS[2]}"
	echo -e "$IYellow[ ATENÇÃO ]$NC O WA será aplicado para criação da relação entre o titular, $IYellow$GLBID_OWNER$NC, e o dependente, $IYellow$GLBID_DEPENDENT$NC. $IYellow\nEssa operação não pode ser facilmente desfeita! Conferir globoids do titular e dependente.$NC\n Tem certeza que deseja continuar? ($IYellow\"s\"$NC para sim ou $IYellow\"n\"$NC para não)"	
	read_option "curl -X POST -H 'Content-Type: application/json' https://globoid-family-api.backstage.globoi.com/internal/granted/relation -d '{\"ownerID\": \"$GLBID_OWNER\", \"grantedID\": \"$GLBID_DEPENDENT\"}' -H 'Authorization: Bearer $TOKEN_BS' -v"
}

function update_services {
	echo -e "$IYellow[ ATENÇÃO ]$NC O WA será aplicado para atualizar serviços de titular, $IYellow$GLBID$NC, em seus dependentes. $IYellow\nConferir os serviços do titular antes de chamar essa rota, pois ela replicará os serviços do titular para seus dependentes.$NC\n Tem certeza que deseja continuar? ($IYellow\"s\"$NC para sim ou $IYellow\"n\"$NC para não)"
	read_option "curl --location --request PUT https://globoid-family-api.backstage.globoi.com/v1/user/family/services  --header 'Content-Type: application/json' --data-raw '{\"globoid\": \"$GLBID\"}' -H \"Authorization: Bearer $TOKEN_BS\" -v"
}

function delete_family {
	echo -e "$IYellow[ ATENÇÃO ]$NC O WA será aplicado para deletar a família do suposto titular, $IYellow$GLBID$NC.\nEssa rota nao irá remover a família caso o usuário possua serviços ATIVOS que concedam perfil OWNER no Family API. Caso a rota nao funcione, é necessário avaliar qual serviceID está forçando o usuário a ter a familia em questão.$NC\n Tem certeza que deseja continuar? ($IYellow\"s\"$NC para sim ou $IYellow\"n\"$NC para não)"
	read_option "curl --location --request PUT https://be.globoid-family-api.globoi.com/v1/user/family/services --header 'Content-Type: application/json' --data-raw '{\"globoid\": \"$GLBID\"}' -v"
}

# Main program
if [[
		"${PARAMETERS[0]}" != "" && \
		"${PARAMETERS[0]}" != "-h" && \
		"${PARAMETERS[0]}" != "--help" && \
		"${PARAMETERS[0]}" != "-f" && \
		"${PARAMETERS[0]}" != "--create-family" && \
		"${PARAMETERS[0]}" != "-r" && \
		"${PARAMETERS[0]}" != "--create-relation" && \
		"${PARAMETERS[0]}" != "-d" && \
		"${PARAMETERS[0]}" != "--delete-family" && \
		"${PARAMETERS[0]}" != "-u" && \
		"${PARAMETERS[0]}" != "--update-services"
	]]
	then
	check_family
elif [[ "${PARAMETERS[0]}" == "-f" || "${PARAMETERS[0]}" == "--create-family" ]] && [[ ${#PARAMETERS[@]} == 3 ]]
	then
	create_family
elif [[ "${PARAMETERS[0]}" == "-r" || "${PARAMETERS[0]}" == "--create-relation" ]] && [[ ${#PARAMETERS[@]} == 3 ]]
	then
	create_relation
elif [[ "${PARAMETERS[0]}" == "-u" || "${PARAMETERS[0]}" == "--update-services" ]] && [[ ${#PARAMETERS[@]} == 2 ]]
	then
	update_services
elif [[ "${PARAMETERS[0]}" == "-d" || "${PARAMETERS[0]}" == "--delete-family" ]] && [[ ${#PARAMETERS[@]} == 2 ]]
	then
	delete_family
else
	echo -e "$USAGE_MSG"
fi