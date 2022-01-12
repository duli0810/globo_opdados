#!/usr/bin/env bash
# Funciona como comando para facilitar a checagem da data
# de expiração do certificado SSL de uma URL.
#
# Criado em 24/10/2020
# Autor: Leonardo Ferreira de Brito <leonardo.brito@g.globo>
# Versão: 1.0 

# Definindo cores de intensidade alta
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC="\033[0m"              # Reset Colors

# Criando um arranjo com todas as entradas
while test -n "$1"
do
	PARAMETERS[i]="$1"
		let i++
	shift
done

USAGE_MSG="
Funciona como comando para facilitar a checagem da data
de expiração de do certificado SSL de uma URL.

 	Uso:  $(basename "$0") <URL> 
 	OPTIONS:
 		<URL>    URL com suporte a SSL
		        
	Examplos de uso:
		$(basename "$0") globoid-connect.be.globoi.com
		$(basename "$0") cocoon.globo.com
"

# Mostra a mensagem de ajuda quando necessario
while echo "${PARAMETERS[0]}" | egrep -q '(^$|^\-h$|^\-{0,}help$)' || [[ ${#PARAMETERS[@]} < "1" ]]
do
	echo -e "$USAGE_MSG"
	exit 0
done

# Programa principal
echo | openssl s_client -servername "${PARAMETERS[0]}" -connect "${PARAMETERS[0]}":443 2>/dev/null | openssl x509 -noout -dates
