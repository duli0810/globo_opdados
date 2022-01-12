#!/usr/bin/env bash
# Funciona como comando para facilitar a checagem da existencia
# de logs de envio de e-mail para um determinado usuário
#
# Criado em 19/03/2020
# Autor: Leonardo Ferreira de Brito <leonardo.brito@g.globo>
# Versão: 1.0 

# Servidores do SMTPCAD
# temos 66 servidores
#'smtpcad-prod-bo-11.cmal22bo-198.cp.globoi.com'

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

# Definindo o servidores do smtpcad
smtpcad_server="smtpcad-prod-bo-11.cmal22bo-198.cp.globoi.com"

# iniciando a variável date
date_searched=""

# Criando um arranjo com todas as entradas
while test -n "$1"
do
	PARAMETERS[i]="$1"
	let i++
	shift
done

USAGE_MSG="
  Funciona como comando para facilitar a checagem da existencia
  de logs de envio de e-mail para um determinado usuário. Fique
  atento ao formato da data a ser pesquisada e a observação.

  Uso: $(basename "$0") <e-mail> <data> 

  OPTIONS:
    <e-mail>  E-mail do usuário a ser pesquisado
    <data>    A data no formato AAAAMMDD
  
  Examplos de uso:
    $(basename "$0") leonardo.brito@g.globo 20200818
$IRed
  OBS: 
    - OS LOGS DO SMTPCAD FICAM RETIDOS ATÉ 1 MÊS A PARTIR DA DATA ATUAL
      LOGS MAIS ANTIGOS NÃO PODERÃO SER RETORNADOS

    - A DATA ESCOLHIDA PARA A BUSCA VAI SEMPRE PESQUISAR LOGS DO DIA ANTERIOR
$NC
"

# Mostra a mensagem de ajuda quando necessario
while echo "${PARAMETERS[0]}" | egrep -q '(^$|^\-h$|^\-{0,}help$)' || [[ ${#PARAMETERS[@]} < "2" ]]
do
	echo -e "$USAGE_MSG"
	exit 0
done

# Programa principal
date_searched="${PARAMETERS[1]}"
echo -e "\n"$IYellow"Executando o seguinte comando:\n"
echo -e "ssh "$LOGNAME"@"$smtpcad_server" \"sudo bzgrep -i $ICyan'${PARAMETERS[0]}'$NC $IYellow/mnt/logsunix/postfix/smtpcad-prod-bo-*/maillog_smtpcad.log-$ICyan"$date_searched""$NC"$IYellow.bz2\"$NC\n"
ssh "$LOGNAME"@"$smtpcad_server" "sudo bzgrep -i '${PARAMETERS[0]}' /mnt/logsunix/postfix/smtpcad-prod-bo-*/maillog_smtpcad.log-$date_searched.bz2"
