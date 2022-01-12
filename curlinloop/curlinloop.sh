#!/usr/bin/env bash
#
# Curl em loop para checar healthcheck

# Creating array with all inputs
PARAMETERS[0]=""
PARAMETERS[1]=""
while test -n "$1"
do
    PARAMETERS[i]="$1"
    let i++
    shift
done

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

USAGE_MSG="
Usage: $(basename "$0") [URL]

    URL             full URL

    Options:
        -h, --help      display this help and exit

    Usage Examples:
        $(basename "$0") http://10.129.71.87:8080/healthcheck -H \"Host: be.glive.globoi.com\"
        $(basename "$0") https://id.globo.com/healthcheck.html
        $(basename "$0") https://globoid-connect.be.globoi.com/healthcheck.html -H \"Host:globoid-connect.be.globoi.com\"
        $(basename "$0") http://be.glive.globoi.com/healthcheck
        $(basename "$0") http://flow.cadun.globo.com/healthcheck
        $(basename "$0") http://flow.be.cadun.globoi.com/healthcheck
        $(basename "$0") https://login.globo.com/healthcheck
        $(basename "$0") https://minhaconta.globo.com/_nginx_healthcheck/
"

# Show help message when needed
while echo "${PARAMETERS[0]}" | egrep -q '(^$|^\-h$|^\-{0,}help$)' || [[ "${#PARAMETERS[@]}" < "1" ]]
do
    echo -e "$USAGE_MSG"
    exit 0
done

# Main
while true
do
    echo -en "$(date '+%Y-%m-%d %H:%M:%S')$ICyan ${PARAMETERS[0]}$NC: "
    curl --connect-timeout 20 -ksS "${PARAMETERS[0]}"
    sleep 1
done