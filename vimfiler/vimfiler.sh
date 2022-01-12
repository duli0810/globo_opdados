#!/usr/bin/env bash
# Funciona como comando para facilitar a edição dos arquivos
# de configuracao de redirect no filer.
# - permite escolher o projeto ao efetuar busca no filer:
#   gshow | g1 | ge | gsat3 | home | redeglobo | 
#   casaejardim | assine | gnt | vignete | wp_g1 | vogue |
#   casavogue | multishow | techtudo | edg4_revistaquem | 
#   centraldeajuda.
#
# Criado em 16/01/2019
# Autor: Leonardo Ferreira de Brito <leonardo.brito@corp.globo.com>
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

# Setting Filer Server ip
filer_server="filer.globoi.com"

# Setting pahts to project redirects files on the filer server
gshow="/mnt/projetos/deploy-fe/gshow/redirect.conf"
g1="/mnt/projetos/deploy-fe/g1/conf/redirect.inc"
globoesporte="/mnt/projetos/deploy-fe/globoesporte/conf/redirect_globoesporte.conf"
globoesporte_sportv="/mnt/projetos/deploy-fe/globoesporte/conf/redirect_sportv.conf"
gsat3_canalbis="/mnt/projetos/deploy-fe/gsat3/redirect-canalbis.conf"
gsat3_canalbrasil="/mnt/projetos/deploy-fe/gsat3/redirect-canalbrasil.conf"
gsat3_pfci="/mnt/projetos/deploy-fe/gsat3/redirect-pfci.conf"
gsat3_sociopremiere="/mnt/projetos/deploy-fe/gsat3/redirect-sociopremiere.conf"
gsat3_off="/mnt/projetos/deploy-fe/gsat3/redirect-off.conf"
gsat3_syfy="/mnt/projetos/deploy-fe/gsat3/redirect-syfy.conf"
gsat3_universal="/mnt/projetos/deploy-fe/gsat3/redirect-universal.conf"
gsat3_viva="/mnt/projetos/deploy-fe/gsat3/redirect-viva.conf"
home="/mnt/projetos/deploy-fe/home/redirects-home-nginx.inc"
redeglobo="/mnt/projetos/deploy-fe/redeglobo/redirect.conf"
gsat3=("$gsat3_canalbis" "$gsat3_canalbrasil"
"$gsat3_pfci" "$gsat3_sociopremiere" "$gsat3_off"
"$gsat3_syfy" "$gsat3_universal" "$gsat3_viva")
vendas_assine="/mnt/projetos/deploy-fe/vendas_assine/httpd-assine.inc"
gsat5_gnt="/mnt/projetos/deploy-fe/gsat5/redirect-gnt.conf"
edg4_casaejardim="/mnt/projetos/deploy-fe/edg4/redirect-casaejardim.conf"
vignette="/mnt/projetos/deploy-fe/vignette_legado/conf/"
wp_g1="/mnt/projetos/deploy-fe/wordpress_legado/httpd-rewrite-all-jornalismo.conf" # URLs legado do worpress com o termo "platb" na URI
edg3_vogue="/mnt/projetos/deploy-fe/edg3/redirect-vogue.conf"
edg3_casavogue="/mnt/projetos/deploy-fe/edg3/redirect-casavogue.conf"
multishow="/mnt/projetos/deploy-fe/gsat4/redirect-multishow.conf"
techtudo="/mnt/projetos/htdocs/techtudo_v2/nginx/redirect-techtudo.inc"
edg4_revistaquem="/mnt/projetos/deploy-fe/edg4/redirect-revistaquem.conf"
#centraldeajuda="/mnt/projetos/deploy-fe/vendas_plataforma/redirect.conf"
edg2_galileu="/mnt/projetos/deploy-fe/edg2/redirect-galileu.conf"
edg2_globorural="/mnt/projetos/deploy-fe/edg2/redirect-globorural.conf"
edg2_revistapegn="/mnt/projetos/deploy-fe/edg2/redirect-revistapegn.conf"
edg4_revistacrescer="/mnt/projetos/deploy-fe/edg4/redirect-crescer.conf"
edg3_revistaglamour="/mnt/projetos/deploy-fe/edg3/redirect-revistaglamour.conf"
edg2_epoca="/mnt/projetos/deploy-fe/edg2/redirect-epoca.conf"

# Creating array with all inputs
while test -n "$1"
do
  PARAMETERS[i]="$1"
  let i++
  shift
done

USAGE_MSG="
Usage: $(basename "$0") <Project Name>
    OPTIONS:
    <Project Name>  [$ICyan gshow $NC|$ICyan g1 $NC|$ICyan ge $NC|$ICyan gsat3 $NC|$ICyan home $NC|$ICyan redeglobo $NC|$ICyan 
                      casaejardim $NC|$ICyan assine $NC|$ICyan gnt $NC|$ICyan vignette $NC|$ICyan wpg1 $NC|$ICyan
                      vogue $NC|$ICyan casavogue $NC|$ICyan multishow $NC|$ICyan techtudo $NC|$ICyan 
                      revistaquem $NC|$ICyan revistagalileu $NC|$ICyan
                      revistagloborural $NC|$ICyan revistapegn $NC|$ICyan revistacrescer $NC|$ICyan revistaglamour $NC|$ICyan 
                      epoca $NC]
    -h, --help      display this help and exit

    OBS: 
      - O$ICyan centraldeajuda.globo.com $NC foi migrado para a farm$IYellow rdirect2$NC!

    Usage Examples:
        $(basename "$0")$ICyan g1 $NC
        $(basename "$0")$ICyan ge $NC
        $(basename "$0")$ICyan gsat3 $NC
        $(basename "$0")$ICyan home $NC
        $(basename "$0")$ICyan redeglobo $NC
        $(basename "$0")$ICyan assine $NC
        $(basename "$0")$ICyan gnt $NC
        $(basename "$0")$ICyan vignette $NC
        $(basename "$0")$ICyan wpg1 $NC
        $(basename "$0")$ICyan vogue $NC
        $(basename "$0")$ICyan casavogue $NC
        $(basename "$0")$ICyan multishow $NC
        $(basename "$0")$ICyan techtudo $NC
        $(basename "$0")$ICyan revistaquem $NC
        $(basename "$0")$ICyan centraldeajuda $NC
        $(basename "$0")$ICyan revistagalileu $NC
        $(basename "$0")$ICyan revistagloborural $NC
        $(basename "$0")$ICyan revistapegn $NC
        $(basename "$0")$ICyan revistacrescer $NC
        $(basename "$0")$ICyan revistaglamour $NC
        $(basename "$0")$ICyan epoca $NC
"

# Return the project chosen by the user setting the variable redirect_filer_path
function project_chosen {
  local option
  if [[ "$1" == "gshow" ]]; then
    redirect_filer_path="$gshow"
  elif [[ "$1" == "g1" ]]; then
    redirect_filer_path="$g1"
  elif [[ "$1" == "home" ]]; then
    redirect_filer_path="$home"
  elif [[ "$1" == "redeglobo" ]]; then
    redirect_filer_path="$redeglobo"
  elif [[ "$1" == "assine" ]]; then
    redirect_filer_path="$vendas_assine"
  elif [[ "$1" == "gnt" ]]; then
    redirect_filer_path="$gsat5_gnt"
  elif [[ "$1" == "casaejardim" ]]; then
    redirect_filer_path="$edg4_casaejardim"
  #### VIGNETTE BLOCK ####
  elif [[ "$1" == "vignette" ]]; then
    vignette_files_list=($(ssh -t $LOGNAME@"$filer_server" ls -lha $vignette | awk '/.*.inc/ {print $9}'))
    lenght_vignette_file_list=$((${#vignette_files_list[@]}))
    echo -e "$IRed\n[ ATENÇÃO ] Ao efetuar a configuração siga o padrão das outras regras, pois regras com caracteres especiais, como por exemplo o '+', não funcionarão!$NC"
    echo -e "\nWhich file do you want to edit?"
    i=0
    for item in ${vignette_files_list[@]};
    do
      echo -e "( $(($i+1)) ) $item"
      i=$(($i+1))
    done
    echo -e "( 0 or anything ) to quit!"
    declare -i option
    read option
    while [[ "$option" > $lenght_vignette_file_list && "$option" != 0 ]] 
    do
      echo -e "Invalid option! Try again (0 to $lenght_vignette_file_list), or ( 0 ) to quit: "
      read option
    done
    [[ "$option" == 0 ]] && exit 1
    option=$(($option-1))
    redirect_filer_path="$vignette""${vignette_files_list[$option]}"
  #### VIGNETTE END BLOCK ####
  elif [[ "$1" == "wpg1" ]]; then
    redirect_filer_path="$wp_g1"
  elif [[ "$1" == "vogue" ]]; then
    redirect_filer_path="$edg3_vogue"
  elif [[ "$1" == "casavogue" ]]; then
    redirect_filer_path="$edg3_casavogue"
  elif [[ "$1" == "multishow" ]]; then
    redirect_filer_path="$multishow"
  elif [[ "$1" == "techtudo" ]]; then
    redirect_filer_path="$techtudo"
  elif [[ "$1" == "revistaquem" ]]; then
    redirect_filer_path="$edg4_revistaquem"
  elif [[ "$1" == "centraldeajuda" ]]; then
    redirect_filer_path="$centraldeajuda"
  elif [[ "$1" == "revistagalileu" ]]; then
    redirect_filer_path="$edg2_galileu"
  elif [[ "$1" == "revistagloborural" ]]; then
    redirect_filer_path="$edg2_globorural"
  elif [[ "$1" == "revistapegn" ]]; then
    redirect_filer_path="$edg2_revistapegn"
  elif [[ "$1" == "revistacrescer" ]]; then
    redirect_filer_path="$edg4_revistacrescer"
  elif [[ "$1" == "revistaglamour" ]]; then
    redirect_filer_path="$edg3_revistaglamour"
  elif [[ "$1" == "epoca" ]]; then
    redirect_filer_path="$edg2_epoca"
  #### GE BLOCK ####
  elif [[ "$1" == "ge" ]]; then
    echo -e "What option? ( 1 ) globoesporte  ( 2 ) sportv  ( q ) to quit."
    read option
    [[ "$option" == "q" ]] && exit 1
    while [[ "$option" != "1" && "$option" != "2" && "$option" != "q" ]]
    do
      echo -e "Invalid option! Try again (1 or 2), or ( q ) to quit: "
      read option
    done
    [[ "$option" == "q" ]] && exit 1
    if [[ "$option" == "1" ]]; then
      redirect_filer_path="$globoesporte"
    elif [[ "$option" == "2" ]]; then
      redirect_filer_path="$globoesporte_sportv"
    fi
  #### GE END BLOCK ####
  #### GSAT3 BLOCK ####
  elif [[ "$1" == "gsat3" ]]; then
    echo -e "What option?
    ( 1 ) canalbis      ( 2 ) canalbrasil   ( 3 ) pfci
    ( 4 ) sociopremiere ( 5 ) off           ( 6 ) syfy
    ( 7 ) universal     ( 8 ) viva          ( q ) to quit.
    "
    read option
    while [[ "$option" != "1" && "$option" != "2" && "$option" != "3" &&
      "$option" != "4" && "$option" != "5" && "$option" != "6" &&
      "$option" != "7" && "$option" != "8" && "$option" != "q" ]]
    do
      echo -e "Invalid option! Try again (1 to ${#gsat3[@]}), or ( q ) to quit: "
      read option
    done
    [[ "$option" == "q" ]] && exit 1
    for ((i=1;i<=${#gsat3[@]};i++));
    do
      if [[ "$option" == "$i" ]]; then
        ni=$(($i-1))
        redirect_filer_path="${gsat3[$ni]}"
      fi
    done
  #### GSAT3 END BLOCK ####
  else
    echo -e ""$IRed"\nInvalid argument! $1 $NC\n$USAGE_MSG"
    exit 1
  fi
  return 0
}

# Show help message when needed
while echo "${PARAMETERS[0]}" | egrep -q '(^$|^\-h$|^\-{0,}help$)' || [[ ${#PARAMETERS[@]} < "1" ]]
do
    if [[ "${PARAMETERS[0]}" == "-h" || "${PARAMETERS[0]}" == "--help" ]]; then
        echo -e "$USAGE_MSG"
    else
        echo -e "\n"$IRed"Empty <Project Name> parameter!$NC\n$USAGE_MSG"
    fi
    exit 0
done

# Main program
project_chosen "${PARAMETERS[0]}"
echo -e "\n"$IYellow"ssh -t $LOGNAME@$filer_server sudo vim $redirect_filer_path\n$NC"

# resolvendo o problema do ^M invisível, ou caractere de recuo, ao final da string
redirect_filer_path=$(echo "$redirect_filer_path" | sed -e "s/\r//g")

ssh -t $LOGNAME@$filer_server sudo vim $redirect_filer_path