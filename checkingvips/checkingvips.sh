#!/usr/bin/env bash
#
# Checar os VIPS

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

VIPS=(
    "https://id.globo.com/healthcheck.html"
    "https://globoid-connect.be.globoi.com/healthcheck.html"
    "http://be.glive.globoi.com/healthcheck"
    "http://flow.cadun.globo.com/healthcheck"
    "http://flow.be.cadun.globoi.com/healthcheck"
    "https://login.globo.com/healthcheck"
    "https://minhaconta.globo.com/_nginx_healthcheck/"
    "cocoon.globo.com/healthcheck.html"
    )

# Main
echo -e "Checking VIPs...\n----------------------------------------"
while true
do
	for vip in ${VIPS[@]}
	do
		echo -en "$(date '+%Y-%m-%d %H:%M:%S')$ICyan $vip$NC: "
        if [[ $vip == "https://globoid-connect.be.globoi.com/healthcheck.html" ]]
        then
            curl --connect-timeout 20 -ksS $vip -H "Host:globoid-connect.be.globoi.com"
        else
		    curl --connect-timeout 20 -ksS $vip
        fi
		sleep 1
	done
    echo "----------------------------------------"
done
