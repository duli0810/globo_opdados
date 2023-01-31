#!/usr/bin/python3
# -*- coding: utf-8 -*-

########################## INFORMAÇOES ##########################################
#
#Nome do Script : infouserall.py
#Descriçao      : Lista as informações do usuário cadastrada no Glive. 
#Autor          : Eduardo Rodrigues da Silva
#Email          : eduardo.rodrigues@g.globo
#Equipe         : Operaçao Dados
#versao         : 2.1
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
###################### GERA BS-TOKEN ############################ 

headers = {
    'Authorization': 'Basic RUQxOFgvUXBNaTNjMlFDSFlBWEJKUT09Ojl1aGlmWG5kdGpoN01LZzVSMG5nMWc9PQ==',
}

data = {
    'grant_type': 'client_credentials',
}

BSToken = requests.post('https://accounts.backstage.globoi.com/token', headers=headers, data=data).json()

#BSToken = BSToken.json()

BSToken = BSToken["access_token"]

#print(BSToken)

###################### FUNÇÃO OBTER GLOBOID ############################ 

if len(sys.argv) < 2: # Verifica quantos args vai receber, o nome do programa conta como 1
    
    print(help)
    sys.exit()
               
else:
    
    param1 = sys.argv[1]
    
    try:
            
            if '@' in  param1:
                    
                    headers = {
                    'Backstage-Client-Id': 'developer',
                    }

                    response = requests.get('http://be.glive.globoi.com/v2/users/email/'+ param1, headers=headers).json()

                    globoid = response["globoId"]
                    
                    email = param1
                    
            elif param1.find('@') != True:

                    headers = {
                    'Backstage-Client-Id': 'developer',
                    }

                    response = requests.get('http://be.glive.globoi.com/v2/users/'+ param1, headers=headers).json()

                    email = response["email"]

                    globoid = param1

    except:
                print (IYellow + "\n===================== OPS ====================\n" + NC)
                print (f'Favor informar um GloboID ou E-mail válido.')
                print (IYellow + "\n===============================================\n" + NC)
                sys.exit()

###################### GERA INFORMACÃO CADASTRAL DO USUÁRIO NO GLIVE ############################ 

#key = key_user()


info1 = requests.get("http://be.glive.globoi.com/v2/users/" + globoid, headers=headers).json()

dados = json.dumps(info1, indent = 4)

#print (dados)

################################# TYPE USER - PAY #################################################
headers = {
        'Backstage-Client-Id': 'developer',
    }

pay_user = requests.get('http://be.glive.globoi.com/v2/users/'+ globoid +'/subscription/status', headers=headers).json()

pay_user = pay_user['status']

#print (pay_user)

###################### GERA INFORMACÃO DO SERVIÇOS DO USUÁRIO NO GLIVE ############################
         
def service():
    headers = {
                "Backstage-Client-Id": "developer",
                }

    services_list = requests.get('http://be.glive.globoi.com/v2/users/' + globoid + '/services', headers=headers)

    serviceid = services_list.json()

    services_list = requests.get('http://be.glive.globoi.com/v2/users/'+ globoid +'/services', headers=headers)

    serviceid = services_list.json()

    for x in serviceid [0:100]: # retirando dicionario de uma lista de distruição
        dict = {}
        dict.update(x)
        x = x ["serviceId"]
        #print (x)

    ###################### CONSULTA DISPLAY NAME DO SERVIÇO GLOBOID #################################
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

#service()

################################# ALF #############################################################

def alf():

    headers = {
        'Authorization': f'Bearer {BSToken}',
    }


    const_alf = requests.get('https://alf-be.backstage.globoi.com/admin/v1/users/'+ globoid, headers=headers).json()


    for alf in const_alf [0:100]: # retirando dicionario de uma lista de distruição
        dict = {}
        dict.update(alf)
        if "associationList" in dict:

            alf = alf["associationList"]
            alf = json.dumps(alf, indent = 4)
            print (f'{IGreen}O (a) usuário (a) {IBlue}{email}{NC}{IGreen} possui associação com operadora:{NC}')
            print(alf)

        else:
            #print ("Usuário não esta associado a operadora")
            print (f'{IRed}Usuário NÃO esta associado a nenhuma operadora{NC}')


######################################### RESULTADOS ###############################################

print (IYellow + "\n==================== GLIVE  ====================\n" + NC)

print (f'O (a) usuário (a) {IBlue}{email}{NC}, GloboID {IBlue}{globoid}{NC} é considerado um cliente {IBlue}{pay_user}{NC}')

print (IYellow + "\n========== DADOS DO USUÁRIO PELO GLIVE ==========\n" + NC)

print (dados)

print (IYellow + "\n===================== ALF ==========================\n" + NC)

alf()

print (IYellow + "\n======== SERVIÇOS DO USUÁRIO PELO GLIVE ============\n" + NC)

service()