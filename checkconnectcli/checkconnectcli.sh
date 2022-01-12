#!/usr/bin/env bash
# GloboID Keycloak Bash Debugger

# Constants
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

printHeader(){
  clear;
  echo -e "${YELLOW}====================================================================================="
  echo " GLOBOID Connect CLI                                              slack #globoid-oidc"
  echo "
            █▀▀ █░░ █▀█ █▄▄ █▀█ █ █▀▄   █▀▀ █▀█ █▄░█ █▄░█ █▀▀ █▀▀ ▀█▀
            █▄█ █▄▄ █▄█ █▄█ █▄█ █ █▄▀   █▄▄ █▄█ █░▀█ █░▀█ ██▄ █▄▄ ░█░
        "
  echo -e "=====================================================================================${NC}"
  printf "%*s\n" $(((${#1}+84)/2)) " $1"
  echo -e "${YELLOW}-------------------------------------------------------------------------------------"
  echo -e "${NC}"
}

# Resolve the flow url from an input indicating the environment
resolve_flow(){
  case $1 in 
    local)
      echo "https://login.dev.globoi.com";
      ;;
    dev)
      echo "https://login.dev.globoi.com";
      ;;
    qa)
      echo "https://login.qa.globoi.com";
      ;;
    qa01)
      echo "https://login.qa01.globoi.com";
      ;;
    qa02)
      echo "https://login.qa02.globoi.com";
      ;;
    prod)
      echo "https://login.globo.com";
      ;;
    beta)
      echo "https://login.globo.com";
      ;;
    *)
      echo "https://login.globo.com";
  esac
}

# Resolve the issuer from an input indicating the environment 
resolve_issuer(){
  case $1 in 
    local)
      echo "http://login.local.globoi.com:8080/auth/realms/globo.com";
      ;;
    dev)
      echo "https://id.dev.globoi.com/auth/realms/globo.com";
      ;;
    qa)
      echo "https://id.qa.globoi.com/auth/realms/globo.com";
      ;;
    qa01)
      echo "https://id.qa01.globoi.com/auth/realms/globo.com";
      ;;
    qa02)
      echo "https://id.qa02.globoi.com/auth/realms/globo.com";
      ;;
    prod)
      echo "https://id.globo.com/auth/realms/globo.com";
      ;;
    beta)
      echo "https://id.globo.com/auth/realms/beta";
      ;;
    *)
      echo "https://id.globo.com/auth/realms/globo.com";
  esac
}

# Tries to use jq if it exists. Otherwise, it uses less
format_output(){
  if ! [ -x "$(command -v jq)" ]; then
    echo 'less'
  else
    echo 'jq'
  fi
}

# Print well knowns routes
wellknown(){
  printHeader "Exchange Autorization Code by OpenID Connect  JWTs (access token, refresh token, id token):";
  read -p "What is the environment (local, dev, qa, qa1, qa2, prod)? " env
 
  issuer=$(resolve_issuer $env)
  format=$(format_output)
  
  curl --connect-timeout 5 "$issuer/.well-known/openid-configuration" | $format

  exit 0
}

# util func to decode URLs
urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

# Authenticate and Authorize User
authCodeFlow(){

  printHeader "Login and obtain OIDC tokens via Authorization Code";
  echo "Please input the following fields with the information provided by GloboID Connect team."
  echo ""
  
  env=1
  clientId="client-prod"
  secret="03b35a8a-a7e9-42d3-8180-91c878170c77"
  serviceId="4100"
  login="operacao.producao"
  password="kill9dcentertoq"
  redirectURL="https://www.globo.com"

  echo -e "Environment => ${YELLOW}prod ${NC}"
  echo -e "Client ID =>${YELLOW} $clientId ${NC}"
  echo -e "Client Secret =>${YELLOW} $secret ${NC}"
  echo -e "Service ID =>${YELLOW} $serviceId ${NC}"
  echo -e "Username or Email =>${YELLOW} $login ${NC}"
  echo -e "Configured Client Redirect URL =>${YELLOW} $redirectURL ${NC}"

#  read -p "What is the environment (local, dev, qa, qa01, qa02, prod, beta(realm))? " env
#  read -p "What is the Client ID? " clientId
#  read -p "What is the Client Secret? " secret
#  read -p "What is the Service ID? " serviceId
#  read -p "What is the Username or Email? (The provided user must already have accepted the Terms of Service) " login
#  echo "Whats the user password?"; read -s password
#  read -p "What is the configured client redirect URL? " redirectURL

  issuer=$(resolve_issuer $env)
  flow=$(resolve_flow $env)
  format=$(format_output)
  
  echo ""
  echo ""

  authurl="$issuer/protocol/openid-connect/auth?client_id=$clientId&state=QY2SAJBWKFG8CU2BTX57&redirect_uri=$redirectURL&response_type=code&scope=openid"
  echo -e "👉 ${YELLOW}STEP 1${NC}: Starting Authentication by Visiting${BLUE} $authurl ${NC}"
  out1=$(curl --connect-timeout 5 -ksv -c cookie1 $authurl  2>&1)
#  echo "=================== out1: $out1"
  location1=$(echo $out1 | sed "s/.*ocation: //" | sed "s/ .*//" | sed "s/.$//")
  callback1=$(echo $location1 | sed "s/.*url=//")
  
  echo -e "\n👉 ${YELLOW}STEP 2${NC}: Visiting Login Page to set cookies:${BLUE} $location1 ${NC}"
  curl --connect-timeout 5 -ks -b cookie1 -c cookie2 $location1 > /dev/null
  
  echo -e "\n👉 ${YELLOW}STEP 3${NC}: Calling GloboID internal authentication api at :${BLUE} $flow/api/authentication ${NC}"
  curl --connect-timeout 5 -ks -b cookie1 -b cookie2 -c cookie3 "$flow/api/authentication" -d "{\"payload\":{\"email\":\"${login}\",\"password\":\"${password}\",\"serviceId\":$serviceId},\"fingerprint\":\"3dee4df857345037a32f714e9d942220\",\"captcha\":\"\"}" -H 'Content-Type: application/json' > /dev/null
# 
  provisioningURL="$flow/provisionamento/$serviceId?url=${callback3}"  
  echo -e "\n👉 ${YELLOW}STEP 4${NC}: Calling provisioning URL:${BLUE} $provisioningURL ${NC}"
  curl --connect-timeout 5 -ks -L -b cookie1 -b cookie2 -b cookie3 -c cookie4 "$provisioningURL" > /dev/null

  echo -e "\n👉 ${YELLOW}STEP 5${NC}: Finishing authentication steps by calling URL:${BLUE} $(urldecode $callback1) ${NC}"
#  echo "=================== callback1: $(urldecode $callback1)"
  location2=$(curl --connect-timeout 5 -ksv -b cookie1 -b cookie2 -b cookie3 -b cookie4 $(urldecode $callback1) 2>&1)
#  echo "location 2  - $location2"

  code=$(echo $location2 | sed "s/.*ocation: //" | sed "s/ .*//" | sed "s/.*code=//" | sed "s/&.*//" | sed "s/.$//")
  echo -e "\n👉 ${YELLOW}STEP 6${NC}: Exchanging Authentication Code: $code by OIDC Tokens on URL:${BLUE} $issuer/protocol/openid-connect/token ${NC}"
  tokens=$(curl --connect-timeout 5 -ks "$issuer/protocol/openid-connect/token" -u "$clientId:$secret" -d 'grant_type=authorization_code' -d "code=$code" -d "redirect_uri=$redirectURL")
 
  echo ""
  echo "Authentication Response:"
  echo ""
  echo "$tokens" | $format

  exit 0
}

# Authenticate via Direct Flow
directGrantFlow(){
  printHeader "Authorization using Direct Grant Flow";

  read -p "What is the environment (local, dev, qa, qa01, qa02, prod, beta(realm))? " env
  read -p "What is the Client ID? " clientId
  read -p "What is the Client Secret? " clientSecret
  read -p "What is the Username or Email? (The provided user must already have accepted the Terms of Service) " login
  echo "Whats the user password?"; read -s password
  
  issuer=$(resolve_issuer $env)
  format=$(format_output)
  location="${issuer}/protocol/openid-connect/token"

  echo "👉 Authenticating at $location"
  curl --connect-timeout 5 -X POST $location -H "application/x-www-form-urlencoded" -d "scope=openid&username=$login&password=$password&client_id=$clientId&grant_type=password&client_secret=$clientSecret" | $format

  exit 0
}


introspect(){
  printHeader "Introspect Access Token";

  read -p "What is the environment (local, dev, qa, qa01, qa02, prod, beta(realm))? " env
  read -p "What is the Client ID? " clientId
  read -p "What is the Client Secret? " clientSecret
  echo "What is the Access Token?"; read -n 2500 accessToken

  issuer=$(resolve_issuer $env)
  format=$(format_output)
  location="${issuer}/protocol/openid-connect/token/introspect"

  echo "👉 Authenticating at $location"
  curl --connect-timeout 5 -X POST $location -H "application/x-www-form-urlencoded" -d "client_id=$clientId&client_secret=$clientSecret&token=$accessToken" | $format

  exit 0
}


# Logout a user by using OIDC logout route
logout(){
  printHeader "Logout user";

  read -p "What is the environment (local, dev, qa, qa01, qa02, prod, beta(realm))? " env
  read -p "What is the Client ID? " clientId
  read -p "What is the Client Secret? " clientSecret
  echo "What is the Access Token?"; read -n 2500 accessToken
  echo "What is the Refresh Token?"; read -n 2500 refreshToken

  issuer=$(resolve_issuer $env)
  format=$(format_output)

  curl --connect-timeout 5 -X POST \
  --header 'content-type: application/x-www-form-urlencoded' \
  --header "Authorization: Bearer $accessToken"  \
  -d "client_id=$clientId&client_secret=$clientSecret&refresh_token=$refreshToken" \
  "$issuer/protocol/openid-connect/logout" -v

  echo ""
  echo "Logout called"

  exit 0
}

# Refreh OIDC tokens
refresh(){
  printHeader "Refresh Tokens";

  read -p "What is the environment (local, dev, qa, qa01, qa02, prod, beta(realm))? " env
  read -p "What is the Client ID? " clientId
  read -p "What is the Client Secret? " clientSecret
  echo "What is the Refresh Token?"; read -n 2500 refreshToken

  issuer=$(resolve_issuer $env)
  format=$(format_output)

  curl --connect-timeout 5 -X POST \
  --header 'content-type: application/x-www-form-urlencoded' \
  -d "grant_type=refresh_token&client_id=$clientId&client_secret=$clientSecret&refresh_token=$refreshToken" \
  "$issuer/protocol/openid-connect/token" | $format

  exit 0
}


# Exchange a code by JWT Tokens
exchange(){
  printHeader "Exchange autorization code by JWTs";

  read -p "What is the environment (local, dev, qa, qa01, qa02, prod, beta(realm))? " env
  read -p "What is the Client ID? " clientId
  read -p "What is the Client Secret? " secret
  read -p "What was the EXACT redirect URL passed in authentication? " redirectURL
  read -p "What is the Authorization Code? " code 

  issuer=$(resolve_issuer $env)
  format=$(format_output)

  curl --connect-timeout 5 -X POST \
  --header 'content-type: application/x-www-form-urlencoded' \
  -d "grant_type=authorization_code&client_id=$clientId&client_secret=$secret&code=$code&redirect_uri=$redirectURL" \
  "$issuer/protocol/openid-connect/token" | $format

  exit 0
}

# Get user information
userinfo(){
  printHeader "Get user information";

  read -p "What is the environment (local, dev, qa, qa01, qa02, prod, beta(realm))? " env
  echo "What is the Access Token?"; read -n 2500 accessToken

  issuer=$(resolve_issuer $env)
  format=$(format_output)

  curl --connect-timeout 5 -X POST \
  --header 'content-type: application/x-www-form-urlencoded' \
  -d "access_token=$accessToken" \
  "$issuer/protocol/openid-connect/userinfo" | $format

  exit 0
}

# Print help 
help(){
  printHeader "GloboID Keycloak Bash Debugger Help";

  echo ""
  echo "1) Login and obtain OIDC tokens via Authorization Code" 
  echo "Runs all steps needed to authenticate an user, exchange auth code and receive OICD tokens (access token, refresh token and id token)"
  echo ""
  echo "2) Exchange Authorization Code" 
  echo "Given an OIDC client credentials and Authorization Code, it makes the exchange step via curl --connect-timeout 5 return JWTs (access token, refresh token, id token)"
  echo ""
  echo "3) Get Endpoints"
  echo "Returns all valid endpoints from Keycloak server via well-known route"
  echo ""

  options=("Login and obtain OIDC tokens via Authorization Code" "Exchange Authorization Code by OIDC tokens" "Get OIDC server endpoints" "Help" "Quit")
}

main(){
  printHeader "Maintainer:  GloboID Connect Team <globoid.connect@corp.globo.com>"
  authCodeFlow
#  COLUMNS=12
#  PS3=$'\nPlease choose a VALID option : '
#  options=("Login and obtain OIDC tokens via Authorization Code" "Login and obtain OIDC tokens via Direct Grant" "Exchange Authorization Code by OIDC tokens" "Get user info passing the access token" "Wellknown - Get OIDC server endpoints" "Refresh Tokens" "Logout" "Introspect" "Help" "Quit")
#  select opt in "${options[@]}"
#  do
#      case $opt in
#          "Login and obtain OIDC tokens via Authorization Code")
#            authCodeFlow;
#            ;;
#          "Login and obtain OIDC tokens via Direct Grant")
#            directGrantFlow;
#            ;;
#          "Exchange Authorization Code by OIDC tokens")
#            exchange;
#            ;;
#          "Get user info passing the access token")
#            userinfo;
#            ;;
#          "Wellknown - Get OIDC server endpoints")
#            wellknown;
#            ;;
#          "Refresh Tokens")
#            refresh;
#            ;;
#          "Logout")
#            logout;
#            ;;
#          "Introspect")
#            introspect;
#            ;;
#          "Help")
#            help;
#            ;;
#          "Quit")
#            break
#            ;;
#          *) echo "invalid option $REPLY";;
#      esac
#  done
}

main;
