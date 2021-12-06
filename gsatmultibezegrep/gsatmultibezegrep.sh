#! /bin/bash
# Funciona como comando para facilitar a checagem da existencia
# de logs de BE do Gsatmulti para descobrir qual conta de usuário
# já estaria associada a operadora de um determinado cliente que 
# não consegue fazer essa associação com sua conta atual
#
# Criado em 03/12/2021
# Autor: Leonardo Ferreira de Brito <leonardo.brito@g.globo>
# Versão: 1.0 

# Servidores de BE do GSATMULTI
# atualmente temos 03 servidores
#['gsatmulti-prod-be-7.cmah22be-9.cp.globoi.com', 'gsatmulti-prod-be-9.cmaq22be-8.cp.globoi.com', 'gsatmulti-prod-be-8.cmal22be-8.cp.globoi.com']

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

# Definindo o servidores de BE do GsatMulti
gsatmulti_server="gsatmulti-prod-be-7.cmah22be-9.cp.globoi.com"

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
  de logs de de BE do Gsatmulti para descobrir qual conta de usuário
  já estaria associada a operadora de um determinado cliente que 
  não consegue fazer essa associação com sua conta atual.

  Uso: $(basename "$0") <string> <data seguida de \"*\"> 

  OPTIONS:
    <string>  string relacionada ao usuário a ser pesquisado
    <data>*    A data no formato AAAAMMDD
  
  OBS:
    A string pode ser o GloboID do usuário ou até o código de 
    request_id presente nas menssagens de erro recebidas pelo
    cliente e a data faz parte do path name dos arquivos compactados
    que sofrerão a busca via comando \"zegrep\", portanto pode ser 
    utilizado caracteres de coringa de busca como, por exemplo, o \"*\"

  Examplos de uso:
    $(basename "$0") 'b61b573b-7811-4a7c-8128-5cef04386d56|block' \"20211203*\"
    $(basename "$0") 'd22dcff2-27ec-428a-98a1-6ed03bdcf6a8' \"2021112*\"
    $(basename "$0") 'd22dcff2-27ec-428a-98a1-6ed03bdcf6a8' \"20211{01..10}*\"
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
echo -e "ssh "$LOGNAME"@"$gsatmulti_server" \"zegrep --color=always -i $ICyan ${PARAMETERS[0]}$NC $IYellow/mnt/projetos/logs/gsat_multi/be/app-*-$ICyan"$date_searched""$NC"\n"
ssh "$LOGNAME"@"$gsatmulti_server" "zegrep --color=always -i ${PARAMETERS[0]} /mnt/projetos/logs/gsat_multi/be/app-*-$date_searched"