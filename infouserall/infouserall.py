#!/usr/bin/python3
# -*- coding: utf-8 -*-

########################### INFORMAÇOES ##########################################
#
#Nome do Script : infouserall.py
#Descriçao      : Lista as informações do usuário cadastrada no Glive. 
#Autor          : Eduardo Rodrigues da Silva
#Email          : eduardo.rodrigues@g.globo
#Equipe         : Operaçao Dados
#versao         : 2.0
#Complemento    : KB0105132
#                  
#
#################################################################################

# Setting High Intensity Colors
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\033[0m'              # Reset Colors

########################## MÓDULOS ##########################################
from textwrap import indent
from numpy import append
import requests
import json
import sys
import re
###################### DEFININDO MESSAGEM DE HELP SCRIPT ####################

help=f'''
               ######## *** HELP SCRIPT *** ######## 
{IPurple}
                     *** INFO USER ALL *** 
{NC}
{IYellow}
        Estrutura: ./infouserall.py <email or globoid> 
        {NC}

        Exemplos:
                ./infouserall.py teste@g.globo     
                ./infouserall.py 223bcb6f-a995-40b3-919e-dd93246ee2ws

        {IGreen} Lista as informações do usuário cadastrada no Glive. 
        {NC}                 
'''
###################### FUNÇÃO OBTER GLOBOID ############################ 

# Função onde o resultado (return) sempre será o GLOBOID, mesmo que o parâmetro informando seja o e-mail.

def key_user(): 
    try:
        param1 = sys.argv[1]

        if '@' in  param1:
            
            headers = {
            'Backstage-Client-Id': 'developer',
            }

            response = requests.get('http://be.glive.globoi.com/v2/users/email/'+ param1, headers=headers)

            globoid = response.json()
            
            globoid = globoid["globoId"]
            
            email = param1
            
            return globoid

        elif param1.find('@') != True:

            headers = {
            'Backstage-Client-Id': 'developer',
            }

            response = requests.get('http://be.glive.globoi.com/v2/users/'+ param1, headers=headers)

            email = response.json()

            email = email["email"]
            
            return param1 
    
    except:

        print("Favor informar um GloboID ou E-mail valido")
        sys.exit()

    else:
        sys.exit()

    
    
###################### GERA INFORMACÃO CADASTRAL DO USUÁRIO NO GLIVE ############################ 

if len(sys.argv) < 2: # Verifica quantos args vai receber, o nome do programa conta como 1
    
    print(help)
               
else:
    key = key_user()


    headers = {
        "Backstage-Client-Id": "developer",
        }

##
    cons_email = requests.get('http://be.glive.globoi.com/v2/users/'+ key, headers=headers) # Consulta o email através do globoid

    email = cons_email.json()

    email = email["email"]
##
    info1 = requests.get("http://be.glive.globoi.com/v2/users/" + key, headers=headers).json()

    dados = json.dumps(info1, indent = 4)
    
    print (IYellow + "\n==================== GLIVE  ====================\n" + NC)
    print ("Informações do Glive do usuário de Email " + email + " com o GloboID " + key)
    #print (IYellow + "\n===============================================\n" + NC)
    print (IYellow + "\n====== DADOS DO USUÁRIO PELO GLIVE ======\n" + NC)
    print (dados)
    print (IYellow + "\n====== SERVIÇOS DO USUÁRIO PELO GLIVE ======\n" + NC)

    services_list = requests.get('http://be.glive.globoi.com/v2/users/' + key + '/services', headers=headers)

    serviceid = services_list.json()

    services_list = requests.get('http://be.glive.globoi.com/v2/users/'+ key +'/services', headers=headers)

serviceid = services_list.json()

for x in serviceid [0:100]: # retirando dicionario de uma lista de distruição
    dict = {}
    dict.update(x)
    x = x ["serviceId"]
    #print (x)

###################### CONSULTA DISPLAY NAME DO SERVIÇO GLOBOID ############################
    y = str(x)
    headers = {
        'Backstage-Client-Id': 'developer',
    }

    response = requests.get('http://be.glive.globoi.com/v2/services/'+ y, headers=headers)

    name_serviceid = response.json()

    name_serviceid = name_serviceid["description"]
    
    chave2= "description"
    dict2 = {} # Criando dicionário para display name dos serviços
    dict2 [chave2] = name_serviceid
    #print (dict2)
    
    dict.update(dict2) # Atualizando dicionário de serviços do GloboID informado
    
    resultjson = json.dumps(dict, indent = 4)
    
    print (resultjson)
