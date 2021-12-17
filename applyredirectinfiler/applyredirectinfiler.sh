#! /bin/bash
# Funciona como comando para verificar erros de sintaxe
# nos arquivos de configuracao de redirect e/ou aplicar
# suas novas configurações, remotamente "over ssh" nos
# servidores do projeto.
# - permite escolher o projeto:
#   gshow | g1 | ge | gsat3 | home | redeglobo | assine | gnt |
#   vignette | wplegado | vogue | casavogue | techtudo.
#
# Criado em /01/2019
# Autor: Leonardo Ferreira de Brito <leonardo.brito@corp.globo.com>
# Versão: 1.0
# Atualizado em 02/04/2020
#  - Incluído forma temporária de verificar a cor do GSHOW

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

# gshow reals
gshow_blue1="gshow-prod-fe-1-blue.cmah22fe-132.cp.globoi.com"
gshow_blue2="gshow-prod-fe-2-blue.cmal22fe-135.cp.globoi.com"
gshow_blue3="gshow-prod-fe-3-blue.cmaq22fe-133.cp.globoi.com"
gshow_blue4="gshow-prod-fe-4-blue.cmah22fe-132.cp.globoi.com"
gshow_blue5="gshow-prod-fe-5-blue.cmal22fe-135.cp.globoi.com"
gshow_blue6="gshow-prod-fe-6-blue.cmaq22fe-133.cp.globoi.com"
gshow_green1="gshow-prod-fe-1-green.cmah22fe-132.cp.globoi.com"
gshow_green2="gshow-prod-fe-2-green.cmal22fe-135.cp.globoi.com"
gshow_green3="gshow-prod-fe-3-green.cmaq22fe-133.cp.globoi.com"
gshow_green4="gshow-prod-fe-4-green.cmah22fe-132.cp.globoi.com"
gshow_green5="gshow-prod-fe-5-green.cmal22fe-135.cp.globoi.com"
gshow_green6="gshow-prod-fe-6-green.cmaq22fe-133.cp.globoi.com"
gshow_blue=("$gshow_blue1" "$gshow_blue2" "$gshow_blue3" "$gshow_blue4" "$gshow_blue5" "$gshow_blue6")
gshow_green=("$gshow_green1" "$gshow_green2" "$gshow_green3" "$gshow_green4" "$gshow_green5" "$gshow_green6")
gshow_reals=("${gshow_blue[@]}" "${gshow_green[@]}")

# g1 reals
g1_blue1="g1-prod-fe-1-blue.cmah22fe-139.cp.globoi.com"
g1_blue2="g1-prod-fe-2-blue.cmal22fe-138.cp.globoi.com"
g1_blue3="g1-prod-fe-3-blue.cmaq22fe-138.cp.globoi.com"
g1_blue4="g1-prod-fe-4-blue.cmah22fe-139.cp.globoi.com"
g1_blue5="g1-prod-fe-5-blue.cmal22fe-138.cp.globoi.com"
g1_blue6="g1-prod-fe-6-blue.cmaq22fe-138.cp.globoi.com"
g1_blue7="g1-prod-fe-7-blue.cmah22fe-139.cp.globoi.com"
g1_blue8="g1-prod-fe-8-blue.cmal22fe-138.cp.globoi.com"
g1_blue9="g1-prod-fe-9-blue.cmaq22fe-138.cp.globoi.com"
g1_green1="g1-prod-fe-1-green.cmah22fe-139.cp.globoi.com"
g1_green2="g1-prod-fe-2-green.cmal22fe-138.cp.globoi.com"
g1_green3="g1-prod-fe-3-green.cmaq22fe-138.cp.globoi.com"
g1_green4="g1-prod-fe-4-green.cmah22fe-139.cp.globoi.com"
g1_green5="g1-prod-fe-5-green.cmal22fe-138.cp.globoi.com"
g1_green6="g1-prod-fe-6-green.cmaq22fe-138.cp.globoi.com"
g1_green7="g1-prod-fe-7-green.cmah22fe-139.cp.globoi.com"
g1_green8="g1-prod-fe-8-green.cmal22fe-138.cp.globoi.com"
g1_green9="g1-prod-fe-9-green.cmaq22fe-138.cp.globoi.com"
g1_blue=("$g1_blue1" "$g1_blue2" "$g1_blue3" "$g1_blue4" "$g1_blue5" "$g1_blue6" "$g1_blue7" "$g1_blue8" "$g1_blue9")
g1_green=("$g1_green1" "$g1_green2" "$g1_green3" "$g1_green4" "$g1_green5" "$g1_green6" "$g1_green7" "$g1_green8" "$g1_green9")
g1_reals=("${g1_blue[@]}" "${g1_green[@]}")

# globoesporte reals
globoesporte_blue1="globoesporte-prod-fe-1-blue.cmah22fe-141.cp.globoi.com"
globoesporte_blue2="globoesporte-prod-fe-2-blue.cmal22fe-140.cp.globoi.com"
globoesporte_blue3="globoesporte-prod-fe-3-blue.cmaq22fe-139.cp.globoi.com"
globoesporte_blue4="globoesporte-prod-fe-4-blue.cmah22fe-141.cp.globoi.com"
globoesporte_blue5="globoesporte-prod-fe-5-blue.cmal22fe-140.cp.globoi.com"
globoesporte_blue6="globoesporte-prod-fe-6-blue.cmaq22fe-139.cp.globoi.com"
globoesporte_green1="globoesporte-prod-fe-1-green.cmah22fe-141.cp.globoi.com"
globoesporte_green2="globoesporte-prod-fe-2-green.cmal22fe-140.cp.globoi.com"
globoesporte_green3="globoesporte-prod-fe-3-green.cmaq22fe-139.cp.globoi.com"
globoesporte_green4="globoesporte-prod-fe-4-green.cmah22fe-141.cp.globoi.com"
globoesporte_green5="globoesporte-prod-fe-5-green.cmal22fe-140.cp.globoi.com"
globoesporte_green6="globoesporte-prod-fe-6-green.cmaq22fe-139.cp.globoi.com"
globoesporte_blue=("$globoesporte_blue1" "$globoesporte_blue2" "$globoesporte_blue3" "$globoesporte_blue4" "$globoesporte_blue5" "$globoesporte_blue6")
globoesporte_green=("$globoesporte_green1" "$globoesporte_green2" "$globoesporte_green3" "$globoesporte_green4" "$globoesporte_green5" "$globoesporte_green6")
globoesporte_reals=("${globoesporte_blue[@]}" "${globoesporte_green[@]}")

# gsat3 reals
gsat3_fe1="globosat3-prod-fe-1.cmah22fe-161.cp.globoi.com"
gsat3_fe2="globosat3-prod-fe-2.cmal22fe-161.cp.globoi.com"
gsat3_fe3="globosat3-prod-fe-3.cmaq22fe-159.cp.globoi.com"
gsat3_reals=("$gsat3_fe1" "$gsat3_fe2" "$gsat3_fe3")

# home reals
home_fe1="home-gcom-prod-fe-1.cmah22fe-157.cp.globoi.com"
home_fe2="home-gcom-prod-fe-2.cmal22fe-158.cp.globoi.com"
home_fe3="home-gcom-prod-fe-3.cmaq22fe-155.cp.globoi.com"
home_fe4="home-gcom-prod-fe-4.cmah22fe-157.cp.globoi.com"
home_fe5="home-gcom-prod-fe-5.cmal22fe-158.cp.globoi.com"
home_fe6="home-gcom-prod-fe-6.cmaq22fe-155.cp.globoi.com"
home_reals=("$home_fe1" "$home_fe2" "$home_fe3" "$home_fe4" "$home_fe5" "$home_fe6")

# redeglobo reals
redeglobo_fe1="redeglobo-prod-fe-1.cmah22fe-150.cp.globoi.com"
#redeglobo_fe2="redeglobo-prod-fe-2.cmal22fe-151.cp.globoi.com"
redeglobo_fe3="redeglobo-prod-fe-3.cmaq22fe-149.cp.globoi.com"
redeglobo_reals=("$redeglobo_fe1" "$redeglobo_fe3")

# vendas assine reals
assine_fe1="vendas-assine-prod-fe-1.cmah22fe-144.cp.globoi.com"
assine_fe2="vendas-assine-prod-fe-2.cmal22fe-145.cp.globoi.com"
assine_fe3="vendas-assine-prod-fe-3.cmaq22fe-143.cp.globoi.com"
assine_reals=("$assine_fe1" "$assine_fe2" "$assine_fe3")

# gnt reals
gnt_fe1="globosat5-prod-fe-1.cmah22fe-161.cp.globoi.com"
gnt_fe2="globosat5-prod-fe-2.cmal22fe-161.cp.globoi.com"
gnt_fe3="globosat5-prod-fe-3.cmaq22fe-159.cp.globoi.com"
gnt_reals=("$gnt_fe1" "$gnt_fe2" "$gnt_fe3")

# edg4 reals (revista casaejardim | revista quem)
edg4_fe1="editoraglobo4-prod-fe-1.cmah22fe-160.cp.globoi.com"
edg4_fe2="editoraglobo4-prod-fe-2.cmal22fe-153.cp.globoi.com"
edg4_fe3="editoraglobo4-prod-fe-3.cmaq22fe-158.cp.globoi.com"
edg4_reals=("$edg4_fe1" "$edg4_fe2" "$edg4_fe3")

# Vignette / legado
legado_fe1="legado-prod-fe-1.cmah25fe-151.cp.globoi.com"
legado_fe2="legado-prod-fe-2.cmal25fe-151.cp.globoi.com"
legado_fe3="legado-prod-fe-3.cmaq25fe-156.cp.globoi.com"
legado_rails=("$legado_fe1" "$legado_fe2" "$legado_fe3")

# gsat4 reals (multishow.globo.com)
gsat4_fe1="globosat4-prod-fe-1.cmah22fe-161.cp.globoi.com"
gsat4_fe2="globosat4-prod-fe-2.cmal22fe-161.cp.globoi.com"
gsat4_fe3="globosat4-prod-fe-3.cmaq22fe-159.cp.globoi.com"
gsat4_reals=("$gsat4_fe1" "$gsat4_fe2" "$gsat4_fe3")

# Wordpress legado
wplegado_fe1="wplegado-prod-fe-1.globoi.com"
wplegado_fe2="wplegado-prod-fe-2.globoi.com"
wplegado_fe3="wplegado-prod-fe-3.globoi.com"
wplegado_rails=("$wplegado_fe1" "$wplegado_fe2" "$wplegado_fe3")

# edg3 (revista vogue e glamour reals)
edg3_fe1="editoraglobo3-prod-fe-1.cmah22fe-160.cp.globoi.com"
edg3_fe2="editoraglobo3-prod-fe-2.cmal22fe-153.cp.globoi.com"
edg3_fe3="editoraglobo3-prod-fe-3.cmaq22fe-158.cp.globoi.com"
edg3_reals=("$edg3_fe1" "$edg3_fe2" "$edg3_fe3")

# techtudo
techtudo_fe1="techtudo-v2-prod-fe-1.cmah22fe-153.cp.globoi.com"
techtudo_fe2="techtudo-v2-prod-fe-2.cmal22fe-154.cp.globoi.com"
techtudo_fe3="techtudo-v2-prod-fe-3.cmaq22fe-151.cp.globoi.com"
techtudo_reals=("$techtudo_fe1" "$techtudo_fe2" "$techtudo_fe3")

# vendas_plataforma (centraldeajuda) MIGRADO PARA FARM REDIRECT2
#vendas_plataforma_fe1="vendas-plataforma-prod-fe-1.cmah22fe-154.cp.globoi.com"
#vendas_plataforma_fe2="vendas-plataforma-prod-fe-2.cmal22fe-155.cp.globoi.com"
#vendas_plataforma_fe3="vendas-plataforma-prod-fe-3.cmaq22fe-152.cp.globoi.com"
#vendas_plataforma_reals=("$vendas_plataforma_fe1" "$vendas_plataforma_fe2" "$vendas_plataforma_fe3")

# edg2 reals (revista galileu | revista globorural | revista pegn )
edg2_fe1="editoraglobo2-prod-fe-1.cmah22fe-160.cp.globoi.com"
edg2_fe2="editoraglobo2-prod-fe-2.cmal22fe-153.cp.globoi.com"
edg2_fe3="editoraglobo2-prod-fe-3.cmaq22fe-158.cp.globoi.com"
edg2_reals=("$edg2_fe1" "$edg2_fe2" "$edg2_fe3")

# Farm redirect2.globo.com
redirect2_fe1="asra11mp03lf15.globoi.com"
redirect2_fe2="asra11mp03lf16.globoi.com"
redirect2_fe3="asra01mp03lf16.globoi.com"
redirect2_fe4="asra01mp03lf15.globoi.com"
redirect2_fe5="cmah21mp02lf08.globoi.com"
redirect2_fe6="cmal21mp02lf07.globoi.com"
redirect2_fe7="cmah21mp02lf07.globoi.com"
redirect2_fe8="cmal21mp02lf08.globoi.com"
redirect2_reals=("$redirect2_fe1" "$redirect2_fe2" "$redirect2_fe3" "$redirect2_fe4" "$redirect2_fe5" "$redirect2_fe6" "$redirect2_fe7" "$redirect2_fe8")


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
                      revistaquem $NC|$ICyan centraldeajuda $NC|$ICyan revistagalileu $NC|$ICyan
                      revistagloborural $NC|$ICyan revistapegn $NC|$ICyan revistacrescer $NC|$ICyan 
                      epocanegocios $NC|$ICyan revistaglamour $NC|$ICyan epoca $NC|$IYellow redirect2 $NC]
    -h, --help      display this help and exit

    Usage Examples:
        $(basename "$0")$ICyan g1 $NC
        $(basename "$0")$ICyan ge $NC
        $(basename "$0")$ICyan gsat3 $NC
        $(basename "$0")$ICyan home $NC
        $(basename "$0")$ICyan redeglobo $NC
        $(basename "$0")$ICyan assine $NC
        $(basename "$0")$ICyan gnt $NC
        $(basename "$0")$ICyan casaejardim $NC
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
        $(basename "$0")$ICyan epocanegocios $NC
        $(basename "$0")$ICyan revistaglamour $NC
        $(basename "$0")$ICyan epoca $NC
        $(basename "$0")$IYellow redirect2 $NC
"
#'sudo /etc/init.d/farmredirect-nginx-fe restart'
# Inform the project to check reals
function checkreals {
    local color host_project
    project="$1"
    [[ "$project" == "ge" ]] && project="globoesporte"
    [[ "$project" == "assine" ]] && project="vendas_assine"
    [[ "$project" == "gnt" ]] && project="gsat5"
    [[ "$project" == "casaejardim" ]] && project="edg4"
    [[ "$project" == "revistaquem" ]] && project="edg4"
    [[ "$project" == "revistacrescer" ]] && project="edg4"
    [[ "$project" == "vignette" ]] && project="vignette"
    [[ "$project" == "wplegado" ]] && project="wordpress_legado"
    [[ "$project" == "wpg1" ]] && project="wordpress_legado"
    [[ "$project" == "vogue" ]] && project="edg3"
    [[ "$project" == "casavogue" ]] && project="edg3"
    [[ "$project" == "multishow" ]] && project="gsat4"
    [[ "$project" == "techtudo" ]] && project="techtudo_v2"
    [[ "$project" == "centraldeajuda" ]] && project="farmredirect"
    [[ "$project" == "revistagalileu" ]] && project="edg2"
    [[ "$project" == "revistagloborural" ]] && project="edg2"
    [[ "$project" == "revistapegn" ]] && project="edg2"
    [[ "$project" == "epocanegocios" ]] && project="edg2"
    [[ "$project" == "revistaglamour" ]] && project="edg3"
    [[ "$project" == "epoca" ]] && project="edg2"
    [[ "$project" == "redirect2" ]] && project="farmredirect"
    if [[ "$project" == "globoesporte" ]]; then
        active_color="$(curl -s http://ge.globo.com/healthcheck.html | awk '{print $2}')"
    else
        active_color="$(curl -s http://$project.globo.com/healthcheck.html | awk '{print $2}')"
    fi
    ##### Código temporário pra descobrir a cor do GSHOW ####
        if [[ "$project" == "gshow" ]]; then
            blue=""
            blue=$(ssh "$LOGNAME"@"$gshow_blue1" "grep -m 1 'beta.gshow.globo.com' /opt/logs/gshow/nginx-fe-blue/gshow-nginx-fe-blue_access.log")
            if [[ "$blue" == *"beta"* ]]; then
                active_color="green"
            else
                active_color="blue"
            fi
        fi
    #########################################################
    echo -e "\nAnalyzing the project:$IYellow $project $NC...\n"
    [[ "$active_color" == "green" ]] && color="$IGreen"
    [[ "$active_color" == "blue" ]] && color="$ICyan"    
    if  [[ "$project" == "gshow" || "$project" == "g1" || "$project" == "globoesporte" ]]; then
        [[ "$project" == "gshow" && "$active_color" == "blue" ]] && project_reals=("${gshow_blue[@]}")
        [[ "$project" == "gshow" && "$active_color" == "green" ]] && project_reals=("${gshow_green[@]}")
        [[ "$project" == "g1" && "$active_color" == "blue" ]] && project_reals=("${g1_blue[@]}")
        [[ "$project" == "g1" && "$active_color" == "green" ]] && project_reals=("${g1_green[@]}")
        [[ "$project" == "globoesporte" && "$active_color" == "blue"  ]] && project_reals=("${globoesporte_blue[@]}")
        [[ "$project" == "globoesporte" && "$active_color" == "green"  ]] && project_reals=("${globoesporte_green[@]}")
        project_with_color="yes"
        echo -e "For project$IYellow $project "$NC"the active color is:$color $active_color"$NC".\n"
        for host_project in "${project_reals[@]}"
        do
            if ping -c 3 $host_project > /dev/null; then
                echo -e "$color"$host_project"$NC –$IGreen UP$NC"
            else
                echo -e "\
                            \r"$IRed"ERROR - Access to the host"$IYellow" $host_project "$IRed"must be verified!
                            \rIn case of changes, in the dns name of the project host, this script should be updated so you can continue!$NC\
                        "
                echo
                exit 1
            fi
        done
        echo
    elif [[ "$project" == "gsat3" || "$project" == "home" || "$project" == "redeglobo" || "$project" == "vendas_assine" || "$project" == "gsat5" || \
        "$project" == "edg4" || "$project" == "vignette" || "$project" == "wordpress_legado" || "$project" == "edg3" || "$project" == "gsat4" || \
        "$project" == "techtudo_v2" || "$project" == "vendas_plataforma" || "$project" == "edg2" || "$project" == "farmredirect" ]]; then
        [[ "$project" == "gsat3" ]] && project_reals=("${gsat3_reals[@]}")
        [[ "$project" == "home" ]] && project_reals=("${home_reals[@]}")
        [[ "$project" == "redeglobo" ]] && project_reals=("${redeglobo_reals[@]}")
        [[ "$project" == "vendas_assine" ]] && project_reals=("${assine_reals[@]}")
        [[ "$project" == "gsat5" ]] && project_reals=("${gnt_reals[@]}")
        [[ "$project" == "edg4" ]] && project_reals=("${edg4_reals[@]}")
        [[ "$project" == "vignette" ]] && project_reals=("${legado_rails[@]}")
        [[ "$project" == "wordpress_legado" ]] && project_reals=("${wplegado_rails[@]}")
        [[ "$project" == "edg3" ]] && project_reals=("${edg3_reals[@]}")
        [[ "$project" == "gsat4" ]] && project_reals=("${gsat4_reals[@]}")
        [[ "$project" == "techtudo_v2" ]] && project_reals=("${techtudo_reals[@]}")
        [[ "$project" == "vendas_plataforma" ]] && project_reals=("${vendas_plataforma_reals[@]}")
        [[ "$project" == "edg2" ]] && project_reals=("${edg2_reals[@]}")
        [[ "$project" == "farmredirect" ]] && project_reals=("${redirect2_reals[@]}")
        for host_project in "${project_reals[@]}"
        do
            if ping -c 3 $host_project > /dev/null; then
                echo -e "$IYellow"$host_project"$NC –$IGreen UP$NC"
            else
                echo -e "\
                            \r"$IRed"ERROR - Access to the host"$IYellow" $host_project "$IRed"must be verified!
                            \rIn case of changes, in the dns name of the project host, this script should be updated so you can continue!$NC\
                        "
                echo
                exit 1
            fi
        done
        echo
    else
        echo -e "$IRed\rInvalid project for this program!$NC\n"
        exit 1
    fi
}

function actionserver {
    local host="$1"
    local action="$2"
    if [[ "$project_with_color" == "yes" ]]; then
            ssh "$LOGNAME"@"$host" "sudo /etc/init.d/"$project"-nginx-fe-"$active_color" $action"
        elif [[ "$project" == "vendas_assine" || "$project" == "wordpress_legado" ]]; then
            ssh "$LOGNAME"@"$host" "sudo /etc/init.d/"$project"-httpd-fe $action"
        elif [[ "$project" == "vignette" ]]; then
                ssh "$LOGNAME"@"$host" "sudo /etc/init.d/nginx-vignette_legado-fe $action"
        elif [[ "$project" == "vendas_plataforma" ]]; then
            ssh "$LOGNAME"@"$host" "sudo /etc/init.d/nginx-"$project"-fe $action"
        else
            ssh "$LOGNAME"@"$host" "sudo /etc/init.d/"$project"-nginx-fe $action"
    fi
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
################
# Main Program #
################
checkreals "${PARAMETERS[0]}"
i=0
while [ i != 0 ]
do
    if [[ $project == "farmredirect" ]]
        then
        echo -e "What do you want to do? ( 1 ) test on a single server    ( 2 ) apply on all servers   ( q ) to quit"
    else
        echo -e "What do you want to do? ( 1 ) configtest   ( 2 ) reload   ( q ) to quit"
    fi
    read option
    while [[ "$option" != "1" && "$option" != "2" && "$option" != "q" ]]
    do
      echo -e ""$IRed"Invalid option!"$NC" Try again (1, 2) or ( q ) to quit: "
      read option
    done
    [[ "$option" == "q" ]] && exit 0

    #echo -e "Enter the password for the $LOGNAME user: "
    #read -s password

    case $option in
    1) #configtest - Tests the syntax of the project servers nginx/apache configuration files
        if [[ $project == "farmredirect" ]]
            then
            echo -e "Testing commands in $IYellow$host_project$NC:"
            echo -e "- Running$IBlue puppet-check$NC:"
            ssh -t "$LOGNAME"@"${project_reals[0]}" "sudo /opt/local/bin/puppet-check"
            echo -e "- Running$IBlue puppet-setup$NC:"
            ssh -t "$LOGNAME"@"${project_reals[0]}" "sudo /opt/local/bin/puppet-setup"
            echo -e "- Running reload do nginx:"
            ssh -t "$LOGNAME"@"${project_reals[0]}" "sudo /etc/init.d/"$project"-nginx-fe reload"
            echo -e "- Testing in local with wget command:"
            echo -e "Enter source domain:"
            read source_domain
            echo -e "Enter path of source URL. Ex /algumacoisa :"
            read path
            ssh -t "$LOGNAME"@"${project_reals[0]}" "wget -O /dev/null  --server-response http://localhost:8081$path --header=\"Host:$source_domain\" --max-redirect 0"
            echo
        else
            echo -e "\nRunning the $IYellow\"configtest\"$NC command to check the syntax of the nginx/apache configuration file
                     \ron the server: $IYellow"${project_reals[0]}"$NC ...\n"
            actionserver "${project_reals[0]}" "configtest"
            echo
        fi
        ;;

    2) #reload - Performs reload on the nginx/apache service of the project servers
        if [[ $project == "farmredirect" ]]
            then
            for host_project in "${project_reals[@]}"
            do
                if [[ $host_project != ${project_reals[0]} ]]
                    then
                    echo -e "Running$IBlue puppet-setup$NC in $IYellow$host_project$NC:"
                    ssh -t "$LOGNAME"@"$host_project" "sudo /opt/local/bin/puppet-setup"
                fi
            done
            echo -e "\nRunning the $IYellow\"reload\"$NC command to apply the changes in nginx service on the servers: \n"
            for host_project in "${project_reals[@]}"
            do    
                echo -e "$IYellow$host_project$NC:"
                ssh -t "$LOGNAME"@"$host_project" "sudo /etc/init.d/"$project"-nginx-fe reload"
            done
        else
            echo -e "\nRunning the $IYellow\"reload\"$NC command to apply the changes in nginx service on the servers: \n"
            for host_project in "${project_reals[@]}"
            do
                echo -e "$IYellow$host_project$NC:"
                actionserver "$host_project" "reload"
            done
        fi
        echo
    esac
done
####################
# End Main Program #
####################